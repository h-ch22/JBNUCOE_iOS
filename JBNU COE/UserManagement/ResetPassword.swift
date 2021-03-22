//
//  ResetPassword.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/11.
//

import SwiftUI
import FirebaseAuth

enum resetAlert{
    case success, fail
}

struct ResetPassword: View {
    @State var mail : String = ""
    @State var showAlert = false
    @State var alert : resetAlert = .fail
    @State var result = ""{
        didSet(newVal){
            if newVal == "success"{
                alert = .success
                showAlert = true
            }
            
            if newVal == "fail"{
                alert = .fail
                showAlert = true
            }
        }
    }
    
    func resetPassword(){
        Auth.auth().sendPasswordReset(withEmail: mail){err in
            if let err = err{
                result = "fail"
            }
            
            else{
                result = "success"
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("도움이 필요하신가요?".localized())
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("아래 필드에 학우님의 E-Mail 주소를 입력해주시면,\n비밀번호 재설정 링크를 발송해드리겠습니다.".localized())
                .multilineTextAlignment(.center)
            
            Spacer()
            
            TextField("E-Mail", text: $mail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(20)
            
            Spacer()
            
            Button(action: {
                resetPassword()
            }){
                HStack{
                    Text("비밀번호 재설정 링크 보내기".localized())
                        .foregroundColor(.white)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }.padding(20)
                .background(RoundedRectangle(cornerRadius: 20))
            }
            
            Spacer()
        }.alert(isPresented: $showAlert, content: {
            switch alert{
            case .success:
                return Alert(title: Text("전송 성공".localized()), message: Text("입력하신 E-Mail로 비밀번호 재설정 링크를 발송하였습니다.".localized()), dismissButton: .default(Text("확인".localized())){showAlert = false})
                
            case .fail:
                return Alert(title: Text("전송 실패".localized()), message: Text("비밀번호 재설정 링크를 발송하지 못했습니다.\n네트워크가 정상적으로 연결되었는지, 입력하신 E-Mail이 가입 시 입력한 E-Mail 주소와 일치하는지 확인하신 후 다시 시도하십시오.".localized()), dismissButton: .default(Text("확인".localized())){showAlert = false})
            }
        })
    }
}

struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword()
    }
}
