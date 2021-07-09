//
//  Widget_Calendar.swift
//  Widget_JBNUCOEExtension
//
//  Created by 하창진 on 2021/07/07.
//

import WidgetKit
import SwiftUI
import Firebase

struct CalendarEntryView : View{
    let entry : CalendarListEntry
    @Environment(\.widgetFamily) var family
    
    var maxCount : Int{
        switch family{
        case .systemSmall:
            return 1
            
        case .systemMedium:
            return 3
            
        case .systemLarge:
            return 7

        @unknown default:
            return 1
        }
    }
    
    @ViewBuilder
    var body : some View{
        VStack(alignment : .leading){
            ForEach(0..<min(maxCount, entry.model.count), id : \.self){index in
                CalendarWidgetView(model: entry.model[index], index : index)
            }
        }.padding(.all, 16)
    }
}

struct CalendarWidgetView : View{
    let model : CalendarModel
    let index : Int
    let colors : [Color] = [.red, .orange, .blue, .green, .purple, .pink, .yellow]
    @Environment(\.widgetFamily) var family
    
    var body : some View{
        VStack(alignment : .leading){
            
            if model == nil || model.title == "" || model.title == nil{
                Text("다음 취업 일정 없음")
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
            }
            
            else{
                if family == .systemSmall{
                    HStack {
                        Circle().frame(width : 5, height : 5).foregroundColor(colors[index])
                        Text(model.title)
                            .font(.system(size: 15, weight : .semibold))
                    }
                    
                    Text(model.start)
                        .font(.system(size : 10))
                        .foregroundColor(.gray)
                }
                
                else if family == .systemMedium{

                    HStack {
                        Circle().frame(width : 5, height : 5).foregroundColor(colors[index])

                        Text(model.title)
                            .font(.system(size: 15, weight : .semibold))
                    }
                    
                    Text(model.start)
                        .font(.system(size : 10))
                        .foregroundColor(.gray)
                    
                    Divider()
                }
                
                
                else{
                    HStack {
                        Circle().frame(width : 5, height : 5).foregroundColor(colors[index])

                        Text(model.title)
                            .font(.system(size: 15, weight : .semibold))
                    }
                    
                    Text(model.start)
                        .font(.system(size : 10))
                        .foregroundColor(.gray)
                    
                    Divider()
                }
            }
            
        }
    }
    
}

struct Widget_Calendar: Widget {
    let kind_calendar: String = "Widget_Calendar"
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind_calendar,
                            provider: CalendarProvider()){entry in
            CalendarEntryView(entry: entry)
            
        }
        .configurationDisplayName("취업 캘린더")
        .description("취업 캘린더를 위젯에서 확인할 수 있습니다.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct Widget_Calendar_Previews: PreviewProvider {
    static var previews: some View {
        CalendarEntryView(entry : CalendarListEntry(model: [CalendarModel(title: "title", start: "start")]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
