//
//  MatchDetail.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/22.
//

import SwiftUI
import FirebaseFirestore

enum matchAlert{
    case check, success, fail, limit, already, admin, timeLimit
}

struct MatchDetail: View {
    @Binding var sports : Sports
    @State var showAlert = false
    @State var matchAlert : matchAlert = .check
    @EnvironmentObject var userManagement : UserManagement
    
    func getPhone(){
        db = Firestore.firestore()
        let docRef = db.collection("User").document(userManagement.mail)
        docRef.getDocument{(document, error) in
            if let document = document{
                apply(phone: document.get("phone") as! String)
            }
        }
    }
    
    func checkAdmin(){
        db = Firestore.firestore()
        let docRef = db.collection("Sports").document(sports.name)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                var adminMail = document.get("mail") as! String
                
                if adminMail == userManagement.mail{
                    matchAlert = .admin
                    showAlert = true
                }
                
                else{
                    var date_str = sports.date
                    let currentDate_old = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy. MM. dd. kk:mm"
                    dateFormatter.timeZone = TimeZone(identifier: "UTC+9")
                    
                    var date = dateFormatter.date(from: date_str)
                    var currentDate_str = dateFormatter.string(from: currentDate_old)
                    var currentDate = dateFormatter.date(from: currentDate_str)
                    
                    if currentDate! < date!{
                        getPhone()
                    }
                    
                    else{
                        matchAlert = .timeLimit
                        showAlert = true
                    }
                }
            }
        }
    }
    
    func apply(phone : String){
        db = Firestore.firestore()
        let docRef = db.collection("Sports").document(sports.name)
            .collection("applies").document(userManagement.mail)
        
        let updateRef = db.collection("Sports").document(sports.name)
            
        
        docRef.getDocument(){(document, err) in
            if let document = document, document.exists{
                matchAlert = .already
                showAlert = true
            }
            
            else{
                docRef.setData([
                    "dept" : userManagement.dept,
                    "name" : userManagement.name,
                    "phone" : phone,
                    "studentNo" : userManagement.studentNo
                ]){err in
                    if let err = err{
                        matchAlert = .fail
                        showAlert = true
                    }
                    
                    else{
                        updateRef.getDocument(){(document, err) in
                            if let document = document{
                                var limit = document.get("allPeople") as! Int
                                var current = document.get("currentPeople") as! Int
                                
                                if current >= limit{
                                    matchAlert = .limit
                                    showAlert = true
                                    
                                    updateRef.delete()
                                }
                                
                                else{
                                    updateRef.updateData(["currentPeople" : current + 1]){
                                        err in
                                        if let err = err{
                                            print(err)
                                        }
                                    }
                                    matchAlert = .success
                                    showAlert = true
                                }
                            }
                            
                            else{
                                print(err)
                            }
                        }
                        
                    }
                    
                }
                
                
            }
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{
                VStack {
                    Group{
                        Text("작성자 : ".localized() + sports.adminName)
                        
                        Spacer()
                        
                        Text("작성자 학과 : ".localized() + sports.dept + " " + sports.studentNo)
                        
                        Spacer()
                        
                        Text("모집 인원 : ".localized() + String(sports.allPeople))
                        
                        Spacer()
                        
                        Text("현재 인원 : ".localized() + String(sports.currentPeople))
                        
                        Spacer()
                        
                        Text("종목 : ".localized() + sports.event)
                    }
                    
                    Group{
                        Spacer()
                        
                        Text("장소 : ".localized() + sports.location)
                        
                        Spacer()
                        
                        Text("날짜 및 시간 : ".localized() + sports.date)
                        
                        Spacer()
                        
                        Text("제한 및 우대 사항 : ".localized() + sports.limit)
                        
                        Spacer()
                        
                        Text("대표자 연락처 : ".localized() + sports.phone)
                    }
                }.frame(width : UIScreen.main.bounds.width / 1.2)
                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.blue).opacity(0.2))
                
                Spacer()
                
                VStack{
                    Spacer()
                    
                    Text("제 3자 개인정보 제공 사항".localized())
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("성명, 학과, 학번, 연락처".localized())
                    
                    Spacer()
                    
                    Text("제공 목적 : 방장의 신원 확인 및 개별 연락".localized())
                    
                    Spacer()
                    
                    Text("아래 버튼을 클릭함으로 위 정보를 제 3자에게\n제공하는 것에 대해 동의하는 것으로 간주합니다.".localized())
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                }.frame(width : 350, height : 200)
                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.gray).opacity(0.2))
                
                Spacer()
                
                Button(action: {
                    self.matchAlert = .check
                    showAlert = true
                }) {
                    HStack{
                        Text("지원하기".localized())
                            .foregroundColor(.white)
                        Image(systemName : "chevron.right")
                            .foregroundColor(.white)
                    }
                }.padding(20)
                .frame(width : UIScreen.main.bounds.width / 2)
                .background(RoundedRectangle(cornerRadius : 16).foregroundColor(.blue))
                
                Spacer()
                
                Text("공과대학 학생회는 용병 구인 및 스포츠 진행에 있어\n중계 역할만 진행하며, 스포츠 진행 및 구인 도중 발생하는\n모든 문제에 대해 책임지지 않습니다.".localized())
                    .multilineTextAlignment(.center)
                    .padding(15)
                
            } .navigationBarTitle(sports.name, displayMode: .large)
            
        }
        .alert(isPresented: $showAlert){
            switch matchAlert{
            case .check :
                return Alert(title: Text("지원 확인".localized()), message: Text("지원하시겠습니까?".localized()), primaryButton: .destructive(Text("예".localized()), action: {
                    checkAdmin()
                }), secondaryButton: .default(Text("아니오".localized())))
                
            case .success:
                return Alert(title: Text("지원 완료".localized()), message: Text("정상 처리되었습니다.".localized()), dismissButton: .default(Text("확인".localized())))
                
            case .fail:
                return Alert(title: Text("지원 실패".localized()), message: Text("처리 중 오류가 발생하였습니다.\n정상 로그인 여부, 네트워크 상태 및 기지원 여부를 확인한 후 다시 시도하십시오.".localized()), dismissButton: .default(Text("확인".localized())))
                
            case .limit:
                return Alert(title: Text("인원 초과".localized()), message: Text("모집 인원을 초과했습니다.".localized()), dismissButton: .default(Text("확인".localized())))
                
            case .already:
                return Alert(title: Text("기지원자".localized()), message: Text("이미 지원한 방입니다.".localized()), dismissButton: .default(Text("확인".localized())))
                
            case .admin:
                return Alert(title: Text("관리자 오류".localized()), message: Text("방의 관리자는 지원하실 수 없습니다.(기지원자)".localized()), dismissButton: .default(Text("확인".localized())))
                
            case .timeLimit:
                return Alert(title: Text("지원 기간 초과".localized()), message : Text("지원 기간이 아닙니다.".localized()), dismissButton: .default(Text("확인".localized())))
            }
            
        }
        
    }
}
