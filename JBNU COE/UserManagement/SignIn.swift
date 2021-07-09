//
//  SignIn.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/10.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Progress: View{
    var body: some View{
            VStack {
                ProgressView().progressViewStyle(CircularProgressViewStyle()).frame(width: 120, height: 120, alignment: .center)
                Text("처리 중...".localized()).foregroundColor(.black)
            }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.white).opacity(0.6))
    

    }
}

struct SignIn: View {
    @State private var mail : String = ""
    @State private var password : String = ""
    @State private var showAlert = false
    @State var autoSignIn = false
    @EnvironmentObject var userManagement : UserManagement
    @ObservedObject var license = loadLicense()
    @State var isHidden = true
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack {
                    Group{
                        Spacer()
                        
                        Image("ic_coe")
                            .resizable()
                            .frame(width: 120,
                                   height: 120, alignment: .center)
                        
                        Spacer()
                        
                        Text("안녕하세요, 학우님".localized())
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("시작하기 전에, 로그인이 필요합니다.".localized())
                        
                        Spacer()
                        
                        TextField("E-Mail", text: $mail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.horizontal], 20)
                        
                        Spacer()
                        
                        SecureField("비밀번호".localized(), text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.horizontal], 20)
                        
                        Spacer()
                    }
                    
                    Toggle(isOn: $autoSignIn) {
                        Text("자동 로그인".localized())
                    }.padding(20)
                    
                    Spacer().frame(height : 30)

                    Button(action: {
                        self.isHidden = false
                        userManagement.signIn(mail: mail, password: password)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                            if userManagement.isSignedIn && autoSignIn{
                                self.isHidden = true
                                userManagement.autoLogIn(mail: mail, password: password)

                            }
                            
                            if userManagement.isSignedIn && !autoSignIn{
                                self.isHidden = true
                                userManagement.autoLogOut()

                            }
                            
                            if !userManagement.isSignedIn{
                                self.isHidden = true
                                self.showAlert = true
                            }
                        }
                        
                    }
                    ){
                        HStack {
                            Text("로그인하기".localized())
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
                    
                    Spacer()
                    
                    HStack{
                        NavigationLink(destination: ResetPassword()) {
                            Text("로그인에 문제가 있나요?".localized())
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: License(license: license)) {
                            Text("회원가입".localized()).foregroundColor(.blue)
                        }
                    }.padding()
                    
                    Spacer().frame(height : 50)
                    
                    Text("(C) 2021 Jeonbuk National University\nPublic Relations Department of\nCollege of Engineering Student Council\nAll Rights Reserved.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)

                    
                    Spacer()
                }.alert(isPresented: $showAlert){
                    Alert(title : Text("로그인 실패".localized()),
                          message: Text("로그인을 처리하던 중 오류가 발생했습니다.\nE-Mail과 비밀번호를 확인한 후 다시 시도하거나, 네트워크 상태를 확인해주세요.".localized()),
                          dismissButton: .default(Text("확인")))
                }
                .navigationBarTitle("로그인".localized())
            }
            
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .overlay(Group{
            if !isHidden || UserDefaults.standard.object(forKey: "mail") != nil{
                Progress()
            }
            
            else{
                EmptyView()
            }
        })
            
        
        }
        
    }

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
