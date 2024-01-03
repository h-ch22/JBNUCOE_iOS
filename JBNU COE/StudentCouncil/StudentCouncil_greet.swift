//
//  StudentCouncil_greet.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/20.
//

import SwiftUI

class loadText: ObservableObject{
    @Published var text : String = ""
    
    init(){
        self.load()
    }
    
    func load(){
        if let filePath = Bundle.main.path(forResource: "greeting", ofType: "txt"){
            do{
                let contents = try String(contentsOfFile: filePath)
                DispatchQueue.main.async{
                    self.text = contents
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

struct StudentCouncil_greet: View {
    @ObservedObject var text: loadText

    var body: some View {
        VStack {
            Image("greeting_img").resizable().frame(width: 400, height: 300)
            ScrollView{
                    VStack{
                        Text(text.text)
                            .padding(20)

                    }
            }
        }.navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(Text("인사말".localized()))
        
    }
}
