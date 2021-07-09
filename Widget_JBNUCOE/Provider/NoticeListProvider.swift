//
//  NoticeListProvider.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/07/07.
//

import Foundation
import WidgetKit
import SwiftUI
import FirebaseFirestore

struct NoticeListProvider : TimelineProvider{
    typealias Entry = NoticeListEntry
    let formatter = DateFormatter()
    let entry = NoticeListEntry(date: Date(), noticeList: [Notice(title: "title", date: "date", contents: "contents", read: 0)])
    @ObservedObject var helper : getNotices
    
    func placeholder(in context: Context) -> NoticeListEntry {
        entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (NoticeListEntry) -> Void) {
        let notice_1 = Notice(title: "공과대학 학생회 1학기 간식사업 안내", date: "2021. 04. 01.", contents: "", read: 0)
        let notice_2 = Notice(title: "공과대학 학생회 1/4분기 공약 이행률 안내", date: "2021. 04. 02.", contents: "", read: 0)
        let notice_3 = Notice(title: "공과대학 학생회 민원사업 안내", date: "2021. 04. 03.", contents: "", read: 0)
        let notice_4 = Notice(title: "공과대학 학생회 스터디 사업 안내", date: "2021. 04. 07.", contents: "", read: 0)
        let notice_5 = Notice(title: "공과대학 공식 애플리케이션 출시 안내", date: "2021. 04. 10.", contents: "", read: 0)
        
        let entry = NoticeListEntry(noticeList: [notice_1, notice_2, notice_3, notice_4, notice_5])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<NoticeListEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
                
        helper.getNotices(){result in
            if let result = result{
                print("notice : ", helper.notices)
            }
            
            else{
                
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
            let entry = NoticeListEntry(date: currentDate, noticeList: helper.notices)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            
            completion(timeline)
        }

    }
}
