//
//  AdDetailLoader.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/22.
//

import SwiftUI
import FirebaseFirestore

struct AdDetailLoader: View {
    @Binding var selected : Int
    @State var alliance: [Alliance] = []
    @State var engName : String = ""
    
    func getData(){
        db = Firestore.firestore()
        
        var storeList : [String] = []
        let adRef = db.collection("Ad").document(String(selected))
        var benefitDictionary: Any?

        adRef.getDocument(){(document, err) in
            if let document = document{
                let category = document.get("category") as! String
                let storeName = document.get("storeName") as! String
                
                let docRef = db.collection("Coalition").document(category)
                let engRef = db.collection("Store").document("eng")
                
                engRef.getDocument(){(document, err) in
                    if let document = document{
                        engName = document.get(storeName) as! String
                        
                        docRef.getDocument() { (document, error) in
                            if let document = document {
                                storeList.append(contentsOf: Array(document.data()!.keys))
                                print(Array(document.data()!.keys))
                                
                                let benefit_db = document.data()?[storeName] as? String ?? "준비 중입니다."
                                benefitDictionary = document.data()?[storeName] as! [String : Any]
                                
                                let s = String(describing: benefitDictionary)
                                let split_Str = s.components(separatedBy: "Optional([\"benefits\":")
                                let final_Str = split_Str[1].components(separatedBy: "])")
                                self.alliance.append(Alliance(storeName: storeName, benefits: final_Str[0], engName: engName, url: URL(string: "http://")!, category: category, isEnable: "", brake: "", closed: ""))
                                
                            } else {
                                print("Document does not exist in cache")
                                print(category)
                            }
                        }
                    }
                }
                
                
            }
        }
    }
    
    var body: some View {
        VStack {
            if !alliance.isEmpty{
                storeDetail(alliance: alliance[0])
            }
            
            else{
                ProgressView().progressViewStyle(CircularProgressViewStyle())
            }
        }.onAppear(perform: {
            getData()
        })
    }
}
