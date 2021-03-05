//
//  JBNU_COEApp.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/10.
//

import SwiftUI
import Firebase

@main
struct JBNU_COEApp: App {
    @State var show = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        
        WindowGroup {
            ContentView(show : $show).environmentObject(setStoreInfo()).environmentObject(UserManagement())
        }
    }
}
