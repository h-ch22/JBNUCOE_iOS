//
//  Products.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/02/21.
//

import SwiftUI
import FirebaseFirestore

struct Products: View {
    @State var batteryLate : Int = 0
    @State var calculatorLate : Int = 0
    @State var labcoatLate : Int = 0
    @State var umbrellaLate : Int = 0
    @State var serviceStatus : Bool = true
    
    func getData(){
        db = Firestore.firestore()
        
        let statusRef = db.collection("Products").document("status")
        let batteryRef = db.collection("Products").document("battery")
        let calculatorRef = db.collection("Products").document("calculator")
        let labcoatRef = db.collection("Products").document("labcoat")
        let umbrellaRef = db.collection("Products").document("umbrella")
        
        statusRef.getDocument(){(document, err) in
            if let document = document{
                var status = document.get("isAvailable") as! Bool
                
                var openTime = "09:00"
                var closeTime = "18:00"
                var now = Date()
                var calendar = Calendar.current
                var dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd kk:mm"
                dateFormatter.timeZone = TimeZone(identifier: "UTC+9")

                var TimeFormat = DateFormatter()
                TimeFormat.dateFormat = "kk:mm"
                TimeFormat.timeZone = TimeZone(identifier: "UTC+9")

                var DayFomrat = DateFormatter()
                DayFomrat.dateFormat = "yyyy-MM-dd"
                DayFomrat.timeZone = TimeZone(identifier: "UTC+9")

                var open = String()
                open = DayFomrat.string(from: now) + " " + openTime
                var close = String()
                close = DayFomrat.string(from: now) + " " + closeTime
                
                var nowTime_str = TimeFormat.string(from: now)
                var nowTime = TimeFormat.date(from: nowTime_str)
                
                var open_date = Date()
                var close_date = Date()
                
                if let openDate = open.toDate(){
                    open_date = openDate
                }

                if let closeDate = close.toDate(){
                    close_date = closeDate
                }
                
                let currentDate_str = dateFormatter.string(from: now)
                var currentDate = Date()
                currentDate = dateFormatter.date(from: currentDate_str)!
                
                if currentDate > close_date{
                    close_date = close_date + 86401
                }
                
                print("current : ", currentDate)
                print("open : " , open_date)
                print("close : " , close_date)

                if currentDate > open_date && currentDate < close_date && status{
                    serviceStatus = true
                }
                
                else{
                    serviceStatus = false
                }
            }
        }
        
        batteryRef.getDocument(){(document, err) in
            if let document = document{
                batteryLate = document.get("late") as! Int
            }
        }
        
        labcoatRef.getDocument(){(document, err) in
            if let document = document{
                labcoatLate = document.get("late") as! Int
            }
        }
        
        calculatorRef.getDocument(){(document, err) in
            if let document = document{
                calculatorLate = document.get("late") as! Int
            }
        }
        
        umbrellaRef.getDocument(){(document, err) in
            if let document = document{
                umbrellaLate = document.get("late") as! Int
            }
        }
    }
    
    var body: some View {
        ScrollView{
            VStack {
                Spacer()
                
                if serviceStatus{
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .foregroundColor(.green)
                    
                    Text("서비스를 정상적으로 이용하실 수 있습니다.")
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                
                else{
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .foregroundColor(.orange)
                    
                    Text("서비스 준비 중입니다.")
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                
                Spacer()

                VStack {
                    HStack{
                        Image("ic_battery")
                            .resizable().frame(width : 50, height: 50)
                        Text("보조 배터리")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)

                        Spacer()
                        
                    }
                    
                    if batteryLate > 0{
                        HStack {
                            Image(systemName: "checkmark").resizable().frame(width : 20, height : 20).foregroundColor(.green)
                            Text("대여 가능 (잔여 : " + String(batteryLate) + "개)").foregroundColor(.green)
                            
                            Spacer()
                        }
                    }
                    
                    else{
                        HStack {
                            Image(systemName: "xmark").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                            Text("대여 불가").foregroundColor(.red)
                            
                            Spacer()
                        }
                    }
                }.padding(20)
                
                Divider()
                
                VStack {
                    HStack{
                        Image("ic_calculator")
                            .resizable().frame(width : 50, height: 50)

                        Text("공학용 계산기")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                        
                        Spacer()

                    }
                    
                    if calculatorLate > 0{
                        HStack {
                            Image(systemName: "checkmark").resizable().frame(width : 20, height : 20).foregroundColor(.green)
                            Text("대여 가능 (잔여 : " + String(calculatorLate) + "개)").foregroundColor(.green)
                            
                            Spacer()
                        }
                    }
                    
                    else{
                        HStack {
                            Image(systemName: "xmark").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                            Text("대여 불가").foregroundColor(.red)
                            
                            Spacer()
                        }
                    }
                }.padding(20)
                
                Divider()

                VStack {
                    HStack{
                        Image("ic_labcoat")
                            .resizable().frame(width : 50, height: 50)

                        Text("실험복")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)

                        Spacer()
                    }
                    
                    if labcoatLate > 0{
                        HStack {
                            Image(systemName: "checkmark").resizable().frame(width : 20, height : 20).foregroundColor(.green)
                            Text("대여 가능 (잔여 : " + String(labcoatLate) + "개)").foregroundColor(.green)
                            
                            Spacer()
                        }
                    }
                    
                    else{
                        HStack {
                            Image(systemName: "xmark").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                            Text("대여 불가").foregroundColor(.red)
                            
                            Spacer()
                        }
                    }
                }.padding(20)
                
                Divider()

                VStack {
                    HStack{
                        Image("ic_umbrella")
                            .resizable().frame(width : 50, height: 50)

                        Text("우산")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)

                        Spacer()
                    }
                    
                    if umbrellaLate > 0{
                        HStack {
                            Image(systemName: "checkmark").resizable().frame(width : 20, height : 20).foregroundColor(.green)
                            Text("대여 가능 (잔여 : " + String(umbrellaLate) + "개)").foregroundColor(.green)
                            
                            Spacer()
                        }
                    }
                    
                    else{
                        HStack {
                            Image(systemName: "xmark").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                            Text("대여 불가").foregroundColor(.red)
                            
                            Spacer()
                        }
                    }
                }.padding(20)
            
            }
        }.navigationBarTitle("대여 사업 잔여 수량 확인")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: NavigationLink(destination: ProductLog(getData: getLogData())) {
            Text("대여 기록 확인하기")
        })
        .onAppear(perform: {
            self.getData()
        })
    }
}

struct Products_Previews : PreviewProvider {
    static var previews: some View {
        Products()
    }
}
