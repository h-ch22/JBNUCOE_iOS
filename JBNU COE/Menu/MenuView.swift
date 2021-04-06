//
//  MenuView.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/28.
//

import SwiftUI
import SwiftSoup

struct MenuView: View {
    @State var jinsoo_lunch = ""
    @State var jinsoo_dinner = ""
    @State var jeongdam_lunch = ""
    @State var dorm_breakfirst = ""
    @State var dorm_lunch = ""
    @State var dorm_dinner = ""
    @State var chambit_breakfirst = ""
    @State var chambit_lunch = ""
    @State var chambit_dinner = ""
    @State var isSelected = ""
    
    func getDay(){
        let weekArray = ["Sun", "Mon", "Tue", "Wwd", "Thu", "Fri", "Sat"]
        
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.dateFormat = "yyyy-MM-dd"
        
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday], from: Date())
        
        isSelected = weekArray[comps.weekday! - 1]
        
        getCoopMenu()
    }
    
    func getCoopMenu(){
        
        if isSelected == ""{
            getDay()
        }
        
        else{
            let url_coop = "http://sobi.chonbuk.ac.kr/chonbuk/m040101"
            let url_dorm = "https://likehome.jbnu.ac.kr/home/main/inner.php?sMenu=B7100"
            let url_chambit = "https://likehome.jbnu.ac.kr/home/main/inner.php?sMenu=B7200"
            
            guard let url = URL(string : url_coop) else{return}
            guard let dorm = URL(string: url_dorm) else{return}
            guard let chambit = URL(string: url_chambit) else{return}
            
            do{
                let html = try String(contentsOf: url, encoding: .utf8)
                let html_dorm = try String(contentsOf: dorm, encoding: .utf8)
                let html_chambit = try String(contentsOf: chambit, encoding: .utf8)
                
                let doc : Document = try SwiftSoup.parse(html)
                let doc_dorm : Document = try SwiftSoup.parse(html_dorm)
                let doc_chambit : Document = try SwiftSoup.parse(html_chambit)
                
                switch isSelected{
                
                case "Sun" :
                    jinsoo_lunch = "운영 없음"
                    
                    jinsoo_dinner = "운영 없음"
                    
                    jeongdam_lunch = "운영 없음"
                    
                    dorm_breakfirst = "운영 없음"
                    
                    dorm_lunch = "운영 없음"
                    
                    dorm_dinner = "운영 없음"
                    
                    let chambitBreakFirst : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(1) > td:nth-child(4) > a")
                    
                    for element in chambitBreakFirst.array(){
                        chambit_breakfirst = try element.text()
                    }
                    
                    let chambitLunch : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(2) > td:nth-child(4) > a")
                    
                    for element in chambitLunch.array(){
                        chambit_lunch = try element.text()
                    }
                    
                    let chambitDinner : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(3) > td:nth-child(4) > a")
                    
                    for element in chambitDinner.array(){
                        chambit_dinner = try element.text()
                    }
                    
                    break
                    
                case "Mon" :
                    let monDay : Elements = try doc.select("#sub_right > div:nth-child(3) > div > table > tbody > tr:nth-child(2) > td:nth-child(3) > p")
                    
                    for element in monDay.array(){
                        jinsoo_lunch = try element.text()
                        print(jinsoo_lunch)
                    }
                    
                    let monDinner : Elements = try doc.select("#sub_right > div:nth-child(3) > div > table > tbody > tr:nth-child(4) > td:nth-child(3) > p")
                    
                    for element in monDinner.array(){
                        jinsoo_dinner = try element.text()
                    }
                    
                    let jeongDam : Elements = try doc.select("#sub_right > div:nth-child(9) > div > table > tbody > tr:nth-child(2) > td:nth-child(3)")
                    
                    for element in jeongDam.array(){
                        jeongdam_lunch = try element.text()
                    }
                    
                    let dormbreakFirst : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(1) > td:nth-child(3) > a")
                    
                    for element in dormbreakFirst.array(){
                        dorm_breakfirst = try element.text()
                    }
                    
                    let dormLunch : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(2) > td:nth-child(3) > a")
                    
                    for element in dormLunch.array(){
                        dorm_lunch = try element.text()
                    }
                    
                    let dormDinner : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(3) > td:nth-child(3) > a")
                    
                    for element in dormDinner.array(){
                        dorm_dinner = try element.text()
                    }
                    
                    let chambitBreakFirst : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(1) > td:nth-child(3) > a")
                    
                    for element in chambitBreakFirst.array(){
                        chambit_breakfirst = try element.text()
                    }
                    
                    let chambitLunch : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(2) > td:nth-child(3) > a")
                    
                    for element in chambitLunch.array(){
                        chambit_lunch = try element.text()
                    }
                    
                    let chambitDinner : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(3) > td:nth-child(3) > a")
                    
                    for element in chambitDinner.array(){
                        chambit_dinner = try element.text()
                    }
                    
                    break
                    
                case "Tue" :
                    let monDay : Elements = try doc.select("#sub_right > div:nth-child(3) > div > table > tbody > tr:nth-child(2) > td:nth-child(4) > p")
                    
                    for element in monDay.array(){
                        jinsoo_lunch = try element.text()
                    }
                    
                    let monDinner : Elements = try doc.select("#sub_right > div:nth-child(3) > div > table > tbody > tr:nth-child(4) > td:nth-child(4) > p")
                    
                    for element in monDinner.array(){
                        jinsoo_dinner = try element.text()
                    }
                    
                    let jeongDam : Elements = try doc.select("#sub_right > div:nth-child(9) > div > table > tbody > tr:nth-child(2) > td:nth-child(4)")
                    
                    for element in jeongDam.array(){
                        jeongdam_lunch = try element.text()
                    }
                    
                    let dormbreakFirst : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(1) > td:nth-child(4) > a")
                    
                    for element in dormbreakFirst.array(){
                        dorm_breakfirst = try element.text()
                    }
                    
                    let dormLunch : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(2) > td:nth-child(4) > a")
                    
                    for element in dormLunch.array(){
                        dorm_lunch = try element.text()
                    }
                    
                    let dormDinner : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(3) > td:nth-child(4) > a")
                    
                    for element in dormDinner.array(){
                        dorm_dinner = try element.text()
                    }
                    
                    let chambitBreakFirst : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(1) > td:nth-child(4) > a")
                    
                    for element in chambitBreakFirst.array(){
                        chambit_breakfirst = try element.text()
                    }
                    
                    let chambitLunch : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(2) > td:nth-child(4) > a")
                    
                    for element in chambitLunch.array(){
                        chambit_lunch = try element.text()
                    }
                    
                    let chambitDinner : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(3) > td:nth-child(4) > a")
                    
                    for element in chambitDinner.array(){
                        chambit_dinner = try element.text()
                    }
                    
                    break
                    
                case "Wed" :
                    let monDay : Elements = try doc.select("#sub_right > div:nth-child(3) > div > table > tbody > tr:nth-child(2) > td:nth-child(5) > p")
                    
                    for element in monDay.array(){
                        jinsoo_lunch = try element.text()
                    }
                    
                    let monDinner : Elements = try doc.select("#sub_right > div:nth-child(3) > div > table > tbody > tr:nth-child(4) > td:nth-child(5) > p")
                    
                    for element in monDinner.array(){
                        jinsoo_dinner = try element.text()
                    }
                    
                    let jeongDam : Elements = try doc.select("#sub_right > div:nth-child(9) > div > table > tbody > tr:nth-child(2) > td:nth-child(5)")
                    
                    for element in jeongDam.array(){
                        jeongdam_lunch = try element.text()
                    }
                    
                    let dormbreakFirst : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(1) > td:nth-child(5) > a")
                    
                    for element in dormbreakFirst.array(){
                        dorm_breakfirst = try element.text()
                    }
                    
                    let dormLunch : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(2) > td:nth-child(5) > a")
                    
                    for element in dormLunch.array(){
                        dorm_lunch = try element.text()
                    }
                    
                    let dormDinner : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(3) > td:nth-child(5) > a")
                    
                    for element in dormDinner.array(){
                        dorm_dinner = try element.text()
                    }
                    
                    let chambitBreakFirst : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(1) > td:nth-child(5) > a")
                    
                    for element in chambitBreakFirst.array(){
                        chambit_breakfirst = try element.text()
                    }
                    
                    let chambitLunch : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(2) > td:nth-child(5) > a")
                    
                    for element in chambitLunch.array(){
                        chambit_lunch = try element.text()
                    }
                    
                    let chambitDinner : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(3) > td:nth-child(5) > a")
                    
                    for element in chambitDinner.array(){
                        chambit_dinner = try element.text()
                    }
                    
                    break
                    
                case "Thu" :
                    let monDay : Elements = try doc.select("#sub_right > div:nth-child(3) > div > table > tbody > tr:nth-child(2) > td:nth-child(6) > p")
                    
                    for element in monDay.array(){
                        jinsoo_lunch = try element.text()
                    }
                    
                    let monDinner : Elements = try doc.select("#sub_right > div:nth-child(3) > div > table > tbody > tr:nth-child(4) > td:nth-child(6) > p")
                    
                    for element in monDinner.array(){
                        jinsoo_dinner = try element.text()
                    }
                    
                    let jeongDam : Elements = try doc.select("#sub_right > div:nth-child(9) > div > table > tbody > tr:nth-child(2) > td:nth-child(6)")
                    
                    for element in jeongDam.array(){
                        jeongdam_lunch = try element.text()
                    }
                    
                    let dormbreakFirst : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(1) > td:nth-child(6) > a")
                    
                    for element in dormbreakFirst.array(){
                        dorm_breakfirst = try element.text()
                    }
                    
                    let dormLunch : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(2) > td:nth-child(6) > a")
                    
                    for element in dormLunch.array(){
                        dorm_lunch = try element.text()
                    }
                    
                    let dormDinner : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(3) > td:nth-child(6) > a")
                    
                    for element in dormDinner.array(){
                        dorm_dinner = try element.text()
                    }
                    
                    let chambitBreakFirst : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(1) > td:nth-child(6) > a")
                    
                    for element in chambitBreakFirst.array(){
                        chambit_breakfirst = try element.text()
                    }
                    
                    let chambitLunch : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(2) > td:nth-child(6) > a")
                    
                    for element in chambitLunch.array(){
                        chambit_lunch = try element.text()
                    }
                    
                    let chambitDinner : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(3) > td:nth-child(6) > a")
                    
                    for element in chambitDinner.array(){
                        chambit_dinner = try element.text()
                    }
                    
                    break
                    
                case "Fri" :
                    let monDay : Elements = try doc.select("#sub_right > div:nth-child(3) > div > table > tbody > tr:nth-child(2) > td:nth-child(7) > p")
                    
                    for element in monDay.array(){
                        jinsoo_lunch = try element.text()
                    }
                    
                    let monDinner : Elements = try doc.select("#sub_right > div:nth-child(3) > div > table > tbody > tr:nth-child(4) > td:nth-child(7) > p")
                    
                    for element in monDinner.array(){
                        jinsoo_dinner = try element.text()
                    }
                    
                    let jeongDam : Elements = try doc.select("#sub_right > div:nth-child(9) > div > table > tbody > tr:nth-child(2) > td:nth-child(7)")
                    
                    for element in jeongDam.array(){
                        jeongdam_lunch = try element.text()
                    }
                    
                    let dormbreakFirst : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(1) > td:nth-child(7) > a")
                    
                    for element in dormbreakFirst.array(){
                        dorm_breakfirst = try element.text()
                    }
                    
                    let dormLunch : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(2) > td:nth-child(7) > a")
                    
                    for element in dormLunch.array(){
                        dorm_lunch = try element.text()
                    }
                    
                    let dormDinner : Elements = try doc_dorm.select("#calendar > table > tbody > tr:nth-child(3) > td:nth-child(7) > a")
                    
                    for element in dormDinner.array(){
                        dorm_dinner = try element.text()
                    }
                    
                    let chambitBreakFirst : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(1) > td:nth-child(7) > a")
                    
                    for element in chambitBreakFirst.array(){
                        chambit_breakfirst = try element.text()
                    }
                    
                    let chambitLunch : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(2) > td:nth-child(7) > a")
                    
                    for element in chambitLunch.array(){
                        chambit_lunch = try element.text()
                    }
                    
                    let chambitDinner : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(3) > td:nth-child(7) > a")
                    
                    for element in chambitDinner.array(){
                        chambit_dinner = try element.text()
                    }
                    
                    break
                    
                case "Sat" :
                    jinsoo_lunch = "운영 없음"
                    
                    jinsoo_dinner = "운영 없음"
                    
                    jeongdam_lunch = "운영 없음"
                    
                    dorm_breakfirst = "운영 없음"
                    
                    dorm_lunch = "운영 없음"
                    
                    dorm_dinner = "운영 없음"
                    
                    let chambitBreakFirst : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(1) > td:nth-child(8) > a")
                    
                    for element in chambitBreakFirst.array(){
                        chambit_breakfirst = try element.text()
                    }
                    
                    let chambitLunch : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(2) > td:nth-child(8) > a")
                    
                    for element in chambitLunch.array(){
                        chambit_lunch = try element.text()
                    }
                    
                    let chambitDinner : Elements = try doc_chambit.select("#calendar > table > tbody > tr:nth-child(3) > td:nth-child(8) > a")
                    
                    for element in chambitDinner.array(){
                        chambit_dinner = try element.text()
                    }
                    
                    break
                    
                default:
                    break
                }
                
                
            }   catch let error{
                print("Error while parsing html : ", error)
            }
        }
        
        
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollView{
                    HStack{
                        Group{
                            Button(action : {
                                isSelected = "Mon"
                                getCoopMenu()
                            }){
                                Text("월".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                            }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.red))
                            
                            Button(action : {
                                isSelected = "Tue"
                                getCoopMenu()

                            }){
                                Text("화".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                            }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.pink))
                            
                            Button(action : {
                                isSelected = "Wed"
                                getCoopMenu()

                            }){
                                Text("수".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                            }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.orange))
                            
                            Button(action : {
                                isSelected = "Thu"
                                getCoopMenu()

                            }){
                                Text("목".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                            }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.yellow))
                            
                            Button(action : {
                                isSelected = "Fri"
                                getCoopMenu()

                            }){
                                Text("금".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                            }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.green))
                            
                            Button(action : {
                                isSelected = "Sat"
                                getCoopMenu()

                            }){
                                Text("토".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                            }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.blue))
                            
                            Button(action : {
                                isSelected = "Sun"
                                getCoopMenu()

                            }){
                                Text("일".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                            }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.purple))
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    VStack{
                        Spacer()
                        
                        Text("진수원")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image("ic_sun").resizable().frame(width: 30, height: 30)
                            Text(jinsoo_lunch)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image("ic_moon").resizable().frame(width: 30, height: 30)
                            Text(jinsoo_dinner)
                        }
                        
                        Spacer()
                        
                    }.frame(width: 300, height: 300).background(RoundedRectangle(cornerRadius: 15.0).stroke().fill(Color.gray))
                    
                    Spacer()
                    
                    VStack{
                        Spacer()
                        
                        Text("정담원")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image("ic_sun").resizable().frame(width: 30, height: 30)
                            Text(jeongdam_lunch)
                        }
                        
                        Spacer()
                        
                    }.frame(width: 300, height: 300).background(RoundedRectangle(cornerRadius: 15.0).stroke().fill(Color.gray))
                    
                    Spacer()
                    
                    VStack{
                        Spacer()
                        
                        Text("기존관")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack {
                            Image("ic_morning").resizable().frame(width: 30, height: 30)
                            Text(dorm_breakfirst)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image("ic_sun").resizable().frame(width: 30, height: 30)
                            Text(dorm_lunch)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image("ic_moon").resizable().frame(width: 30, height: 30)
                            Text(dorm_dinner)
                        }
                        
                        Spacer()
                    }.frame(width: 300, height: 300).background(RoundedRectangle(cornerRadius: 15.0).stroke().fill(Color.gray))
                    
                    Spacer()
                    
                    VStack{
                        Spacer()
                        
                        Text("참빛관")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack {
                            Image("ic_morning").resizable().frame(width: 30, height: 30)
                            Text(chambit_breakfirst)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image("ic_sun").resizable().frame(width: 30, height: 30)
                            Text(chambit_lunch)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image("ic_moon").resizable().frame(width: 30, height: 30)
                            Text(chambit_dinner)
                        }
                        
                        Spacer()
                    }.frame(width: 300, height: 300).background(RoundedRectangle(cornerRadius: 15.0).stroke().fill(Color.gray))
                    
                    Spacer()
                    
                }
            }
        }.onAppear(perform: {
            getCoopMenu()
        })
        .navigationBarTitle("학식 메뉴 확인하기")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(trailing:
                                NavigationLink(destination : CampusMapView()){
                                    Text("캠퍼스맵")
                                }
        )
    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView()
//    }
//}
