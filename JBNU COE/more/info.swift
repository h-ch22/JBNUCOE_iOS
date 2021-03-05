//
//  info.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/02/24.
//

import SwiftUI
import FirebaseFirestore

struct info: View {
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
        ScrollView{
            VStack{
                Spacer()
                
                HStack {
                    Image("ic")
                        .resizable().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
                    
                    VStack(alignment : .leading){
                        Spacer()
                        
                        Text("전북대학교 공과대학")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("최신 버전 : " + String(latestVersion))
                        
                        Spacer()
                        
                        Text("현재 버전 : " + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!)
                        
                        if latestVersion != Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
                            VStack {
                                Spacer()
                                
                                HStack{
                                    Image(systemName: "xmark")
                                        .foregroundColor(.red)
                                    
                                    Text("최신 버전이 아닙니다.")
                                        .foregroundColor(.red)
                                }
                                
                                Spacer()
                                
                                Button(action : {
                                    if let url = URL(string : "items-apps://itunes.apple.com/app/id1549231899"), UIApplication.shared.canOpenURL(url){
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                }){
                                    HStack{
                                        Text("업데이트 하기")
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
                                
                                Text("최신 버전입니다.")
                                    .foregroundColor(.green)
                            }
                            
                            Spacer()
                            
                        }
                    }
                }.padding(20).background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.gray).opacity(0.2))
                
                Spacer()
                
                VStack(alignment : .leading) {
                    Divider()
                    
                    NavigationLink(destination : Privacy(license: loadLicense())){
                        HStack{
                            HStack{
                                Image(systemName: "info.circle.fill")
                                    .resizable()
                                    .frame(width: 50,
                                           height : 50)
                                    .foregroundColor(.gray)
                                
                                
                                Text("개인정보 처리 방침 읽기")
                                    .foregroundColor(.gray)
                                    .font(.title)
                            }
                        }
                    }
                    
                }.padding(30)
                
            }
        }.navigationBarTitle("정보")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            getVersion()
        })
    }
}

struct info_Previews: PreviewProvider {
    static var previews: some View {
        info()
    }
}
