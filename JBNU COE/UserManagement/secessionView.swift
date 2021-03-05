//
//  secession.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

enum secessionAlert{
    case success, fail
}

struct secessionView: View {
    @Binding var secession : Bool
    @State var showAlert = false
    @State var secessionAlert : secessionAlert = .fail
    @State var present = false
    @State var result = ""{
        willSet(newVal){
            if newVal == "success"{
                secessionAlert = .success
                showAlert = true
                print("variable changed.")
            }
            
            if newVal == "fail"{
                secessionAlert = .fail
                showAlert = true
            }
        }
    }
    
    func doSecession(){
        let user = Auth.auth().currentUser

        print("doing secession...")
        let storageRef = Storage.storage().reference(withPath:"profile/" + (Auth.auth().currentUser?.email)! + "/profile_" + (Auth.auth().currentUser?.email)! + ".jpg")
        storageRef.delete{err in
            if let err = err{
                print(err)
            }
            
            else{
                
            }
        }
        
        user?.delete{err in
            if let err = err{
                result = "fail"
                print(err)
            }
            
            else{
                result = "success"
                print("success")
            }
        }
    }
    
    var body: some View {
        VStack {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        }.onAppear(perform: {
            doSecession()
        })
        .alert(isPresented: $showAlert){
            switch secessionAlert{
            case .success:
                return Alert(title: Text("감사 인사"), message: Text("회원 탈퇴가 정상적으로 처리되었습니다.\n더 좋은 서비스로 다시 만나뵐 수 있도록 노력하겠습니다.\n감사합니다."), dismissButton:.default(Text("확인")){
                    present = true
                })
                
            case .fail:
                return Alert(title: Text("회원 탈퇴 실패"), message: Text("회원 탈퇴 처리 중 오류가 발생하였습니다.\n네트워크 상태를 확인하고 다시 시도하거나, 공과대학 학생회에 문의하십시오."), dismissButton: .default(Text("확인")){
                    present = true
                })
            }
            
        }
        
        .fullScreenCover(isPresented: $present, content: {
            ContentView(show : $present)
        })
    }
}

struct secessionView_Previews: PreviewProvider {
    static var previews: some View {
        secessionView(secession: .constant(true), secessionAlert: .success)
    }
}
