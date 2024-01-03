//
//  ContentView.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/10.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

//func serverTimeReturn(completionHandler:(_ getResDate: Date?) -> Void){
//
//let url = URL(string: "http://www.google.com")
//    let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
//        let httpResponse = response as? HTTPURLResponse
//        if let contentType = httpResponse!.allHeaderFields["Date"] as? String {
//
//            var dFormatter = DateFormatter()
//            dFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
//            var serverTime = dFormatter.date(from: contentType)
//            completionHandler(serverTime)
//        }
//    }
//
//    task.resume()
//}

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
