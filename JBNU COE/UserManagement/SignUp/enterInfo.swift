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
        ScrollView{
            VStack {
                Group{
                    Spacer()
                    
                    Text("인적사항을 입력해주세요.")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    TextField("E-Mail", text: $mail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .padding(30)
                                        
                    SecureField("비밀번호 (6자 이상)", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.asciiCapable)
                        .padding(30)
                    
                    SecureField("비밀번호 확인", text: $checkPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.asciiCapable)
                        .padding(30)                   
                    
                }
                
                Group{
                    TextField("성명", text : $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(30)
                    
                    TextField("연락처", text : $phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(30)
                        .keyboardType(.numberPad)
                    
                    Spacer()
                }
                
                HStack {
                    Button(action: {
                        self.showView = false
                    }){VStack{
                        Image(systemName : "arrow.left.circle")
                            .resizable()
                            .frame(width : 50, height : 50)
                            .foregroundColor(.gray)
                        
                        Text("이전")
                            .foregroundColor(.gray)
                    }}
                    
                    Spacer().frame(width : 50)
                    
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
                    }){VStack{
                        Image(systemName : "arrow.right.circle")
                            .resizable()
                            .frame(width : 50, height : 50)
                            .foregroundColor(.gray)
                        
                        Text("다음")
                            .foregroundColor(.gray)
                    }}
                }
                
                Spacer()
            }
        }.alert(isPresented: $showAlert, content: {
            switch alert{
            case .blankField:
                return Alert(title: Text("공백 필드"),
                             message: Text("모든 필드를 채워주세요."),
                             dismissButton: .default(Text("확인")){showAlert = false})
                
                
            case .invalidPassword:
                return Alert(title: Text("비밀번호 불일치"),
                             message: Text("비밀번호가 일치하지 않습니다."),
                             dismissButton: .default(Text("확인")){showAlert = false})
                
                
            case .passwordLimit:
                return Alert(title: Text("비밀번호 제한"),
                             message: Text("보안을 위해 6자리 이상의 비밀번호를 입력해주세요."),
                             dismissButton: .default(Text("확인")){showAlert = false})
                
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
