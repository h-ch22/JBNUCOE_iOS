//
//  FeedbackDetail.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI
import FirebaseFirestore

struct FeedbackDetail: View {
    @Binding var feedback : Feedback
    @State var author = ""
    @State var date = ""
    @State var type = ""
    @State var category = ""
    @State var Feedback = ""

    func loadFeedback(){
        let docRef = db.collection("Feedback").document(feedback.title)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                date.append(document.get("Date Time") as! String)
                author.append(document.get("author") as! String)
                type.append(document.get("Type") as! String)
                category.append(document.get("Category") as! String)
                Feedback.append(document.get("Feedback") as! String)
            }
        }
    }
    
    init(feedback: Binding<Feedback>){
        self._feedback = feedback
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(feedback.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text("작성자 : " + author)
            
            Text("작성일 : " + date)
            
            Text("카테고리 : " + category)
            
            Text("분류 : " + type)
            
            Spacer().frame(height: 30)

            ScrollView{
                VStack{
                    Text(Feedback)
                        .padding(20)
                        .background(Rectangle().foregroundColor(.blue).opacity(0.2))
                }
            }

            Spacer()

        }.padding(30)
        .navigationBarTitle(feedback.title)
        .onAppear(perform: {
            loadFeedback()
        })
    }
}

struct FeedbackDetail_Previews: PreviewProvider {
    @State static var feedback = Feedback(title: "title", author: "author", date: "date", category: "", type: "category", contents: "contents")
    static var previews: some View {
        FeedbackDetail(feedback:  $feedback)
    }
}
