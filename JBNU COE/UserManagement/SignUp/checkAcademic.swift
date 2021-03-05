//
//  checkAcademic.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/15.
//

import SwiftUI

enum ActiveSheet: Identifiable{
    var id: Int{
        hashValue
    }
    
    case picker, check
}


struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}

struct checkAcademic: View {
    func openLibrary(){
        let library = "https://apps.apple.com/kr/app/%EC%A0%84%EB%B6%81%EB%8C%80%ED%95%99%EA%B5%90-%EB%AA%A8%EB%B0%94%EC%9D%BC-%EB%8F%84%EC%84%9C%EA%B4%80/id808652357"
        
        let libraryURL = URL(string: library)
        
        if UIApplication.shared.canOpenURL(libraryURL!){
            UIApplication.shared.openURL(libraryURL!)
        }
    }
    
    @Binding var showAcademic : Bool
    @State var depts = ["건축공학과", "고분자.나노공학과", "고분자섬유나노공학부", "신소재공학부", "기계공학과", "기계설계공학부", "기계시스템공학부", "도시공학과", "바이오메디컬공학부", "산업정보시스템공학과", "소프트웨어공학과",
    "양자시스템공학과", "유기소재파이버공학과", "유기소재섬유공학과", "융합기술공학과", "융합기술공학부","자원.에너지공학과", "전기공학과", "전자공학부", "컴퓨터공학부", "토목/환경/자원.에너지공학부", "항공우주공학과",
    "화학공학부", "IT응용시스템공학과", "IT정보공학과"]
    
    @State var selected = 0
    @State var showImagePicker = false
    @State var pickedImage : Image?
    @State var inputImage : UIImage?
    @State var showSheet = false
    @State var studentNo = ""
    @State var result = false
    @Binding var name : String
    @Binding var password : String
    @Binding var phone : String
    @Binding var mail : String
    @State var showProgress = false
    @State var showAlert = false
    @State var finalResult = ""
    @State var activeSheet: ActiveSheet?

    func loadImage(){
        guard let inputImage = inputImage else{return}
        pickedImage = Image(uiImage: inputImage)
    }
    
    var body: some View {
        ScrollView{
            VStack {
                Group{
                    Spacer()
                    
                    Text("이제 학적사항을 확인합니다.")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("학과를 선택하세요.")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Picker(selection: $selected, label: Text("학과를 선택하세요.")){
                        ForEach(0..<depts.count){
                            Text(self.depts[$0])
                        }
                    }
                    
                    TextField("학번", text: $studentNo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(20)
                    
                    Spacer()
                }
                
                Group{
                    Text("학생증 불러오기")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("학우님의 학생증은 별도로 저장되지 않습니다.")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    
                    Spacer()

                    if pickedImage != nil{
                        pickedImage?
                            .resizable()
                            .scaledToFit()
                    }
                    
                    Button(action: {
                        self.showSheet = true
                    }){
                        HStack {
                            Text("학생증 로드")
                            Image(systemName: "chevron.right.circle")
                        }
                    }
                    
                    Spacer()
                    
                    VStack{
                        Text("인증 실패 화면이 계속 표시되나요?")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("1. 자르거나 수정하지 않은 원본 이미지인지 확인해주세요.")
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        Text("2. 선택한 학과명과 학생증의 학과명을 확인해주세요.")
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        Text("3. 학생증의 학과가 없는 경우 공과대학 SNS에 문의해주세요.")
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }.padding(15).background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.gray).opacity(0.2))
                    
                    HStack {
                        Button(action: {
                            self.showAcademic = false
                        }){VStack{
                            Image(systemName : "arrow.left.circle")
                                .resizable()
                                .frame(width : 50, height : 50)
                                .foregroundColor(.gray)
                            
                            Text("이전")
                                .foregroundColor(.gray)
                        }}
                        
                        Spacer().frame(width : 50)
                        

                        
                        Button(action: {
                            if studentNo != "" && inputImage != nil{
                                activeSheet = .check
                            }
                            
                            else{
                                showAlert = true
                            }
                                                        
                        }){VStack{
                            Image(systemName : "arrow.right.circle")
                                .resizable()
                                .frame(width : 50, height : 50)
                                .foregroundColor(.gray)
                            
                            Text("다음")
                                .foregroundColor(.gray)
                        }}
                    }
                }
                
                Spacer()
            }
        }.actionSheet(isPresented: $showSheet, content: {
            ActionSheet(title: Text("학생증 로드"), message: Text("캡처된 학생증이 있는 경우 학생증 로드,\n학생증을 캡처해야할 경우 모바일 도서관 앱 열기 버튼을 클릭하십시오."), buttons:[
                .default(Text("학생증 로드"), action:{activeSheet = .picker
                    showImagePicker = true
                }),
                .default(Text("모바일 도서관 앱 열기"), action: openLibrary),
                .cancel(Text("취소").foregroundColor(.red))
            ])
        })
        
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("학적사항 입력"), message: Text("모든 요구사항을 충족시켜주십시오."), dismissButton: .default(Text("확인")))
        })
        
        .sheet(item: $activeSheet){item in
            switch item{
            case .check:
                check(showProgress: $showProgress, inputImage: $inputImage, studentNo: $studentNo, name: $name, password: $password, dept: $depts[selected], phone: $phone, mail: $mail)
            case .picker:
                ImagePicker(image: self.$inputImage)
            }
        }
    }
}

struct checkAcademic_Previews: PreviewProvider {
    static var previews: some View {
        checkAcademic(showAcademic: .constant(true), name: .constant(""), password : .constant(""), phone: .constant(""), mail : .constant(""))
    }
}
