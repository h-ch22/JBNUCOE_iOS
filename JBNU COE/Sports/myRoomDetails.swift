//
//  myRoomDetails.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/30.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class getApplies:ObservableObject{
    @Published var applies: [Applies] = []
    
    func getApplies(name : String){
        db = Firestore.firestore()
        let docRef = db.collection("Sports").document(name)
            .collection("applies")
        
        docRef.getDocuments(){querySnapshot, err in
            if let err = err{
                print(err)
            }
            
            else{
                for document in querySnapshot!.documents{
                    self.applies.append(Applies(name: document.get("name") as! String, studentNo: document.get("studentNo") as! String, dept: document.get("dept") as! String, phone: document.get("phone") as! String))
                }
            }
        }
    }
    
}

enum remove{
    case check, done, fail, cancelSuccess, cancelFail, cancelCheck
}

struct myRoomDetails: View {
    @Binding var sports : Sports
    @ObservedObject var getApplies: getApplies
    @State var showAlert = false
    @State var remove : remove = .check
    @EnvironmentObject var userManagement : UserManagement
    
    func cancel(){
        let docRef = db.collection("Sports").document(sports.name).collection("applies").document((Auth.auth().currentUser?.email)!).delete(){err in
            if let err = err{
                print(err)
            }
            
            else{
                let updateRef = db.collection("Sports").document(sports.name)
                
                let current = updateRef.getDocument(){(document, err) in
                    if let document = document{
                        var current = document.get("currentPeople") as? Int
                        
                        updateRef.updateData(["currentPeople" : current! - 1]){
                            err in
                            if let err = err{
                                remove = .cancelFail
                                showAlert = true
                                print(err)
                            }
                            
                            else{
                                remove = .cancelSuccess
                                showAlert = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    func removeRoom(){
        db = Firestore.firestore()
        let docRef = db.collection("Sports").document(sports.name)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                let applyRef = docRef.collection("applies")
                
                applyRef.getDocuments(){(querySnapshot, err) in
                    if let err = err{
                        remove = .fail
                        showAlert = true
                        print(err)
                    }
                    
                    else{
                        for document in querySnapshot!.documents{
                            var memberRef = applyRef.document(document.documentID)
                            memberRef.delete()
                        }
                    }
                }
                
                docRef.delete()
                
                remove = .done
                showAlert = true
            }
            
            else{
                remove = .fail
                showAlert = true
            }
        }
    }
    
    var body: some View {
        
        VStack{
            ScrollView{
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
            }
            
            
            Spacer()
            
            Text("지원자 현황".localized())
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            List(getApplies.applies.indices, id: \.self){ index in
                AppliesRow(applies : self.$getApplies.applies[index])
            }
            
        }
        .navigationBarTitle(sports.name, displayMode: .large)
        .navigationBarItems(trailing : sports.studentNo == userManagement.studentNo ?
                                AnyView(self.deleteBtn) : AnyView(self.cancelBtn)
        )
        .onAppear(perform: {
            getApplies.getApplies(name : sports.name)
        })
        .buttonStyle(PlainButtonStyle())
        .listStyle(GroupedListStyle())
        .alert(isPresented: $showAlert){
            switch remove{
            case .check :
                return Alert(title: Text("방 제거 확인".localized()), message: Text("방 제거 시 모든 데이터가 제거되며, 복구할 수 없습니다.\n계속 하시겠습니까?".localized()), primaryButton: .destructive(Text("예".localized()), action: {
                    removeRoom()
                }), secondaryButton: .default(Text("아니오".localized())))
                
            case .done:
                return Alert(title: Text("제거 완료".localized()), message: Text("정상 처리되었습니다.".localized()), dismissButton: .default(Text("확인".localized())))
                
            case .fail:
                return Alert(title: Text("제거 실패".localized()), message: Text("처리 중 오류가 발생하였습니다.\n정상 로그인 여부, 네트워크 상태 및 기삭제 여부를 확인한 후 다시 시도하십시오.".localized()), dismissButton: .default(Text("확인".localized())))
                
            case .cancelCheck :
                return Alert(title: Text("지원 취소 확인".localized()), message: Text("지원 취소 시 관련 데이터가 삭제되며, 번복하실 수 없습니다.\n계속 하시겠습니까?".localized()), primaryButton: .destructive(Text("예".localized()), action: {
                    cancel()
                }), secondaryButton: .default(Text("아니오".localized())))
            case .cancelSuccess:
                return Alert(title: Text("취소 완료".localized()), message: Text("정상 처리되었습니다.".localized()), dismissButton: .default(Text("확인".localized())))

            case .cancelFail:
                return Alert(title: Text("취소 실패".localized()), message: Text("처리 중 오류가 발생하였습니다.\n정상 로그인 여부, 네트워크 상태 및 기취소 여부를 확인한 후 다시 시도하십시오.".localized()), dismissButton: .default(Text("확인".localized())))

            }
            
        }
    }
    
    var deleteBtn : some View{
        Button(action: {
            remove = .check
            showAlert = true
        }) {
            Image(systemName: "trash")
                .padding(5)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(40)
            
        }.frame(width: 30, height: 30)
    }
    
    var cancelBtn : some View{
        Button(action: {
            remove = .cancelCheck
            showAlert = true
        }) {
            Image(systemName: "xmark")
                .padding(5)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(40)
            
        }.frame(width: 30, height: 30)
    }
}
