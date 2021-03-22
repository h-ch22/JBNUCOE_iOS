//
//  HandWritingEdit.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/18.
//

import SwiftUI
import FirebaseFirestore

enum editAlert{
    case question, success, fail, noContents
}

struct HandWritingEdit: View {
    @Binding var title : String
    @Binding var contents : String
    @State private var showAlert = false
    @State private var isHidden = true
    @State private var alertType : editAlert = .question
    
    func edit_upload(){
        if contents == ""{
            isHidden = true
            alertType = .noContents
            showAlert = true
        }
        
        else{
            let docRef = db.collection("HandWriting").document(title)
            
            docRef.updateData(["contents" : contents]){
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
    
    var body: some View {
        ScrollView{
            VStack{
                Text(title).foregroundColor(.gray).padding()
                
                TextEditor(text : $contents).textFieldStyle(RoundedBorderTextFieldStyle()).padding().lineSpacing(10).frame(height : UIScreen.main.bounds.height / 2)

                
            }.navigationBarTitle("수기 작성하기").navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: Button(action : {
                                                    alertType = .question
                                                    showAlert = true
                
            }){Image(systemName: "paperplane.fill")})
            
            .alert(isPresented: $showAlert){
                switch alertType{
                case .question:
                    return Alert(title: Text("작성 확인".localized()), message: Text("게시글을 등록하시겠습니까?".localized()), primaryButton: .destructive(Text("예".localized())){
                        isHidden = false
                        edit_upload()
                    }, secondaryButton: .destructive(Text("아니오".localized())))
                
                case .noContents:
                    return Alert(title: Text("오류".localized()), message: Text("제목과 내용을 입력하십시오.".localized()), dismissButton: .default(Text("확인")))
                    
                case .fail:
                    return Alert(title: Text("오류".localized()), message: Text("게시글 업로드 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오.".localized()), dismissButton: .default(Text("확인")))

                case .success:
                    return Alert(title: Text("업로드 완료".localized()), message: Text("게시글이 정상적으로 업로드 되었습니다.".localized()), dismissButton: .default(Text("확인")))

                }
                
            }
            
            .overlay(Group{
                if !isHidden{
                    Progress()
                }
                
                else{
                    EmptyView()
                }
            })
        }
    }
}
