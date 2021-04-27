//
//  myFeedbackDetails.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/04/10.
//

import SwiftUI

struct myFeedbackDetails: View {
    @Binding var feedback : myFeedback
    @State var author = ""
    @State var date = ""
    @State var type = ""
    @State var category = ""
    @State var Feedback = ""
    @State var answer = ""
    @State var answer_author = ""

    func loadFeedback(){
        let docRef = db.collection("Feedback").document(feedback.title)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                date.append(document.get("Date Time") as! String)
                type.append(document.get("Type") as! String)
                category.append(document.get("Category") as! String)
                Feedback.append(document.get("Feedback") as! String)
                
                if feedback.answered{
                    answer.append(document.get("answer") as! String)
                    
                    if document.get("answer_author") != nil{
                        answer_author.append(document.get("answer_author") as! String)
                    }
                }
            }
        }
    }
    
    init(feedback: Binding<myFeedback>){
        self._feedback = feedback
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(feedback.title)
                .font(.title)
                .fontWeight(.bold)
                        
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
            
            if answer != ""{
                ScrollView{
                    VStack{
                            Text("피드백에 대한 답변입니다.")
                                .font(.title)
                            
                            Text(answer)
                                .padding(20)
                                .background(Rectangle().foregroundColor(.red).opacity(0.2))
                        
                        if answer_author != ""{
                            HStack {
                                Image(systemName : "checkmark.shield.fill")
                                    .foregroundColor(.green)
                                
                                Text("답변 작성자 : " + answer_author)
                                    .foregroundColor(.green)

                            }
                        }
                    }
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
