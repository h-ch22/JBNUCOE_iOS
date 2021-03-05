//
//  Ad.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/11.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI
import FirebaseFirestore

struct Ad_1: View {
    
    @State private var imageURL = URL(string: "")
    

    
    var body: some View {
        VStack{
            ZStack{
                WebImage(url: imageURL)
                    .resizable()
                    .frame(width: 350, height : 250, alignment:.top)
                
            }
            
        }.onAppear(perform: {loadImageFromDatabase()})
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
    }
    
    func loadImageFromDatabase(){
        let storageRef = Storage.storage().reference(withPath: "ad/ad_1.png")
        
        storageRef.downloadURL{(url, error) in
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
            
            self.imageURL = url!
        }
    }
}

//struct Ad_1_Previews: PreviewProvider {
//    static var previews: some View {
//        Ad_1()
//    }
//}
