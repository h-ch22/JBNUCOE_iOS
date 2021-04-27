//
//  more.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/11.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SDWebImageSwiftUI
import UIKit

var email : String = ""
var name : String = ""
var isProcessing : Bool = false

enum userAlert{
    case secession, signOut
}

enum loadView: Identifiable{
    var id: Int{
        hashValue
    }
    
    case secession, Feedbackhub, signOut, imagePicker, changePW
}

func changeProfile(inputImage : UIImage?){
    let storage = Storage.storage()
    let stroageRef = storage.reference()
    let profileRef = stroageRef.child("profile/" + (Auth.auth().currentUser?.email)! + "/" + "profile_" + (Auth.auth().currentUser?.email)! + ".jpg")
    
    var data = NSData()
    data = (inputImage?.jpegData(compressionQuality: 0.8))! as NSData
    
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"
    
    profileRef.putData(data as Data, metadata: metaData){(metaData, err) in
        if let err = err{
            print(err)
            isProcessing = false
        }
        
        else{
            print("profile image change successful.")
            more().loadProfile()
        }
    }
}

struct showImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: showImagePicker
        
        init(_ parent: showImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
            isProcessing = true
            
            changeProfile(inputImage: parent.image)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<showImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<showImagePicker>) {
        
    }
}

struct profileView : View{
    @Binding var imageURL : URL?
    
    var body: some View{
        WebImage(url: imageURL)
            .resizable()
            .frame(width: 100, height: 100, alignment: .leading)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
    }
}

struct more: View {
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    @State private var imageURL = URL(string: ""){
        didSet{
            loadProfile()
        }
    }
    
    @State private var name : String = ""
    @State var secession = false
    @State var signOut = false
    @State private var dept : String = ""
    @State private var isModalShowing : Bool = false
    @State private var spot : String = ""
    @EnvironmentObject var userManagement : UserManagement
    @State var userAlert : userAlert = .signOut
    @State private var mail : String = ""
    @State private var studentNo : String = ""
    @State var secessionAlert = false
    @State var showAlert = false
    @State var loadView : loadView?
    @State var showSecession = false
    @State var showSignOut = false
    @State var showFeedbackHub = false
    @State var showImagePicker = false
    @State var showchangePW = false
    @State var pickedImage : Image?
    @State var inputImage : UIImage?
    @ObservedObject var license = loadLicense()
    @State var isChanging = false
    @ObservedObject var text = loadText()

    
    init(){
        db = Firestore.firestore()
    }
    
    func loadProfile(){
        if Auth.auth().currentUser != nil{
            let storageRef = Storage.storage().reference(withPath:"profile/" + (Auth.auth().currentUser?.email)! + "/profile_" + (Auth.auth().currentUser?.email)! + ".jpg")
            
            storageRef.downloadURL{(url, error) in
                if error != nil{
                    print((error?.localizedDescription))
                    
                    self.imageURL = URL(string: "")
                }
                
                else{
                    self.imageURL = url!
                    isProcessing = false
                }
            }
        }
        
        else{
            
        }
        
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.background_home.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

                VStack(alignment:.center) {
                    HStack{
                        profileView(imageURL: $imageURL)
                        
                        Spacer().frame(width : 10)
                        
                        VStack(alignment: .leading) {
                            Text(userManagement.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            
                            Text(userManagement.dept)
                            Text(userManagement.studentNo)
                            
                            if userManagement.isAdmin{
                                HStack{
                                    Image(systemName : "checkmark.shield.fill")
                                        .foregroundColor(.green)
                                    
                                    Text(userManagement.spot)
                                        .foregroundColor(.green)
                                }
                            }
                            
                            else{
                                HStack{
                                    
                                }
                            }
                            
                            Button(action: {
                                loadView = .imagePicker
                                showImagePicker = true
                            }){
                                Text("프로필 이미지 변경".localized())
                                    .foregroundColor(.gray)
                            }.padding(5)
                            .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                        }
                    }
                    .padding()
                    
                    ScrollView{
                        VStack{
                            Group{
                                NavigationLink(destination: StudentCouncil_main()){
                                    HStack{
                                        Image("ic_coelogo")
                                            .resizable()
                                            .frame(width : 30, height : 30)

                                        Text("공대 학생회 소개 및 정보".localized())
                                            .foregroundColor(Color.txtcolor)
                                        
                                        Spacer()
                                    }
                                }.frame(width: 300, height: 50)
                                .padding()
                                .background(Color.background_button)
                                .cornerRadius(5)
                                
                                NavigationLink(destination: StudentCouncil_PledgeProgress()){
                                    HStack{
                                        Image("ic_percentage")
                                            .resizable()
                                            .frame(width : 30, height : 30)

                                        Text("실시간 공약 이행률".localized())
                                            .foregroundColor(Color.txtcolor)
                                        
                                        Spacer()
                                    }
                                }.frame(width: 300, height: 50)
                                .padding()
                                .background(Color.background_button)
                                .cornerRadius(5)
                                
                                NavigationLink(destination: DisplayCalendar().navigationBarTitle("취업 캘린더".localized()).navigationBarTitleDisplayMode(.inline)) {
                                    HStack{
                                        Image("ic_calendar")
                                            .resizable()
                                            .frame(width : 30, height : 30)
                                        
                                        Text("취업 캘린더".localized()).foregroundColor(Color.txtcolor)
                                        
                                        Spacer()

                                    }.frame(width: 300, height: 50)
                                    .padding()
                                    .background(Color.background_button)
                                    .cornerRadius(5)
                                }
                                
                                
                                NavigationLink(destination: CampusMapView()) {
                                    HStack{
                                        Image("ic_map")
                                            .resizable()
                                            .frame(width: 30,
                                                   height :30)
                                        
                                        
                                        Text("캠퍼스 맵".localized()).foregroundColor(Color.txtcolor)
                                        
                                        Spacer()

                                    }.frame(width: 300, height: 50)
                                    .padding()
                                    .background(Color.background_button)
                                    .cornerRadius(5)
                                }
                                                                
                                NavigationLink(destination: Products()) {
                                    HStack{
                                        Image("ic_products")
                                            .resizable()
                                            .frame(width: 30,
                                                   height :30)
                                        
                                        
                                        Text("대여 사업 잔여 수량 확인".localized()).foregroundColor(Color.txtcolor)
                                        
                                        Spacer()

                                    }.frame(width: 300, height: 50)
                                    .padding()
                                    .background(Color.background_button)
                                    .cornerRadius(5)
                                }
                                
                                NavigationLink(destination: DeliveryView()) {
                                    HStack{
                                        Image("ic_box")
                                            .resizable()
                                            .frame(width: 30,
                                                   height :30)
                                        
                                        
                                        Text("택배 대리 수령 요청".localized()).foregroundColor(Color.txtcolor)
                                        
                                        Spacer()

                                    }.frame(width: 300, height: 50)
                                    .padding()
                                    .background(Color.background_button)
                                    .cornerRadius(5)
                                }
                            }
                            
                            Group{
                                NavigationLink(destination: HandWriting_ListView(getHandWritingList: getHandWritingList())) {
                                    HStack{
                                        Image("ic_crown")
                                            .resizable()
                                            .frame(width: 30,
                                                   height :30)


                                        Text("합격자 수기 공유".localized()).foregroundColor(Color.txtcolor)
                                        
                                        Spacer()
                                    }.frame(width: 300, height: 50)
                                    .padding()
                                    .background(Color.background_button)
                                    .cornerRadius(5)
                                }
                                
                                Button(action:{
                                    loadView = .Feedbackhub
                                    showFeedbackHub = true
                                }){
                                    HStack{
                                        Image("ic_feedback")
                                            .resizable()
                                            .frame(width: 30,
                                                   height : 30)
                                        
                                        
                                        Text("피드백 허브".localized()).foregroundColor(Color.txtcolor)
                                        
                                        Spacer()

                                    }.frame(width: 300, height: 50)
                                    .padding()
                                    .background(Color.background_button)
                                    .cornerRadius(5)
                                    
                                }.fullScreenCover(isPresented: $secession, content: {
                                    secessionView(secession: $secession)
                                })
                                
                                
                            }
                            
                            Button(action:{
                                loadView = .changePW
                                showchangePW = true
                            }){
                                HStack{
                                    Image("ic_password")
                                        .resizable()
                                        .frame(width: 30,
                                               height : 30)
                                    
                                    Text("비밀번호 변경".localized())
                                        .foregroundColor(Color.txtcolor)
                                    
                                    Spacer()

                                }.frame(width: 300, height: 50)
                                .padding()
                                .background(Color.background_button)
                                .cornerRadius(5)
                            }
                            
                            Button(action:{
                                userAlert = .signOut
                                showAlert = true
                            }){
                                HStack{
                                    Image(systemName : "xmark.octagon.fill")
                                        .resizable()
                                        .frame(width: 30,
                                               height : 30)
                                        .foregroundColor(.red)
                                    
                                    Text("로그아웃".localized())
                                        .foregroundColor(.red)
                                    
                                    Spacer()

                                }.frame(width: 300, height: 50)
                                .padding()
                                .background(Color.background_button)
                                .cornerRadius(5)
                            }
                            
                                                        
                            Button(action:{
                                userAlert = .secession
                                showAlert = true
                                
                            }){
                                HStack{
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 30,
                                               height : 30)
                                        .foregroundColor(.red)
                                    
                                    
                                    Text("회원 탈퇴".localized())
                                        .foregroundColor(.red)
                                    
                                    Spacer()

                                }.frame(width: 300, height: 50)
                                .padding()
                                .background(Color.background_button)
                                .cornerRadius(5)
                            }
                            
                        }.padding(30)
                    }
                }.navigationBarTitle("더 보기".localized(), displayMode: .large)
                .onAppear(perform: {
                    userManagement.getEmail()
                    loadProfile()
                    self.isChanging = isProcessing
                })
                .alert(isPresented: $showAlert){
                    switch userAlert{
                    case .secession:
                        return Alert(title: Text("회원 탈퇴 확인".localized()), message: Text("회원 탈퇴 시 모든 정보가 제거되며, 추후 서비스 재이용 시 다시 가입하셔야합니다.\n계속 하시겠습니까?".localized()), primaryButton: .destructive(Text("예".localized())){
                            loadView = .secession
                            showSecession = true
                        }, secondaryButton: .destructive(Text("아니오".localized())))
                        
                    case .signOut:
                        return Alert(title: Text("로그아웃 확인".localized()), message: Text("로그아웃 시 자동로그인은 자동으로 해제됩니다.\n계속 하시겠습니까?".localized()), primaryButton: .destructive(Text("예".localized())){
                            loadView = .signOut
                            showSignOut = true
                        }, secondaryButton: .destructive(Text("아니오".localized())))
                    }
                    
                }
                
                .sheet(item: $loadView){item in
                    switch item{
                    case .Feedbackhub:
                        FeedbackHub_category(show : $showFeedbackHub)
                        
                    case .secession:
                        secessionView(secession: $showSecession)
                        
                    case .signOut:
                        JBNU_COE.signOut(signOut : $signOut)
                        
                    case .imagePicker:
                        JBNU_COE.showImagePicker(image: self.$inputImage)
                        
                    case .changePW:
                        changePassword()
                    }
                }
                
                .overlay(Group{
                    if isProcessing{
                        Progress()
                    }
                    
                    else{
                        EmptyView()
                    }
            })
            }
            
            VStack {
                Text("선택된 카테고리 없음".localized())
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                
                Text("계속 하려면 화면 좌측의 버튼을 터치해 카테고리를 선택하십시오.".localized())
                    .foregroundColor(.gray)
            }
            
        }
        
    }
}

struct more_Previews: PreviewProvider {
    static var previews: some View {
        more()
    }
}
