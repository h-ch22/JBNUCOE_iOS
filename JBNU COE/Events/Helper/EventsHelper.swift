//
//  EventsHelper.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/05/17.
//

import Foundation
import FirebaseFirestore
import Firebase

class EventsHelper{
    public func getEventsList(){
        let docRef = db.collection("Events")
        
        docRef.getDocuments(){(QuerySnpshot, err) in
            if let err = err{
                print(err)
            }
            
            else{
                for document in QuerySnpshot!.documents{
                    self.getEventInfo(id: document.documentID)
                }
            }
        }
    }
    
    public func getEventInfo(id : String){
        let docRef = db.collection("Events").document(id)
        
        
    }
}
