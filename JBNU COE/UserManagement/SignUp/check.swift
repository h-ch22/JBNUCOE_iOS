//
//  check.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/15.
//

import SwiftUI
import Firebase

struct check: View {
    @Binding var showProgress : Bool
    @Binding var inputImage: UIImage?
    @Binding var studentNo : String
    @Binding var name : String
    @Binding var password : String
    @Binding var dept : String
    @Binding var phone : String
    @State var processSignUp = false
    @State var showSheet = false
    @Binding var mail : String
    @Environment(\.presentationMode) private var presentationMode

    @State var resultFinal = ""{
        didSet(newVal){
            if newVal == "success"{
                processSignUp = true
                showSheet = false
                print("value changed to success")
                print("variable : ", processSignUp)
            }
            
            if newVal == "fail"{
                showSheet = true
                processSignUp = false
            }
        }
    }
    
    func check(){
        var resultProcess = 0
        var checkResult = false
        let vision = Vision.vision()
        var resultStudetNo = false
        var resultDept = false
        var resultName = false
        var resultCheck = false
        let options = VisionCloudTextRecognizerOptions()
        options.languageHints = ["ko"]
        let textRecognizer = vision.cloudTextRecognizer(options: options)
 
        
        let image = VisionImage(image: inputImage!)
        
        textRecognizer.process(image){result, error in
            guard error == nil, let result = result else{
                return
            }
            
            let resultText = result.text
            var tmpArr : [String] = []
            
            for block in result.blocks{
                let blockText = block.text
                
                for line in block.lines{
                    let lineText = line.text
                    print("studentNo", lineText == studentNo)
                    print("name", lineText == name)
                    print("dept", lineText == dept)
                    print(lineText)
                    
                    if lineText == studentNo{
                        resultStudetNo = true
                    }
                    
                    if lineText == "개인학습실"{
                        resultCheck = true
                    }
                    
                    if lineText == dept{
                        resultDept = true

                    }
                    
                    if lineText == name{
                        resultName = true
                    }

                }

                if resultStudetNo && resultDept && resultName && resultCheck{
                    print("passed")
                    resultFinal = "success"
                }
                
                if !resultStudetNo || !resultDept || !resultName || !resultCheck{
                    print("studentNo", resultStudetNo)
                    print("dept, ",  resultDept)
                    print("name", resultName)
                    print("check", resultCheck)
                    resultFinal = "fail"
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
            Spacer().frame(height : 20)
            Text("학생증 정보를 확인하고 있습니다.\n잠시 기다려 주십시오.")
                .multilineTextAlignment(.center)
        }.onAppear(perform: {
            check()
        })
        .actionSheet(isPresented: $showSheet, content: {
            ActionSheet(title: Text("유효성 검사 실패"), message: Text("학생증의 정보와 입력한 정보가 일치하지 않거나, 유효하지 않는 학생증입니다."), buttons:[
                .default(Text("다시 시도"), action:{self.showProgress.toggle()
                    self.presentationMode.wrappedValue.dismiss()
                    check()
                }),
                .default(Text("가입 취소").foregroundColor(.red), action:{SignIn().navigationBarHidden(true)})
            ])
        })
        .fullScreenCover(isPresented: $processSignUp, content: {
            signUpProgress(processSignUp: $processSignUp, name: $name, phone: $phone, studentNo: $studentNo, dept: $dept, password: $password, mail: $mail)
        })
        
        
//        .sheet(isPresented: $processSignUp, content: {
//            signUpProgress(processSignUp: $processSignUp)
//        })
    }
}

//struct check_Previews: PreviewProvider {
//    static var previews: some View {
//        check(showProgress: .constant(true), inputImage: .constant(""), studentNo: .constant(""), name: .constant(""), password: .constant(""), dept: .constant(""), phone: .constant(""))
//    }
//}
