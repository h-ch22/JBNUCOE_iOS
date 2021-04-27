//
//  changePassword.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/04/19.
//

import SwiftUI
import FirebaseAuth

enum changePWAlert{
    case success, fail, limit, noMatch
}

struct changePassword: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var password : String = ""
    @State private var checkPW = ""
    @State var showAlert = false
    @State var changePWAlert : changePWAlert = .limit
    
    func changePassword(){
        if password.count < 6{
            changePWAlert = .limit
            showAlert = true
        }
        
        else{
            if password != checkPW{
                changePWAlert = .noMatch
                showAlert = true
            }
            
            else{
                Auth.auth().currentUser?.updatePassword(to: password){(error) in
                    if let error = error{
                        changePWAlert = .fail
                        showAlert = true
                    }
                    
                    else{
                        UserManagement().autoLogOut()
                        changePWAlert = .success
                        showAlert = true
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Text("아래 필드에 새로운 비밀번호를 입력해주세요.")
                
                Text("비밀번호 조건 : 6자 이상")
                    .foregroundColor(.red)
                
                SecureField("비밀번호", text:$password).padding(20)
                SecureField("비밀번호 확인", text:$checkPW).padding(20)

                Button(action: {
                    changePassword()
                }
                ){
                    HStack {
                        Text("비밀번호 변경".localized())
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .frame(width: 250, height: 30)
                    .padding()
                    .background(Color.blue)
                    .border(Color.blue, width:2)
                    .cornerRadius(25)
                }
            }.navigationBarTitle(Text("비밀번호 변경"))
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading: Button(action : {self.presentationMode.wrappedValue.dismiss()}){Text("닫기")})
            .alert(isPresented: $showAlert, content: {
                switch changePWAlert{
                case .success:
                    return Alert(title: Text("변경 완료".localized()), message: Text("비밀번호 변경이 완료되었습니다.\n자동 로그인이 해제되었으니, 다음 로그인부터 변경한 비밀번호로 재로그인해주시기 바랍니다.".localized()), dismissButton: .default(Text("확인".localized())){self.presentationMode.wrappedValue.dismiss()})
                    
                case .fail:
                    return Alert(title: Text("변경 실패".localized()), message: Text("비밀번호를 변경하지 못했습니다.\n네트워크가 정상적으로 연결되었는지 확인하신 후 다시 시도하십시오.".localized()), dismissButton: .default(Text("확인".localized())){showAlert = false})
                    
                case .limit:
                        return Alert(title: Text("비밀번호 제한".localized()), message: Text("보안을 위해 최소 6자 이상의 비밀번호를 설정하십시오.".localized()), dismissButton: .default(Text("확인".localized())){showAlert = false})
                    
                case .noMatch:
                        return Alert(title: Text("비밀번호 불일치".localized()), message: Text("입력하신 비밀번호와 비밀번호 확인이 일치하지 않습니다.".localized()), dismissButton: .default(Text("확인".localized())){showAlert = false})
                }
            })
        }
    }
}

struct changePassword_Previews: PreviewProvider {
    static var previews: some View {
        changePassword()
    }
}
