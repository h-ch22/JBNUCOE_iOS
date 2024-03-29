//
//  ProductLog.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/05.
//

import SwiftUI
import FirebaseFirestore

class getLogData : ObservableObject{
    @Published var product: [Product] = []

    func getLog(studentNo : String){
        db = Firestore.firestore()
        let batteryRef = db.collection("Products").document("battery").collection("Log")
        let calculatorRef = db.collection("Products").document("calculator").collection("Log")
        let labcoatRef = db.collection("Products").document("labcoat").collection("Log")
        let umbrellaRef = db.collection("Products").document("umbrella").collection("Log")
        let slipperRef = db.collection("Products").document("slipper").collection("Log")
        let uniformRef = db.collection("Products").document("uniform").collection("Log")
        let helmetRef = db.collection("Products").document("helmet").collection("Log")
        
        batteryRef.getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print(err)
            }
            
            else{
                for document in QuerySnapshot!.documents{
                    self.getLogData(documentID: document.documentID, category: "battery", studentNo: studentNo)
                }
                
                calculatorRef.getDocuments(){(QuerySnapshot, err) in
                    if let err = err{
                        print(err)
                    }
                    
                    else{
                        for document in QuerySnapshot!.documents{
                            self.getLogData(documentID: document.documentID, category: "calculator", studentNo: studentNo)
                        }
                        
                        labcoatRef.getDocuments(){(QuerySnapshot, err) in
                            if let err = err{
                                print(err)
                            }
                            
                            else{
                                for document in QuerySnapshot!.documents{
                                    self.getLogData(documentID: document.documentID, category: "labcoat", studentNo: studentNo)
                                }
                                
                                umbrellaRef.getDocuments(){(QuerySnapshot, err) in
                                    if let err = err{
                                        print(err)
                                    }
                                    
                                    else{
                                        for document in QuerySnapshot!.documents{
                                            self.getLogData(documentID: document.documentID, category: "umbrella", studentNo: studentNo)
                                        }
                                        
                                        slipperRef.getDocuments(){(QuerySnapshot, err) in
                                            if let err = err{
                                                print(err)
                                            }
                                            
                                            else{
                                                for document in QuerySnapshot!.documents{
                                                    self.getLogData(documentID: document.documentID, category: "slipper", studentNo: studentNo)
                                                }
                                                
                                                uniformRef.getDocuments(){(QuerySnapshot, err) in
                                                    if let err = err{
                                                        print(err)
                                                    }
                                                    
                                                    else{
                                                        for document in QuerySnapshot!.documents{
                                                            self.getLogData(documentID: document.documentID, category: "uniform", studentNo: studentNo)
                                                        }
                                                    }
                                                }
                                                
                                                helmetRef.getDocuments(){(QuerySnapshot, err) in
                                                    if let err = err{
                                                        print(err)
                                                    }
                                                    
                                                    else{
                                                        for document in QuerySnapshot!.documents{
                                                            self.getLogData(documentID: document.documentID, category: "helmet", studentNo: studentNo)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getLogData(documentID : String, category : String, studentNo : String){
        let docRef = db.collection("Products").document(category).collection("Log").document(documentID)
        var categoryKR = ""
        
        if category == "battery"{
            categoryKR = "보조 배터리".localized()
        }
        
        if category == "calculator"{
            categoryKR = "공학용 계산기".localized()
        }
        
        if category == "labcoat"{
            categoryKR = "실험복".localized()
        }
        
        if category == "umbrella"{
            categoryKR = "우산".localized()
        }
        
        if category == "uniform"{
            categoryKR = "유니폼".localized()
        }
        
        if category == "slipper"{
            categoryKR = "슬리퍼".localized()
        }
        
        if category == "helmet"{
            categoryKR = "헬멧".localized()
        }
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                let data_studentNo = document.get("studentNo") as? String ?? ""
                print("data : ", data_studentNo)
                if data_studentNo == studentNo{
                    self.product.append(
                        Product(product: categoryKR,
                                number: document.get("number") as? String ?? "",
                                date: documentID, returned: document.get("returned") as! Bool)
                    )
                }
                
                self.product.sort{
                    $0.date > $1.date
                }
            }
        }
    }
}

struct ProductLog: View {
    @ObservedObject var getData: getLogData
    @EnvironmentObject var userManagement : UserManagement

    var body: some View {
        List(getData.product.indices, id: \.self){ index in
            ProductRow(product: self.$getData.product[index])

        }.navigationBarTitle("대여 기록 확인하기".localized(), displayMode: .large)
        .navigationBarItems(trailing:
            Button(action: {
                getData.product.removeAll()
                getData.getLog(studentNo: userManagement.studentNo)
                print(userManagement.studentNo)
            }){
                Image(systemName: "arrow.clockwise")
                                        
            }
        )
        .onAppear(perform: {
            if getData.product.isEmpty{
                getData.getLog(studentNo: userManagement.studentNo)
                print(userManagement.studentNo)
            }
        })
    }
}
