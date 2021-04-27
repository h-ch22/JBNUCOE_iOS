//
//  enterInfo.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI

enum signUpAlert{
    case invalidPassword, passwordLimit, blankField
}

struct enterInfo: View {
    @Binding var showView : Bool
    @State var mail : String = ""
    @State var password : String = ""
    @State var checkPassword : String = ""
    @State var name : String = ""
    @State var phone : String = ""
    @State var showAlert = false
    @State var showAcademic = false
    @State var alert : signUpAlert = .blankField
    @State var match = false
    
    func checkPasswordMatch(changed: Bool){
        self.match = self.checkPassword == self.password
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack {
                    Group{
                        Text("인적사항을 입력해주세요.".localized())
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        TextField("E-Mail", text: $mail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .padding(30)
                                            
                        SecureField("비밀번호 (6자 이상)".localized(), text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.asciiCapable)
                            .padding(30)
                        
                        SecureField("비밀번호 확인".localized(), text: $checkPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.asciiCapable)
                            .padding(30)
                        
                    }
                    
                    Group{
                        TextField("성명".localized(), text : $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(30)
                        
                        TextField("연락처".localized(), text : $phone)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(30)
                            .keyboardType(.numberPad)
                        
                        Spacer()
                    }
                    
                    Button(action: {
                        if password != checkPassword{
                            showAlert = true
                            alert = .invalidPassword
                        }
                        
                        if mail == "" || password == "" || checkPassword == "" || name == "" || phone == ""{
                            showAlert = true
                            alert = .blankField
                        }
                        
                        if password.count < 6{
                            showAlert = true
                            alert = .passwordLimit
                        }
                        
                        else{
                            UserManagement().temporarySaveInformation(mail: mail, password: password, phone: phone, name: name)
                            showAcademic = true

                        }
                    }){
                        HStack{
                            Text("다음".localized()).foregroundColor(.white)
                            Image(systemName: "chevron.right").foregroundColor(.white)
                        }
                    }.frame(width: 250, height: 60, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 50).foregroundColor(.blue))
                    
                    Spacer()
                }
            }
        }
        .alert(isPresented: $showAlert, content: {
            switch alert{
            case .blankField:
                return Alert(title: Text("공백 필드".localized()),
                             message: Text("모든 필드를 채워주세요.".localized()),
                             dismissButton: .default(Text("확인".localized())){showAlert = false})
                
                
            case .invalidPassword:
                return Alert(title: Text("비밀번호 불일치".localized()),
                             message: Text("비밀번호가 일치하지 않습니다.".localized()),
                             dismissButton: .default(Text("확인".localized())){showAlert = false})
                
                
            case .passwordLimit:
                return Alert(title: Text("비밀번호 제한".localized()),
                             message: Text("보안을 위해 6자리 이상의 비밀번호를 입력해주세요.".localized()),
                             dismissButton: .default(Text("확인".localized())){showAlert = false})
                
            }
        })
        .fullScreenCover(isPresented: $showAcademic, content: {
            checkAcademic(showAcademic: $showAcademic, name: $name, password : $password, phone : $phone, mail : $mail)
        })
        
    }
}

struct enterInfo_Previews: PreviewProvider {
    static var previews: some View {
        enterInfo(showView: .constant(true))
    }
}
