//
//  getNotices.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/07/07.
//

import Foundation
import Firebase
import WidgetKit

class getNotices: ObservableObject{
    @Published var notices: [Notice] = []
    
    func getNotices(completion: @escaping(_ result : Bool?) -> Void){
        db.collection("Notice").getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print(err)
                completion(false)
            }
            
            else{
                for document in QuerySnapshot!.documents{
                    let docRef = db.collection("Notice").document(document.documentID)
                    
                    docRef.getDocument(){(document, err) in
                        if let document = document{
                            
                            if !self.notices.contains(where: {($0.title == document.documentID)}){
                                self.notices.append(
                                    Notice(title: document.documentID, date: document.get("timeStamp") as? String ?? "", contents: document.get("contents") as? String ?? "", read: document.get("read") as? Int ?? 0)
                                )
                                
                            }
                                                        
                            self.notices.sort{
                                $0.date > $1.date
                            }
                        }
                    }
                }
                
                completion(true)
            }
            

        }
        
    }
}
