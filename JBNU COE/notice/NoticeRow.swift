//
//  NoticeRow.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI

struct NoticeRow: View {
    @Binding var notice: Notice
    
    init(notice: Binding<Notice>){
        self._notice = notice
    }
    
    var body: some View {
        VStack(alignment : .leading){
            Text(notice.title)
                .fontWeight(.bold)
            
            HStack{
                Text(notice.date)
                Spacer()
                Text("조회 : " + String(notice.read))
            }
        }
    }
}

struct NoticeRow_Previews: PreviewProvider {
    @State static var notice = Notice(title: "", date: "", contents: "", read : 0)

    static var previews: some View {
        NoticeRow(notice: $notice)
    }
}
