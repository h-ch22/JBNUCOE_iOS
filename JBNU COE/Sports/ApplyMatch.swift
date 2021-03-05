//
//  ApplyMatch.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/20.
//

import SwiftUI
import NMapsMap
import FirebaseFirestore
import FirebaseAuth

enum applyAlert{
    case noPeople, blank, done, err, limit
}

struct ApplyMatch: View {
    @State var event = ""
    @State var date = ""
    @State var time = ""
    @State var location = ""
    @State var showDatePicker = false
    @Binding var showModal : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selectedDate = Date()
    @State var numOfPeople = ""
    @State var applyPeople = ""
    @State var showAlert = false
    @State var applyAlert : applyAlert = .blank
    @State var latlng = NMGLatLng()
    @State var symbol = ""
    @State var limit = ""
    @State var showMapView = false
    @State var name = ""
    @EnvironmentObject var userManagement : UserManagement

    let dateFormatter: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        return dateFormat
    }()
    
    func setData(latlng: NMGLatLng){
        
    }
    
    func setData(symbol: String){
        
    }
    
    func getPhone(){
        db = Firestore.firestore()
        let docRef = db.collection("User").document(userManagement.mail)
        docRef.getDocument{(document, error) in
            if let document = document{
                upload(phone: document.get("phone") as! String)
            }
        }
    }
    
    func upload(phone : String){
        db = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm"
        
        let dateString = dateFormatter.string(from: selectedDate)
        
        let sportsDoc = Sports(name: name,
                               allPeople: Int(numOfPeople)!,
                               currentPeople: Int(applyPeople)!,
                               date: dateString,
                               event: event,
                               limit: limit,
                               location: location,
                               adminName: userManagement.name,
                               studentNo: userManagement.studentNo,
                               dept: userManagement.dept,
                               phone : phone
                            )
        
        let data : [String : Any] = [
            "allPeople" : sportsDoc.allPeople,
            "currentPeople" : sportsDoc.currentPeople,
            "date" : sportsDoc.date,
            "event" : sportsDoc.event,
            "limit" : sportsDoc.limit,
            "location" : sportsDoc.location,
            "adminName" : sportsDoc.adminName,
            "studentNo" : sportsDoc.studentNo,
            "dept" : sportsDoc.dept,
            "phone" : phone,
            "mail" : userManagement.mail
            
        ]
        let docRef = db.collection("Sports")
            .document(sportsDoc.name)
        
        docRef.setData(data){err in
            if let err = err{
                applyAlert = .err
                showAlert = true
            }
            
            else{
                applyAlert = .done
                showAlert = true
            }
        }

    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Group{
                        Spacer()
                        
                        Text("아래 필드를 모두 입력해주세요.")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Spacer()

                        Form{
                            DatePicker("날짜 및 시간", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                            
                        }.frame(height : 100)
                        
                        Spacer()
                        
                        TextField("방 이름", text: $name)
                            .padding(20)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Spacer()
                        
                        TextField("종목명", text: $event)
                            .padding(20)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Spacer()
                    }
                    
                    HStack {
                        TextField("전체 인원 (본인 포함)", text: $numOfPeople)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            
                        
                        TextField("모집된 인원 (본인 포함)", text: $applyPeople)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)

                    }.padding(20)
                    
                    HStack {
                        if !latlng.isEmpty{
                            var lat = latlng.lat as! String
                            var lng = latlng.lng as! String
                            
                            Text(lat + ", " +  lng)
                        }
                        
                        if symbol != "" {
                            Text("장소 : " + symbol)
                        }
                        

                        TextField("장소", text: $location)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                    

                        Button(action: {
                            showMapView = true
                        }){
                            Image(systemName: "map.fill")
                        }
                    }.padding(20)
                    
                    TextField("기타 제한 사항", text: $limit)
                        .padding(20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    VStack{
                        Spacer()
                        
                        Text("제 3자 개인정보 제공 사항")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("성명, 학과, 학번, 연락처")
                        
                        Spacer()
                        
                        Text("아래 버튼을 클릭함으로 위 정보를 제 3자에게\n제공하는 것에 대해 동의하는 것으로 간주합니다.")
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                    }.frame(width : 350, height : 200)
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.gray).opacity(0.2))
                    
                    Spacer()
                    
                    Button(action: {
                        if selectedDate == nil || event == "" || location == "" ||
                            applyPeople == "" || numOfPeople == "" || name == ""{
                            applyAlert = .blank
                            showAlert = true
                        }
                        
                        if numOfPeople == "0"{
                            applyAlert = .noPeople
                            showAlert = true
                        }
                        
                        if Int(applyPeople)! > Int(numOfPeople)!{
                            applyAlert = .limit
                            showAlert = true
                        }
                        
                        else{
                            getPhone()
                        }
                    }){
                        HStack{
                            Text("용병 구인 신청하기")
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                    }.frame(width: 250, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.blue))
                    
                    Spacer()

                    Text("공과대학 학생회는 용병 구인 및 스포츠 진행에 있어\n중계 역할만 진행하며, 스포츠 진행 및 구인 도중 발생하는\n모든 문제에 대해 책임지지 않습니다.")
                        .multilineTextAlignment(.center)
                        .padding(15)
                    
                }.navigationBarTitle("용병 구인 신청하기")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                }){Text("닫기")})
                
                .alert(isPresented: $showAlert){
                    switch applyAlert{
                    case .blank :
                        return Alert(title: Text("공백 필드"), message: Text("모든 필드를 입력해주세요."), dismissButton: .default(Text("확인")))
                        
                    case .noPeople:
                        return Alert(title: Text("모집 인원 오류"), message: Text("전체 인원은 0명 이상이어야합니다."), dismissButton: .default(Text("확인")))
                        
                    case .err:
                        return Alert(title: Text("업로드 실패"), message: Text("업로드 중 오류가 발생하였습니다.\n정상 로그인 여부, 네트워크 상태를 확인한 후 다시시도하십시오."), dismissButton: .default(Text("확인")))
                        
                    case .done:
                        return Alert(title: Text("업로드 완료"), message: Text("입력하신 데이터가 정상적으로 업로드되었습니다."), dismissButton: .default(Text("확인")))
                        
                    case .limit:
                        return Alert(title: Text("인원 수 제한"), message: Text("모집 인원보다 현재 인원이 더 많을 수 없습니다."), dismissButton: .default(Text("확인")))
                    }
                    
                }
                .sheet(isPresented: $showMapView, content: {
                    SportsMapView(showView : $showMapView)
                })
            }
        }
        
    }
}

struct ApplyMatch_Previews: PreviewProvider {
    static var previews: some View {
        ApplyMatch(showModal: .constant(true))
    }
}
