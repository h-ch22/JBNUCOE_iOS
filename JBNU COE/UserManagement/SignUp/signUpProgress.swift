//
//  signUpProgress.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/15.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct signUpProgress: View {
    @Binding var processSignUp : Bool
    @Binding var name : String
    @Binding var phone : String
    @Binding var studentNo : String
    @Binding var dept : String
    @Binding var password : String
    @Binding var mail : String
    @State var showSheet = false
    @State var loadMain = false
    
    func signUp(){
        db = Firestore.firestore()
        db.collection("User").document(mail).setData([
            "dept" : dept,
            "name" : name,
            "studentNo" : studentNo,
            "phone" : phone
        ]){err in
            if let err = err{
                showSheet = true
            }
            
            else{
                Auth.auth().createUser(withEmail: mail, password: password){(authResult, err) in
                    
                    if let err = err{
                        showSheet = true
                    }
                    
                    else{
                        loadMain = true
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
            Spacer().frame(height : 20)
            Text("학우님의 계정을 활성화하는 중입니다.")
                .multilineTextAlignment(.center)
        }.onAppear(perform: {
            signUp()
        })
        .actionSheet(isPresented: $showSheet, content: {
            ActionSheet(title: Text("가입 실패"), message: Text("네트워크에 연결되어 있지 않거나, 이미 가입한 계정입니다."), buttons:[
                .default(Text("다시 시도"), action:{signUp()}),
                .default(Text("가입 취소").foregroundColor(.red), action:{SignIn().navigationBarHidden(true)})
            ])
        })
        .fullScreenCover(isPresented: $loadMain, content: {
                            finish(show: $loadMain)})
    }
}

struct signUpProgress_Previews: PreviewProvider {
    static var previews: some View {
        signUpProgress(processSignUp: .constant(true), name: .constant(""), phone: .constant(""), studentNo: .constant(""), dept: .constant(""), password: .constant(""), mail: .constant(""))
    }
}
