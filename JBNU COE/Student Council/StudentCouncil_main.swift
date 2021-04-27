//
//  StudentCouncil_main.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/20.
//

import SwiftUI
import FirebaseFirestore

struct StudentCouncil_main: View {
    @ObservedObject var text = loadText()
    @State private var latestVersion = "0.0.0"
    
    func getVersion(){
        db = Firestore.firestore()
        let docRef = db.collection("Version").document("iOS")
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                latestVersion = document.get("latest") as! String
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.background_home.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            ScrollView{
                VStack{
                    Spacer()
                    
                    HStack {
                        Image("ic")
                            .resizable().frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
                        
                        VStack(alignment : .leading){
                            Spacer()
                            
                            Text("전북대 공대".localized())
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("최신 버전 : ".localized() + String(latestVersion))
                            
                            Spacer()
                            
                            Text("현재 버전 : ".localized() + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!)
                            
                            if latestVersion == "0.0.0"{
                                Spacer()
                                
                                HStack{
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundColor(.orange)
                                    
                                    Text("버전 정보를 확인할 수 없습니다.".localized())
                                        .foregroundColor(.green)
                                }
                                
                                Spacer()
                            }
                            
                            else{
                                if latestVersion != Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
                                    VStack {
                                        Spacer()
                                        
                                        HStack{
                                            Image(systemName: "xmark")
                                                .foregroundColor(.red)
                                            
                                            Text("최신 버전이 아닙니다.".localized())
                                                .foregroundColor(.red)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action : {
                                            let appStore_Str = "https://apps.apple.com/kr/app/%EC%A0%84%EB%B6%81%EB%8C%80-%EA%B3%B5%EB%8C%80/id1549231899"
                                            
                                            let appStore = URL(string: appStore_Str)
                                            
                                            if UIApplication.shared.canOpenURL(appStore!){
                                                UIApplication.shared.openURL(appStore!)
                                            }
                                        }){
                                            HStack{
                                                Text("업데이트 하기".localized())
                                                    .foregroundColor(.white)
                                                
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(.white)
                                            }.padding([.vertical], 10).padding([.horizontal], 25).background(RoundedRectangle(cornerRadius: 10.0).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/))
                                        }
                                        
                                        Spacer()
                                        
                                    }
                                    
                                }
                                
                                else{
                                    
                                    Spacer()
                                    
                                    HStack{
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.green)
                                        
                                        Text("최신 버전입니다.".localized())
                                            .foregroundColor(.green)
                                    }
                                    
                                    Spacer()
                                    
                                }
                            }
                            

                        }
                    }.padding(20).background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(Color.background_button))
                    
                    Spacer()
                    
                    Group{
                        NavigationLink(destination: StudentCouncil_greet(text: text)){
                            HStack{
                                Image("ic_hello")
                                    .resizable()
                                    .frame(width : 30, height : 30)

                                Text("인사말".localized())
                                    .foregroundColor(Color.txtcolor)
                                
                                Spacer()

                            }
                        }.frame(width: 300, height: 50)
                        .padding()
                        .background(Color.background_button)
                        .cornerRadius(5)
                        
                        Spacer()
                        
                        NavigationLink(destination: StudentCouncil_introduce()){
                            HStack{
                                Image("ic_department")
                                    .resizable()
                                    .frame(width : 30, height : 30)

                                Text("국 소개".localized())
                                    .foregroundColor(Color.txtcolor)
                                
                                Spacer()
                            }
                        }.frame(width: 300, height: 50)
                        .padding()
                        .background(Color.background_button)
                        .cornerRadius(5)
                                        
                    Spacer()
                        
                        NavigationLink(destination : Privacy(license: loadLicense())){
                            HStack{
                                Image(systemName: "info.circle.fill")
                                    .resizable()
                                    .frame(width: 30,
                                           height : 30)
                                    .foregroundColor(.gray)
                                
                                
                                Text("개인정보 처리 방침 읽기".localized()).foregroundColor(Color.txtcolor)
                                
                                Spacer()
                            }
                        }.frame(width: 300, height: 50)
                        .padding()
                        .background(Color.background_button)
                        .cornerRadius(5)
                        
                    }
                       
                }

            }
        }
        
            
        .navigationBarTitle(Text("공대학생회 소개".localized()))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            getVersion()
        })
    }
}

struct StudentCouncil_main_Previews: PreviewProvider {
    static var previews: some View {
        StudentCouncil_main()
    }
}
