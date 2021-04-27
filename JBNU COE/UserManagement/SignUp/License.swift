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
            Text("이용 약관을 읽어주세요.".localized())
                .font(.title)
                .fontWeight(.semibold)
            
            ScrollView{
                VStack{
                    Text(license.license)
                }
            }.padding()
            
            Spacer()
            
            Button(action: {showAlert = true}){
                HStack{
                    Text("동의".localized()).foregroundColor(.white)
                    Image(systemName: "chevron.right").foregroundColor(.white)
                }
            }.frame(width: 250, height: 60, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 50).foregroundColor(.blue))
            
            Spacer()
            
            NavigationLink(destination: SignIn().navigationBarHidden(true)){
                Text("동의 안 함".localized()).foregroundColor(.gray)
            }
        }.alert(isPresented: $showAlert, content: {
            Alert(title: Text("이용 약관 동의".localized()), message: Text("소프트웨어 이용약관에 동의합니다.".localized()), primaryButton: .destructive(Text("예".localized())){loadView = true}, secondaryButton: .default(Text("아니오".localized())))
        })
        .fullScreenCover(isPresented: $loadView, content: {
            enterInfo(showView: $loadView)
        })
    }
}

struct License_Previews: PreviewProvider {
    static var previews: some View {
        License(license: loadLicense())
    }
}
