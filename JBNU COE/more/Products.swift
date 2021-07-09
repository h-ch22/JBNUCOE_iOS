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
    @State var admin : String = ""
    @State var uniformLate : Int = 0
    @State var slipperLate : Int = 0
    @State var helmetLate : Int = 0
    @State var Late_230 : Int = 0
    @State var Late_240 : Int = 0
    @State var Late_250 : Int = 0
    @State var Late_260 : Int = 0
    @State var Late_270 : Int = 0
    @State var Late_280 : Int = 0
    
    
    func getData(){
        db = Firestore.firestore()
        
        let statusRef = db.collection("Products").document("status")
        let batteryRef = db.collection("Products").document("battery")
        let calculatorRef = db.collection("Products").document("calculator")
        let labcoatRef = db.collection("Products").document("labcoat")
        let umbrellaRef = db.collection("Products").document("umbrella")
        let slipperRef = db.collection("Products").document("slipper")
        let uniformRef = db.collection("Products").document("uniform")
        let helmetRef = db.collection("Products").document("helmet")
        
        statusRef.getDocument(){(document, err) in
            if let document = document{
                var status = document.get("isAvailable") as! Bool
                var admin = document.get("admin") as! String
                
                self.admin = admin
                
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

                if currentDate > open_date && currentDate < close_date && status && admin != ""{
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
        
        slipperRef.getDocument(){(document, err) in
            if let document = document{
                slipperLate = document.get("late") as! Int
                Late_230 = document.get("230") as! Int
                Late_240 = document.get("240") as! Int
                Late_250 = document.get("250") as! Int
                Late_260 = document.get("260") as! Int
                Late_270 = document.get("270") as! Int
                Late_280 = document.get("280") as! Int
            }
        }
        
        uniformRef.getDocument(){(document, err) in
            if let document = document{
                uniformLate = document.get("late") as! Int
            }
        }
        
        helmetRef.getDocument(){(document, err) in
            if let document = document{
                helmetLate = document.get("late") as! Int
            }
        }
    }
    
    var body: some View {
        ScrollView{
            VStack {
                Spacer()
                
                if serviceStatus{
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .foregroundColor(.green)
                    
                    Text("서비스를 정상적으로 이용하실 수 있습니다.".localized())
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Text("현재 관리자 : \(admin)")
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                
                else{
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .foregroundColor(.orange)
                    
                    Text("서비스 준비 중입니다.".localized())
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    
                    Text("점심 시간 : 12:00 ~ 13:00".localized())
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                
                Spacer()

                Group{
                    VStack {
                        HStack{
                            Image("ic_battery")
                                .resizable().frame(width : 50, height: 50)
                            Text("보조 배터리".localized())
                                .fontWeight(.semibold)

                            Spacer()
                            
                        }
                        
                        if batteryLate > 0{
                            HStack {
                                Image(systemName: "checkmark").resizable().frame(width : 20, height : 20).foregroundColor(.green)
                                Text("대여 가능 (잔여 : ".localized() + String(batteryLate) + "개)".localized()).foregroundColor(.green)
                                
                                Spacer()
                            }
                        }
                        
                        else{
                            HStack {
                                Image(systemName: "xmark").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                                Text("대여 불가".localized()).foregroundColor(.red)
                                
                                Spacer()
                            }
                        }
                    }.padding(20)
                    
                    Divider()
                    
                    VStack {
                        HStack{
                            Image("ic_calculator")
                                .resizable().frame(width : 50, height: 50)

                            Text("공학용 계산기".localized())
                                .fontWeight(.semibold)
                            
                            Spacer()

                        }
                        
                        if calculatorLate > 0{
                            HStack {
                                Image(systemName: "checkmark").resizable().frame(width : 20, height : 20).foregroundColor(.green)
                                Text("대여 가능 (잔여 : ".localized() + String(calculatorLate) + "개)".localized()).foregroundColor(.green)
                                
                                Spacer()
                            }
                        }
                        
                        else{
                            HStack {
                                Image(systemName: "xmark").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                                Text("대여 불가".localized()).foregroundColor(.red)
                                
                                Spacer()
                            }
                        }
                    }.padding(20)
                    
                    Divider()

                    VStack {
                        HStack{
                            Image("ic_labcoat")
                                .resizable().frame(width : 50, height: 50)

                            Text("실험복".localized())
                                .fontWeight(.semibold)

                            Spacer()
                        }
                        
                        if labcoatLate > 0{
                            HStack {
                                Image(systemName: "checkmark").resizable().frame(width : 20, height : 20).foregroundColor(.green)
                                Text("대여 가능 (잔여 : ".localized() + String(labcoatLate) + "개)".localized()).foregroundColor(.green)
                                
                                Spacer()
                            }
                        }
                        
                        else{
                            HStack {
                                Image(systemName: "xmark").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                                Text("대여 불가".localized()).foregroundColor(.red)
                                
                                Spacer()
                            }
                        }
                    }.padding(20)
                    
                    Divider()
                }

                Group{
                    VStack {
                        HStack{
                            Image("ic_umbrella")
                                .resizable().frame(width : 50, height: 50)

                            Text("우산".localized())
                                .fontWeight(.semibold)

                            Spacer()
                        }
                        
                        if umbrellaLate > 0{
                            HStack {
                                Image(systemName: "checkmark").resizable().frame(width : 20, height : 20).foregroundColor(.green)
                                Text("대여 가능 (잔여 : ".localized() + String(umbrellaLate) + "개)".localized()).foregroundColor(.green)
                                
                                Spacer()
                            }
                        }
                        
                        else{
                            HStack {
                                Image(systemName: "xmark").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                                Text("대여 불가".localized()).foregroundColor(.red)
                                
                                Spacer()
                            }
                        }
                    }.padding(20)
                    
                    Divider()

                    VStack {
                        HStack{
                            Image("ic_slippers")
                                .resizable().frame(width : 50, height: 50)

                            Text("슬리퍼".localized())
                                .fontWeight(.semibold)

                            Spacer()
                        }
                        
                        if slipperLate > 0{
                            HStack {
                                Image(systemName: "checkmark").resizable().frame(width : 20, height : 20).foregroundColor(.green)
                                Text("대여 가능 (잔여 : ".localized() + String(slipperLate) + "개)".localized()).foregroundColor(.green)
                                
                                Spacer()
                            }
                            
                            HStack{
                                Text("240 : \(Late_240), 250 : \(Late_250),\n260 : \(Late_260), 270 : \(Late_270), 280 : \(Late_280)")
                                    .foregroundColor(.green)
                            }
                        }
                        
                        else{
                            HStack {
                                Image(systemName: "xmark").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                                Text("대여 불가".localized()).foregroundColor(.red)
                                
                                Spacer()
                            }
                        }
                    }.padding(20)
                    
                    Divider()

                    VStack {
                        HStack{
                            Image("ic_uniform")
                                .resizable().frame(width : 50, height: 50)

                            Text("유니폼".localized())
                                .fontWeight(.semibold)

                            Spacer()
                        }
                        
                        if uniformLate > 0{
                            HStack {
                                Image(systemName: "checkmark").resizable().frame(width : 20, height : 20).foregroundColor(.green)
                                Text("대여 가능 (잔여 : ".localized() + String(uniformLate) + "개)".localized()).foregroundColor(.green)
                                
                                Spacer()
                            }
                        }
                        
                        else{
                            HStack {
                                Image(systemName: "xmark").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                                Text("대여 불가".localized()).foregroundColor(.red)
                                
                                Spacer()
                            }
                        }
                    }.padding(20)
                    
                    Divider()

                    VStack {
                        HStack{
                            Image("ic_helmet")
                                .resizable().frame(width : 50, height: 50)

                            Text("헬멧".localized())
                                .fontWeight(.semibold)

                            Spacer()
                        }
                        
                        if helmetLate > 0{
                            HStack {
                                Image(systemName: "checkmark").resizable().frame(width : 20, height : 20).foregroundColor(.green)
                                Text("대여 가능 (잔여 : ".localized() + String(helmetLate) + "개)".localized()).foregroundColor(.green)
                                
                                Spacer()
                            }
                        }
                        
                        else{
                            HStack {
                                Image(systemName: "xmark").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                                Text("대여 불가".localized()).foregroundColor(.red)
                                
                                Spacer()
                            }
                        }
                    }.padding(20)
                }

            
            }
        }.navigationBarTitle("대여 사업 잔여 수량 확인".localized())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: NavigationLink(destination: ProductLog(getData: getLogData())) {
            Text("대여 기록 확인하기".localized())
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
