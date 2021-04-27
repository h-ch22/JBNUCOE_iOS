//
//  DeliveryLog.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/04/17.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class getDeliveryLog : ObservableObject{
    @Published var deliveryLog: [Delivery] = []
    @EnvironmentObject var userManagement : UserManagement
    
    func getLogList(){
        db = Firestore.firestore()
        
        let docRef = db.collection("Delivery")
        
        docRef.getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print(err)
            }
            
            else{
                for document in QuerySnapshot!.documents{
                    print("\(document.documentID) -> \(document.data())")
                    
                    if document.documentID.contains(Auth.auth().currentUser?.email as! String){
                        let docRef = docRef.document(document.documentID).getDocument(){(document, err) in
                            if let document = document{
                                self.deliveryLog.append(Delivery(waybill: document.get("Waybill") as! String, required: document.get("requested") as! String, isReceipt: document.get("isReceipt") as! Bool))
                            }
                            
                            else{
                                
                            }
                        }
                        
                        self.deliveryLog.sort{
                            $0.required > $1.required
                        }
                    }
                }
            }
        }
    }
}

struct DeliveryLog: View {
    @ObservedObject var getData: getDeliveryLog

    var body: some View {
        VStack{
            List(getData.deliveryLog.indices, id: \.self){ index in
                DeliveryRow(delivery: self.$getData.deliveryLog[index])
            }
        }.navigationBarTitle(Text("요청 기록"))
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarItems(trailing:
            Button(action: {
                getData.deliveryLog.removeAll()
                getData.getLogList()
            }){
                Image(systemName: "arrow.clockwise")
                                        
            }
        )
        .onAppear(perform: {
            if getData.deliveryLog.isEmpty{
                getData.getLogList()
            }
        })
    }
}
