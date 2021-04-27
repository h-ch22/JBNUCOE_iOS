//
//  FeedbackDetail.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

enum answer_alert{
    case noContents, fail, success, question
}

struct FeedbackDetail: View {
    @Binding var feedback : Feedback
    @State var author = ""
    @State var date = ""
    @State var type = ""
    @State var category = ""
    @State var Feedback = ""
    @State var answer = ""
    @State private var showAlert = false
    @State var alertType : answer_alert = .question
    @State var isHidden = true
    @State var answer_new = ""
    @State var answer_author = ""
    
    func sendAnswer(){
        let docRef = db.collection("Feedback").document(feedback.title)
        let adminRef = db.collection("User").document("Admin")
        let userRef = db.collection("User").document((Auth.auth().currentUser?.email)!)
        
        userRef.getDocument(){(document, err) in
            if let document = document{
                let studentNo = document.get("studentNo") as! String
                
                adminRef.getDocument(){(document, err) in
                    if let document = document{
                        let admin = document.get(studentNo) as! String
                        
                        docRef.updateData([
                            "answer" : answer_new,
                            "answer_author" : admin
                        ]){
                            err in
                            if let err = err{
                                isHidden = true
                                print(err)
                                alertType = .fail
                                showAlert = true
                            }
                            
                            else{
                                isHidden = true
                                alertType = .success
                                showAlert = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadFeedback(){
        let docRef = db.collection("Feedback").document(feedback.title)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                date.append(document.get("Date Time") as! String)
                author.append(document.get("author") as! String)
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
            
            Group{
                Text("피드백 답변하기")
                    .font(.title)
                
                ZStack(alignment: .topLeading) {
                    if answer_new.isEmpty {
                        HStack {
                            Text("피드백의 답변을 입력하세요.")
                                .padding()
                            Spacer()
                        }
                    }
                    
                    TextEditor(text: $answer_new)
                        .padding().lineSpacing(10).frame(height : UIScreen.main.bounds.height / 4).opacity(answer_new.isEmpty ? 0.25 : 1)
                }
            }


        }.padding(30)
        .navigationBarTitle(feedback.title)
        .navigationBarItems(trailing: Button(action : {
            if answer_new == "" || answer_new == "피드백의 답변을 입력하세요."{
                isHidden = true
                alertType = .noContents
                showAlert = true
            }
            
            else{
                alertType = .question
                showAlert = true
            }
            
        }){Image(systemName: "paperplane.fill")})
        
        .onAppear(perform: {
            loadFeedback()
        })
        
        .overlay(Group{
            if !isHidden{
                Progress()
            }
            
            else{
                EmptyView()
            }
        })
        
        .alert(isPresented: $showAlert){
            switch alertType{
            case .question:
                return Alert(title: Text("작성 확인".localized()), message: Text("답변을 등록하시겠습니까?".localized()), primaryButton: .destructive(Text("예".localized())){
                    isHidden = false
                    sendAnswer()
                }, secondaryButton: .destructive(Text("아니오".localized())))
                
            case .noContents:
                return Alert(title: Text("오류".localized()), message: Text("피드백의 답변을 입력하십시오.".localized()), dismissButton: .default(Text("확인".localized())))
                
            case .fail:
                return Alert(title: Text("오류".localized()), message: Text("업로드 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오.".localized()), dismissButton: .default(Text("확인".localized())))
                
            case .success:
                return Alert(title: Text("업로드 완료".localized()), message: Text("답변이 정상적으로 업로드 되었습니다.".localized()), dismissButton: .default(Text("확인".localized())){
                })
                
            }
            
        }
    }
}

struct FeedbackDetail_Previews: PreviewProvider {
    @State static var feedback = Feedback(title: "title", author: "author", date: "date", category: "", type: "category", contents: "contents", answered: false)
    
    static var previews: some View {
        FeedbackDetail(feedback:  $feedback)
    }
}
