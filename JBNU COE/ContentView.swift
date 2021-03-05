//
//  ContentView.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/10.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State var isSignedIn : Bool = false
    @State var uid : String = ""
    @State var pwd : String = ""
    @State var studentNo : String = ""
    @EnvironmentObject var userManagement : UserManagement
    @Binding var show : Bool
    
    @ViewBuilder
    var body: some View {
            VStack{
                if userManagement.isSignedIn{
                    BottomTabManager()
                }
                
                else{
                    SignIn()
                }
            }
        
        .onAppear(perform: {
            if let userId = UserDefaults.standard.string(forKey: "mail"){
                self.uid = userId
                self.pwd = UserDefaults.standard.string(forKey: "password")!
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                
                userManagement.signIn(mail: self.uid, password: self.pwd)
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(show : .constant(true))
    }
}
