//
//  HandWriting_Write.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/16.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Foundation

extension String {
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

enum write_alert{
    case noContents, fail, success, question, tmp, limit
}

struct HandWriting_Write: View {
    @ObservedObject var mediaItems = PickedMediaItems()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var title : String = ""
    @State private var showImageSheet = false
    @State private var showAlert = false
    @EnvironmentObject var user : UserManagement
    @State var alertType : write_alert = .question
    @State var isHidden = true
    @State private var uploadSuccess = false
    @State var examName : String = ""
    @State var selectedDate = Date()
    @State var meter : String = ""
    @State var term : String = ""
    @State var review : String = ""
    @State var howTO : String = ""
    
    func upload(){
        let now = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        Progress()
        
        var phone : String = ""
        var name : String = user.name
        var studentNo : String = user.studentNo
        var fullName : String = ""
        
        var firstName = name[name.startIndex]
        
        fullName.insert(firstName, at: fullName.startIndex)
        
        for i in 0..<name.count-1{
            fullName.insert("*", at:fullName.endIndex)
        }
        
        let studentNo_year = studentNo[2 ..< 4]
        
        let id = String((0..<15).map{ _ in letters.randomElement()! })
        let mail = Auth.auth().currentUser?.email as! String
        
        let docRef = db.collection("User").document(mail)
        
        docRef.getDocument(){(document, error) in
            if let document = document{
                phone.append(document.get("phone") as! String)
                phone = document.get("phone") as! String
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy. MM. dd."
                let date_fin = dateFormatter.string(from: selectedDate)
                
                db.collection("HandWriting").document().setData([
                    "examName" : examName,
                    "term" : term,
                    "examDate" : date_fin,
                    "review" : review,
                    "howTO" : howTO,
                    "meter" : meter,
                    "Date Time" : dateFormat.string(from: now),
                    "author" : user.dept + " " + studentNo_year + " " + fullName,
                    "mail" : mail,
                    "phone" : phone,
                    "read" : 0,
                    "recommend" : 0,
                    "title" : title,
                    "author_full" : user.dept + " " + user.studentNo + " " + user.name,
                    "id" : id,
                    "imageIndex" : mediaItems.items.count
                ]){err in
                    if let err = err{
                        isHidden = true
                        print(err)
                        alertType = .fail
                        showAlert = true
                    }
                    
                    else{
                        if !mediaItems.items.isEmpty{
                            for i in 0..<mediaItems.items.count{
                                let storage = Storage.storage()
                                let storageRef = storage.reference()
                                let imgRef = storageRef.child("handWriting/" + mail + "_" + id + "/" + String(i) + ".png")
                                
                                let uploadTask = imgRef.putFile(from: mediaItems.items[i].url, metadata: nil){metadata, error in
                                    guard let metadata = metadata else{return}
                                    let size = metadata.size
                                    
                                    imgRef.downloadURL{(url, error) in
                                        guard let downloadURL = url else{
                                            alertType = .fail
                                            showAlert = true
                                            
                                            return
                                        }
                                    }
                                }
                            }
                            
                            isHidden = true
                            alertType = .success
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
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Group{
                        TextField("제목".localized(), text: $title).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                        
                        Spacer()
                        
                        TextField("시험명".localized(), text: $examName).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                        
                        Spacer()
                        
                        Form{
                            DatePicker("시험 날짜".localized(), selection: $selectedDate, displayedComponents: [.date])
                            
                        }.frame(height : 100)
                        
                        Spacer()
                        
                        TextField("시험 준비 기간".localized(), text: $term).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                        
                        Spacer()
                        
                        ZStack(alignment: .topLeading) {
                            if meter.isEmpty {
                                HStack {
                                    Text("시험을 보게 된 계기")
                                        .padding()
                                    Spacer()
                                }
                            }
                            
                            TextEditor(text: $meter)
                                .padding().lineSpacing(10).frame(height : UIScreen.main.bounds.height / 4).opacity(meter.isEmpty ? 0.25 : 1)
                        }
                        
                        Spacer()
                        
                        
                    }
                    
                    ZStack(alignment: .topLeading) {
                        if review.isEmpty {
                            HStack {
                                Text("시험을 본 후기")
                                    .padding()
                                Spacer()
                            }
                        }
                        
                        TextEditor(text: $review)
                            .padding().lineSpacing(10).frame(height : UIScreen.main.bounds.height / 4).opacity(review.isEmpty ? 0.25 : 1)
                    }
                    
                    ZStack(alignment: .topLeading) {
                        if howTO.isEmpty {
                            HStack {
                                Text("자신만의 공부법")
                                    .padding()
                                Spacer()
                            }
                        }
                        
                        TextEditor(text: $howTO)
                            .padding().lineSpacing(10).frame(height : UIScreen.main.bounds.height / 4).opacity(howTO.isEmpty ? 0.25 : 1)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button(action : {showImageSheet = true}){
                            Image(systemName: "camera.fill").resizable().frame(width : 30, height : 20)
                        }
                        
                        ScrollView(.horizontal){
                            HStack {
                                ForEach(mediaItems.items, id: \.id){ item in
                                    Image(uiImage: item.photo ?? UIImage()).resizable().frame(width : 100, height : 100).aspectRatio(contentMode: .fit)
                                }
                            }
                        }
                    }
                    
                    .frame(height : 100).padding()
                    
                }.navigationBarTitle("수기 작성하기".localized()).navigationBarTitleDisplayMode(.large)
                
                .navigationBarItems(leading : Button("닫기".localized()){
                    self.presentationMode.wrappedValue.dismiss()
                },trailing: Button(action : {
                    if title.isEmpty || examName.isEmpty ||  meter.isEmpty || term.isEmpty || review.isEmpty || howTO.isEmpty{
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
                    if (UserDefaults.standard.string(forKey: "title") != nil || UserDefaults.standard.string(forKey: "examName") != nil) && (UserDefaults.standard.string(forKey: "meter") != nil || UserDefaults.standard.string(forKey: "term") != nil || UserDefaults.standard.string(forKey: "review") != nil || UserDefaults.standard.string(forKey: "howTO") != nil || UserDefaults.standard.string(forKey: "title") != "" || UserDefaults.standard.string(forKey: "examName") != "") && (UserDefaults.standard.string(forKey: "meter") != "" || UserDefaults.standard.string(forKey: "term") != "" || UserDefaults.standard.string(forKey: "review") != "" || UserDefaults.standard.string(forKey: "howTO") != "" ){
                        alertType = .tmp
                        showAlert = true
                    }
                })
                
                
                .onDisappear(perform: {
                    if !uploadSuccess{
                        if title != "" || examName != "" || meter != "" || term != "" || review != "" || howTO != ""{
                            UserDefaults.standard.set(title, forKey: "title")
                            UserDefaults.standard.set(examName, forKey: "examName")
                            UserDefaults.standard.set(meter, forKey: "meter")
                            UserDefaults.standard.set(term, forKey: "term")
                            UserDefaults.standard.set(review, forKey: "review")
                            UserDefaults.standard.set(howTO, forKey: "howTO")
                            
                        }
                    }
                    
                })
                
                .sheet(isPresented: $showImageSheet, content: {
                    PhotoPicker(mediaItems: mediaItems, isPresented: $showImageSheet)
                })
                
                .overlay(Group{
                    if !isHidden{
                        Progress()
                    }
                    
                    else{
                        EmptyView()
                    }
                })
                
                
            }
        }                .alert(isPresented: $showAlert){
            switch alertType{
            case .question:
                return Alert(title: Text("작성 확인".localized()), message: Text("게시글을 등록하시겠습니까?".localized()), primaryButton: .destructive(Text("예".localized())){
                    
                    isHidden = false
                    upload()
                }, secondaryButton: .destructive(Text("아니오".localized())))
                
            case .noContents:
                return Alert(title: Text("오류".localized()), message: Text("모든 필드를 채워주세요.".localized()), dismissButton: .default(Text("확인".localized())))
                
            case .fail:
                return Alert(title: Text("오류".localized()), message: Text("게시글 업로드 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오.".localized()), dismissButton: .default(Text("확인".localized())))
                
            case .success:
                return Alert(title: Text("업로드 완료".localized()), message: Text("게시글이 정상적으로 업로드 되었습니다.".localized()), dismissButton: .default(Text("확인".localized())){
                    uploadSuccess = true
                    self.presentationMode.wrappedValue.dismiss()
                })
                
            case .tmp:
                return Alert(title : Text("임시 저장된 항목".localized()), message: Text("임시 저장된 글이 있습니다.\n복구하시겠습니까?".localized()),
                             primaryButton: .destructive(Text("복구".localized())){
                                title = UserDefaults.standard.string(forKey: "title") ?? ""
                                examName = UserDefaults.standard.string(forKey: "examName") ?? ""
                                meter = UserDefaults.standard.string(forKey: "meter") ?? ""
                                term = UserDefaults.standard.string(forKey: "term") ?? ""
                                review = UserDefaults.standard.string(forKey: "review") ?? ""
                                howTO = UserDefaults.standard.string(forKey: "howTO") ?? ""
                                
                                UserDefaults.standard.removeObject(forKey: "title")
                                UserDefaults.standard.removeObject(forKey: "examName")
                                UserDefaults.standard.removeObject(forKey: "meter")
                                UserDefaults.standard.removeObject(forKey: "term")
                                UserDefaults.standard.removeObject(forKey: "review")
                                UserDefaults.standard.removeObject(forKey: "howTO")
                                
                             }, secondaryButton: .destructive(Text("제거".localized())){
                                UserDefaults.standard.removeObject(forKey: "title")
                                UserDefaults.standard.removeObject(forKey: "examName")
                                UserDefaults.standard.removeObject(forKey: "meter")
                                UserDefaults.standard.removeObject(forKey: "term")
                                UserDefaults.standard.removeObject(forKey: "review")
                                UserDefaults.standard.removeObject(forKey: "howTO")
                             })
                
            case .limit:
                return Alert(title: Text("글자 수 제한".localized()), message: Text("최소 250자 이상 입력하십시오.".localized()), dismissButton: .default(Text("확인".localized())))
                
            }
            
        }
        
    }
}

struct HandWriting_Write_Previews: PreviewProvider {
    static var previews: some View {
        HandWriting_Write()
    }
}
