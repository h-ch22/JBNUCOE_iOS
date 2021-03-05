//
//  Licnense.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI
import Combine

class loadLicense: ObservableObject{
    @Published var license : String = ""
    
    init(){
        self.load()
    }
    
    func load(){
        if let filePath = Bundle.main.path(forResource: "License", ofType: "txt"){
            do{
                let contents = try String(contentsOfFile: filePath)
                DispatchQueue.main.async{
                    self.license = contents
                }
                
            }
            
            catch let error as Error{
                print(error.localizedDescription)
            }
        }
        
        else{
            print("file not found.")
        }
    }
}

struct License: View {
    @ObservedObject var license: loadLicense
    @State var showAlert = false
    @State var loadView = false

    var body: some View {
        VStack {
            Text("이용 약관을 읽어주세요.")
                .font(.title)
                .fontWeight(.semibold)
            
            ScrollView{
                VStack{
                    Text(license.license)
                }
            }
            
            Spacer()
            
            HStack{
                NavigationLink(destination : SignIn().navigationBarHidden(true)){
                    VStack{
                        Image(systemName : "arrow.left.circle")
                            .resizable()
                            .frame(width : 50, height : 50)
                            .foregroundColor(.gray)
                        
                        Text("동의 안 함")
                            .foregroundColor(.gray)

                    }
                }
                
                Spacer().frame(width : 50)

                Button(action: {
                    showAlert = true
                }){
                    VStack{
                        Image(systemName : "arrow.right.circle")
                            .resizable()
                            .frame(width : 50, height : 50)
                            .foregroundColor(.gray)
                        
                        
                        Text("동의")
                            .foregroundColor(.gray)
                    }
                }
            }
        }.alert(isPresented: $showAlert, content: {
            Alert(title: Text("이용 약관 동의"), message: Text("소프트웨어 이용약관에 동의합니다."), primaryButton: .destructive(Text("예")){loadView = true}, secondaryButton: .default(Text("아니오")))
        })
        .fullScreenCover(isPresented: $loadView, content: {
            enterInfo(showView: $loadView)
        })
    }
}

//struct License_Previews: PreviewProvider {
//    @ObservedObject var loadlicense = loadLicense()
//
//    static var previews: some View {
//        License(license: load)
//    }
//}
