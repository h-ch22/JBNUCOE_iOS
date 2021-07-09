//
//  FeedbackHub_main.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/12.
//

import SwiftUI
import FirebaseFirestore
import Firebase

enum feedbackAlert{
    case err, success, type, feedback
}

struct FeedbackHub_main: View {
    @State private var isHeartSelected : Bool = false
    @State private var isQuestionSelected : Bool = false
    @State private var isRequestSelected : Bool = false
    @State private var Feedback : String = ""
    @State private var type : String = ""
    @Binding var category : String
    @State private var category_KR = ""
    @State private var title = ""
    @State var textHeight: CGFloat = 10
    @State var activeAlert : feedbackAlert = .feedback
    @State var showAlert = false
    @EnvironmentObject var user : UserManagement
    @Environment(\.presentationMode) private var presentationMode
    @State var finResult = ""{
        didSet(newVal){
            if newVal == "success"{
                activeAlert = .success
                showAlert = true
            }
            
            if newVal == "err"{
                activeAlert = .err
                showAlert = true
            }
        }
    }
    
    func sendFeedback(Type : String, Feedback : String){
        var result : Bool = false
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if category == "Facility"{
            category_KR = "시설"
        }
        
        if category == "Welfare"{
            category_KR = "복지"
        }
        
        if category == "Communication"{
            category_KR = "소통"
        }
        
        if category == "Promise"{
            category_KR = "공약"
        }
        
        if category == "Event"{
            category_KR = "행사"
        }
        
        if category == "App"{
            category_KR = "앱"
        }
        
        if category == "" || category == "Others"{
            category_KR = "기타"
        }
        
        if category == "Complaints"{
            category_KR = "민원사업"
        }
        
        db.collection("Feedback").document(title).setData([
            "Feedback": Feedback,
            "Category" : category_KR,
            "Type" : type,
            "Date Time" : dateFormat.string(from: now),
            "author" : user.dept + " " + user.studentNo + " " + user.name,
            "mail" : Auth.auth().currentUser?.email as! String
        ]){err in
            if let err = err{
                result = false
                finResult = "err"
                
            }
            
            else{
                result = true
                finResult = "success"
            }
        }
    }
    
    var body: some View {
            ScrollView{
                Group{
                    VStack{
                        Spacer()
                        
                        Image("bg_feedbackHub")
                            .resizable()
                            .frame(width : 250, height: 250)
                        Text("학우님의 의견을 들려주세요.".localized())
                            .font(.title)
                            .fontWeight(.bold)
                                    
                        Spacer()
                        
                        VStack {
                            Button(action: {
                                isQuestionSelected = false
                                isHeartSelected  = true
                                isRequestSelected = false
                            }){
                                HStack{
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(isHeartSelected ? Color.red : Color.gray)
                                    
                                    Text("칭찬해요".localized())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(isHeartSelected ? Color.red : Color.gray)
                                }
                            }.frame(width : 250,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                                        .stroke(isHeartSelected ? Color.red : Color.gray, lineWidth: 3))
                            
                            Button(action: {
                                isQuestionSelected = false
                                isHeartSelected  = false
                                isRequestSelected = true
                            }){
                                HStack{
                                    Image(systemName: "chevron.right.2")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(isRequestSelected ? Color.blue : Color.gray)
                                        .rotationEffect(Angle(degrees: -90))

                                    Text("개선해주세요".localized())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(isRequestSelected ? Color.blue : Color.gray)
                                }
                            }.frame(width : 250,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                                        .stroke(isRequestSelected ? Color.blue : Color.gray, lineWidth: 3))
                            
                            Button(action: {
                                isQuestionSelected = true
                                isHeartSelected  = false
                                isRequestSelected = false
                            }){
                                HStack{
                                    Image(systemName: "questionmark")
                                        .resizable()
                                        .frame(width : 20, height : 30)
                                        .foregroundColor(isQuestionSelected ? Color.orange : Color.gray)
                                    
                                    Text("궁금해요".localized())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(isQuestionSelected ? Color.orange : Color.gray)
                                }
                            }.frame(width : 250,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                                        .stroke(isQuestionSelected ? Color.orange : Color.gray, lineWidth: 3))
                        }
                        
                        
                        Spacer()
                        
                        TextField("제목".localized(), text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.horizontal],30)
                        
                        ZStack(alignment: .topLeading) {
                            if Feedback.isEmpty {
                                HStack {
                                    Text("피드백의 내용을 입력하세요.")
                                        .padding()
                                    Spacer()
                                }
                            }
                            
                            TextEditor(text: $Feedback)
                                .padding().lineSpacing(10).frame(height : UIScreen.main.bounds.height / 2).opacity(Feedback.isEmpty ? 0.25 : 1)
                        }

                        Spacer()
                        
                        Button(action: {
                            if isQuestionSelected{
                                type = "궁금해요"
                            }
                            
                            if isHeartSelected{
                                type = "칭찬해요"
                            }
                            
                            if isRequestSelected{
                                type = "개선해주세요"
                            }
                            
                            if isQuestionSelected || isHeartSelected || isRequestSelected{
                                if Feedback != "" && title != ""{
                                    sendFeedback(Type: type, Feedback: Feedback)
                                }
                                
                                else{
                                    showAlert = true
                                    self.activeAlert = .feedback
                                }
                            }
                            
                            else{
                                showAlert = true
                                self.activeAlert = .type
                            }
                        }){
                            HStack{
                                Text("피드백 보내기".localized())
                                    .foregroundColor(.white)
                                Image(systemName : "chevron.right")
                                    .foregroundColor(.white)
                            }.background(Rectangle().foregroundColor(
                                .orange
                            ).frame(width : UIScreen.main.bounds.width,
                                    height : 60))
                        }
                    }
                }.alert(isPresented: $showAlert){
                    switch activeAlert{
                    case .feedback:
                        return Alert(title : Text("내용 입력".localized()),
                                     message: Text("피드백의 제목과 내용을 입력해주세요.".localized()),
                                     dismissButton: .default(Text("확인".localized())){showAlert = false})
                        
                    case .err:
                        return Alert(title : Text("죄송합니다, 학우님.".localized()),
                              message: Text("피드백을 전송하는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도해주세요.".localized()),
                              dismissButton: .default(Text("확인".localized())){showAlert = false})
                        
                    case .success:
                        return Alert(title : Text("피드백 전송 완료".localized()),
                              message: Text("피드백이 정상적으로 전송되었습니다.\n학우님의 소중한 피드백은 관련 부서로 전달하여, 충분히 검토한 후 최대한 반영하기 위해 노력하겠습니다.\n감사합니다.".localized()),
                              dismissButton: .default(Text("확인".localized())){
                                showAlert = false
                                self.presentationMode.wrappedValue.dismiss()

                              })
                        
                    case .type:
                    return Alert(title : Text("주제 선택".localized()),
                          message: Text("피드백의 주제를 선택해주세요.".localized()),
                          dismissButton: .default(Text("확인".localized())){showAlert = false})
                    }
                    
            }
        }
            
        
    }
}

struct FeedbackHub_main_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackHub_main(category: .constant(""))
    }
}
