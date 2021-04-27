//
//  DeliveryView.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/04/17.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

enum deliveryAlert{
    case noDate, noWaybill, failed, success
}

struct DeliveryView: View {
    @State var showDatePicker = false
    @State var selectedDate = Date()
    @State var Waybill = ""
    @State var companies = ["CJ 대한통운", "기타 (쿠팡 등)", "우체국택배", "한진택배", "롯데택배", "로젠택배", "홈픽택배", "CVSNet 편의점 택배(GS25)", "경동택배", "대신택배", "일양로지스", "합동택배", "건영택배", "천일택배", "한덱스", "한의사랑택배",
    "EMS", "DHL", "TNT Express", "UPS", "Fedex", "USPS", "i-Parcel", "DHS Global Mail", "판토스", "에어보이익스프레스", "GSMNtoN", "ECMS Express", "KGL 네트웍스", "굿투럭", "호남택배", "GSI Express", "SLX 택배", "우리한방택배",
    "세방", "KGB 택배", "Cway Express", "YJS글로벌 (영국)", "성원글로벌카고", "홈이노베이션로지스", "은하쉬핑", "Giant Network Group", "FLF퍼레버택배", "농협택배", "YJS글로벌(월드)", "디디로지스", "대림통운", "LOTOS CORPORATION",
    "애니트랙", "성훈물류", "IK물류", "엘서비스", "티피엠코리아(주) 용달이 특송", "제니엘시스템", "스마트로지스", "이투마스 (ETOMARS)", "풀엣홈", "프레시솔루션", "큐런택배", "두발히어로", "하이브시티", "오늘의픽업", "펜스타국제특송 (PIEX)",
    "지니고 당일특급", "로지스밸리", "롯데국제특송", "나은물류", "한샘서비스원 택배", "배송하기좋은날 (SHIPNERGY)", "NDEX KOREA", "도도플렉스(dodoflex)", "브릿지로지스(주)", "허브넷로지스틱스", "MEXGLOBAL", "A.C.E EXPRESS INC"]
    
    @State var selected = 0
    @State var others = ""
    @State var showAlert = false
    @State var alertType : deliveryAlert = .noWaybill
    
    func upload(){
        db = Firestore.firestore()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm:ss"
        let current_str = dateFormatter.string(from: Date())
                
        let docRef = db.collection("Delivery").document(Auth.auth().currentUser?.email as! String + "_" + current_str)
        let userRef = db.collection("User").document(Auth.auth().currentUser?.email as! String)
        
        userRef.getDocument(){(document, err) in
            if let document = document{
                let dept = document.get("dept") as! String
                let name = document.get("name") as! String
                let phone = document.get("phone") as! String
                let studentNo = document.get("studentNo") as! String
                
                let data : [String : Any] = [
                    "Waybill" : companies[selected] + " " + Waybill,
                    "date" : selectedDate,
                    "others" : others,
                    "requested" : current_str,
                    "isReceipt" : false,
                    "name" : name,
                    "studentNo" : studentNo,
                    "dept" : dept,
                    "phone" : phone
                ]
                
                docRef.setData(data){err in
                    if let err = err{
                        alertType = .failed
                        showAlert = true
                    }
                    
                    else{
                        alertType = .success
                        showAlert = true
                    }
                }
            }
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    VStack{
                        Text("공과대학 학생회실로 주소를 설정한 후\n배송지 정보를 업로드해주세요.")
                            .multilineTextAlignment(.center)
                            .fixedSize()
                    }

                    
                    Spacer().frame(height : 30)
                    
                    Text("전라북도 전주시 덕진구 백제대로 567\n전북대학교 공과대학 1호관 243호,\n공과대학 학생회실")
                        .multilineTextAlignment(.center)
                        .frame(width : 350)
                        .padding([.vertical], 30)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.blue).opacity(0.2))
                        .fixedSize()
                    
                    Spacer().frame(height : 30)
                    
                    Form{
                        DatePicker("예상 도착일".localized(), selection: $selectedDate, displayedComponents: [.date])
                        
                    }.frame(height : 100)
                    
                    Spacer().frame(height : 30)
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            Picker(selection: $selected, label: Text("택배사 선택".localized())){
                                ForEach(0..<companies.count){
                                    Text(self.companies[$0])
                                }
                            }.pickerStyle(MenuPickerStyle())
                            
                            Text(companies[selected])
                        }
                        
                        Spacer().frame(width : 20)
                        
                        if selected != 1{
                            TextField("운송장 번호", text: $Waybill)
                                .keyboardType(.numberPad)
                        }
                        
                        else{
                            Text("조회 불가능한 택배사")
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }.padding(20)

                    
                    Spacer().frame(height : 20)
                    
                    TextField("기타 선택 메시지 (예 : 파손 주의)", text: $others)
                        .padding(20)
                    
                    Spacer().frame(height : 20)
                }

                VStack{
                    Spacer()
                    
                    Text("회원 정보 조회 동의".localized())
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("성명, 학과, 학번, 연락처".localized())
                    
                    Spacer()
                    
                    Text("조회 목적 : 신원 확인 및 수령 시 본인 확인".localized())
                        .fontWeight(.semibold)

                    Spacer()
                    
                    Text("아래 버튼을 클릭함으로 위 정보를\n조회하는 것에 대해 동의하는 것으로 간주합니다.".localized())
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                }.frame(width : 350, height : 200)
                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.gray).opacity(0.2))
                
                Spacer().frame(height : 30)

                VStack {
                    Text("본인 확인을 위해 본인 이름으로 발송된 택배만\n대리 수령이 가능합니다.".localized())
                        .multilineTextAlignment(.center)
                        .fixedSize()
                }
                
                Spacer().frame(height : 30)
                
                VStack {
                    Text("공과대학 학생회는 단순 택배 보관 역할만 진행하며,\n주소 오기재, 배송 도중 파손 등으로 인해\n발생하는 피해에 대해 책임지지 않습니다.".localized())
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                        .fixedSize()
                }

                Spacer()
                
                Button(action : {
                    if selected == 1{
                        Waybill = "조회 불가능한 택배사"
                    }
                    
                    if Waybill == ""{
                        alertType = .noWaybill
                        showAlert = true
                    }
                    
                    else{
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy. MM. dd."
                        
                        let current_str = dateFormatter.string(from: Date())
                        let selected_str = dateFormatter.string(from: selectedDate)
                        
                        let current_date = dateFormatter.date(from: current_str)
                        let selected_date = dateFormatter.date(from : selected_str)
                        
                        if current_date! > selected_date!{
                            alertType = .noDate
                            showAlert = true
                        }
                        
                        else{
                            upload()
                        }
                    }
                }){
                    HStack{
                        Text("대리 수령 요청 하기")
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }.frame(width : 250, height : 40)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(25)
                    
                }
            }
        }.navigationBarTitle(Text("택배 대리 수령 요청"))
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(trailing:
            NavigationLink(destination: DeliveryLog(getData: getDeliveryLog())) {
                Text("요청 기록 확인하기")
           }
        )
        .alert(isPresented: $showAlert){
            switch alertType{
            case .noDate:
                return Alert(title: Text("경고"), message: Text("예상 도착일이 현재보다 과거일 수 없습니다."), dismissButton: .default(Text("확인")))
            case .noWaybill:
                return Alert(title: Text("경고"), message: Text("운송장 번호를 입력하십시오."), dismissButton: .default(Text("확인")))

            case .failed:
                return Alert(title: Text("업로드 실패"), message: Text("업로드 중 오류가 발생하였습니다.\n네트워크 상태를 확인하거나 나중에 다시 시도하십시오.\n지금 수동으로 대리 수령을 요청하시려면, 공과대학 SNS에 문의하십시오."), dismissButton: .default(Text("확인")))

            case .success:
                return Alert(title: Text("업로드 완료"), message: Text("정상 처리되었습니다.\n택배를 수령하려면, 공과대학 학생회실로 방문하십시오."), dismissButton: .default(Text("확인")))

            }
            
        }
    }
}

struct DeliveryView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryView()
    }
}
