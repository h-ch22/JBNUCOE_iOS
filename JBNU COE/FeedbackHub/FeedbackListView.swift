//
//  FeedbackListView.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class getFeedbacks: ObservableObject{
    @Published var feedbacks: [Feedback] = []
    
    func getFeedback(){
        db.collection("Feedback").getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print(err)
            }
            
            else{
                for document in QuerySnapshot!.documents{
                    print("\(document.documentID) -> \(document.data())")
                    
                    self.getDocData(name: document.documentID)
                }
            }
        }
    }
    
    func getDocData(name : String){
        let docRef = db.collection("Feedback").document(name)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                var answered = false
                
                if document.get("answer") != nil{
                    answered = true
                }
                
                else{
                    answered = false
                }
                
                if !self.feedbacks.contains(where: {($0.title == name)}){
                    self.feedbacks.append(
                        Feedback(title: name, author: document.get("author") as? String ?? "", date: document.get("Date Time") as? String ?? "", category: document.get("Category") as? String ?? "", type: document.get("Type") as? String ?? "", contents: document.get("Feedback") as? String ?? "", answered : answered)
                    )
                }
                
                self.feedbacks.sort{
                    $0.date > $1.date
                }
            }
        }
        
    }
}

struct FeedbackListView: View {
    @ObservedObject var getFeedbacks: getFeedbacks
    @State var i = 0
    
    var body: some View {
            List(getFeedbacks.feedbacks.indices, id: \.self){ index in
                NavigationLink(destination: FeedbackDetail(feedback: self.$getFeedbacks.feedbacks[index])){
                    FeedbackRow(feedback: self.$getFeedbacks.feedbacks[index])
                }
                
            
        }.onAppear(perform: {
            getFeedbacks.getFeedback()
        })
        
            .navigationBarItems(trailing:
                Button(action: {
                    getFeedbacks.feedbacks.removeAll()
                    getFeedbacks.getFeedback()
                }){
                    Image(systemName: "arrow.clockwise")
                                            
                }
            )
    }
}

struct FeedbackListView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackListView(getFeedbacks: getFeedbacks())
    }
}
