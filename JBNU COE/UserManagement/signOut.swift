//
//  signOut.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI
import FirebaseAuth

enum alertSignOut{
    case fail, success
}

struct signOut: View {
    @Binding var signOut : Bool
    @State var showAlert = false
    @State var alert : alertSignOut = .fail
    @State var present = false
    
    @State var result = ""{
        willSet(newVal){
            if newVal == "success"{
                print("value changed to success")
                alert = .success
                showAlert = true
            }
            
            if newVal == "fail"{
                print("value changed to success")
                alert = .fail
                showAlert = true
            }
        }
    }
    
    func dosignOut(){
        do{
            UserManagement().autoLogOut()
            try Auth.auth().signOut()
            print("signout...")
            
            if Auth.auth().currentUser == nil{
                print(Auth.auth().currentUser)
                result = "success"
            }
            
            else{
                result = "fail"
            }
        }   catch let err as Error{
            result = "fail"
        }
    }
    
    var body: some View {
        VStack {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        }.onAppear(perform: {
            dosignOut()
        })
        
        .alert(isPresented: $showAlert){
            switch alert{
            case .success:
                return Alert(title: Text("로그아웃 완료".localized()), message: Text("정상 처리되었습니다.".localized()), dismissButton:.default(Text("확인".localized())){
                    present = true
                })
                
            case .fail:
                return Alert(title: Text("로그아웃 실패".localized()), message: Text("로그아웃 처리 중 문제가 발생하였습니다.\n네트워크 상태를 확인하고 다시 시도하십시오.".localized()), dismissButton: .default(Text("확인".localized())){
                    present = true
                })
            }
            
        }
        
        .fullScreenCover(isPresented: $present, content: {
            ContentView(show : $present)
        })
    }
}

struct signOut_Previews: PreviewProvider {
    static var previews: some View {
        signOut(signOut: .constant(true))
    }
}
