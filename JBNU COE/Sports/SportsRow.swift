//
//  SportsRow.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/22.
//

import SwiftUI

struct SportsRow: View {
    @Binding var sports: Sports
    
    init(sports: Binding<Sports>){
        self._sports = sports
    }
    
    func getStatus() -> Bool{
        var isAvailable = false
        
        if sports.allPeople > sports.currentPeople{
            var date_str = sports.date
            let currentDate_old = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy. MM. dd. kk:mm"
            dateFormatter.timeZone = TimeZone(identifier: "UTC+9")

            var date = dateFormatter.date(from: date_str)
            var currentDate_str = dateFormatter.string(from: currentDate_old)
            var currentDate = dateFormatter.date(from: currentDate_str)
            
            if currentDate! > date!{
                isAvailable = false
            }
            
            else{
                isAvailable = true
            }
        }
        
        else{
            isAvailable = false
        }
        
        return isAvailable
    }
    
    var body: some View {
        VStack(alignment : .leading){
            Text(sports.name)
                .fontWeight(.bold)
            
            HStack {
                Text(sports.date as! String)
                Spacer()
                Text("모집 인원 : ".localized() + String(sports.allPeople))
                Spacer()
                Text("현재 인원 : ".localized() + String(sports.currentPeople))
            }
            
            VStack {
                HStack {
                    Text(getStatus() ? "지원 가능".localized() : "지원 불가".localized())
                        .foregroundColor(.white)
                        .frame(width : 80, height : 30)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(getStatus() ? Color.blue : Color.red).opacity(0.7))
                    
                    Spacer()
                    
                    Text("장소 : ".localized() + sports.location)
                    
                    Spacer()
                    
                    Text("종목 : ".localized() + sports.event)
                }
            }
        }
    }
}
