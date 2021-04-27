//
//  showMyFeedback.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/04/10.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class getMyFeedbacks: ObservableObject{
    @Published var feedbacks: [myFeedback] = []
    
    func getStudentNo(){
        let docRef = db.collection("User").document(Auth.auth().currentUser?.email ?? "")
        
        docRef.getDocument(){(document, error) in
            if let document = document{
                self.getFeedback(studentNo: document.get("studentNo") as! String)
            }
        }
    }
    
    func getFeedback(studentNo : String){
        db.collection("Feedback").getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print(err)
            }
            
            else{
                for document in QuerySnapshot!.documents{
                    print("\(document.documentID) -> \(document.data())")
                    
                    self.getDocData(name: document.documentID, studentNo : studentNo)
                    
                }
            }
        }
    }
    
    func getDocData(name : String, studentNo : String){
        let docRef = db.collection("Feedback").document(name)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                var author = document.get("author") as? String ?? ""
                var answered = false

                print(author)
                print(studentNo)
                
                if author.contains(studentNo){
                    if document.get("answer") != nil{
                        answered = true
                    }
                    
                    else{
                        answered = false
                    }
                    
                    self.feedbacks.append(
                        myFeedback(title: name, date: document.get("Date Time") as? String ?? "", category: document.get("Category") as? String ?? "", type: document.get("Type") as? String ?? "", contents: document.get("Feedback") as? String ?? "", answered: answered)
                    )
                }
                
                self.feedbacks.sort{
                    $0.date > $1.date
                }
            }
        }
        
    }
}

struct showMyFeedback: View {
    @ObservedObject var getFeedbacks: getMyFeedbacks
    @State var i = 0
    
    var body: some View {
        List(getFeedbacks.feedbacks.indices, id: \.self){ index in
            NavigationLink(destination: myFeedbackDetails(feedback: self.$getFeedbacks.feedbacks[index])){
                myFeedbackRow(myfeedback: self.$getFeedbacks.feedbacks[index])
            }
        }.onAppear(perform: {
            getFeedbacks.getStudentNo()
        })
        
        .navigationBarItems(trailing:
            Button(action: {
                getFeedbacks.feedbacks.removeAll()
                getFeedbacks.getStudentNo()
            }){
                Image(systemName: "arrow.clockwise")
                                        
            }
        )
        
        .onDisappear(perform: {
            getFeedbacks.feedbacks.removeAll()
        })
        
        .navigationBarTitle("보낸 피드백 확인하기")
    }
}
