//
//  Widget_Notice.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/07/07.
//

import WidgetKit
import SwiftUI
import Firebase

struct NoticeEntryView : View{
    let entry : NoticeListEntry
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
            if entry.noticeList.count <= 0{
                NoticeWidgetView(model : Notice(title: "", date: "", contents: "", read: 0), index : 0)
            }
            
            else{
                ForEach(0..<min(maxCount, entry.noticeList.count), id : \.self){index in
                    NoticeWidgetView(model: entry.noticeList[index], index : index)
                }
            }

        }.padding(.all, 16)
    }
}

struct NoticeWidgetView : View{
    let model : Notice
    let index : Int
    let colors : [Color] = [.red, .orange, .blue, .green, .purple, .pink, .yellow]
    @Environment(\.widgetFamily) var family
    
    var body : some View{
        VStack(alignment : .leading){
            if model == nil || model.title == "" || model.title == nil{
                Text("공지사항 없음")
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
                    
                    Text(model.date)
                        .font(.system(size : 10))
                        .foregroundColor(.gray)
                }
                
                else if family == .systemMedium{

                    HStack {
                        Circle().frame(width : 5, height : 5).foregroundColor(colors[index])

                        Text(model.title)
                            .font(.system(size: 15, weight : .semibold))
                    }
                    
                    Text(model.date)
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
                    
                    Text(model.date)
                        .font(.system(size : 10))
                        .foregroundColor(.gray)
                    
                    Divider()
                }
            }
            
        }
    }
    
}

struct Widget_Notice: Widget {
    let kind_notice: String = "Widget_Notice"
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind_notice,
                            provider: NoticeListProvider(helper : getNotices())){entry in
            NoticeEntryView(entry: entry)
            
        }
        .configurationDisplayName("공지사항")
        .description("공과대학 학생회 공지사항을 위젯에서 확인할 수 있습니다.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct Widget_Notice_Previews: PreviewProvider {
    static var previews: some View {
        NoticeEntryView(entry: NoticeListEntry(noticeList: [Notice(title: "title", date: "date", contents: "contents", read: 0)]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
