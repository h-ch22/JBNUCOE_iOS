//
//  BottomTabManager.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/11.
//

import SwiftUI

struct BottomTabManager: View {
    var body: some View {
        TabView() {
            Home_Phone().tabItem {
                Image(systemName: "location.fill.viewfinder")
                Text("제휴 업체") }.tag(1)
            
            SportsMain().tabItem {
                Image(systemName: "sportscourt.fill")
                Text("공스") }.tag(2)
            
            noticeListView(getNotices: getNotices()).tabItem {
                Image(systemName: "bell.fill")
                Text("공지사항") }.tag(3)
            
            more().environmentObject(UserManagement()).tabItem {
                Image(systemName: "ellipsis.circle.fill")
                Text("더 보기") }.tag(4)
        }
    }
}

struct BottomTabManager_Previews: PreviewProvider {
    static var previews: some View {
        BottomTabManager()
    }
}
