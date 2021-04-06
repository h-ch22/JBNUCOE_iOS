//
//  HandWritingDetails.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/17.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI
import FirebaseAuth

class RecommendChecker: ObservableObject{
    @Published var recommend : Int = 0
}

struct HandWritingDetails: View {
    let handWriting : HandWriting
    @State var date = ""
    @State var examName = ""
    @State var examDate = ""
    @State var howTO = ""
    @State var meter = ""
    @State var review = ""
    @State var term = ""
    @State var index = 0
    @State var items = [URL(string: "")]
    @State var read = 0
    @ObservedObject var recommend = RecommendChecker()
    @State var mail = ""
    @State var id = ""
    @State var isAdmin : Bool = false
    @State var showAlert : Bool = false
    @State var alertType : alert = .delete
    @EnvironmentObject var userManagement : UserManagement
    @State var isHidden = true
    @State var isAuthor = false
    @State var showModal = false
    @State var selectedURL = URL(string: "")
    @State var title = ""
    @State var docId = ""
    
    enum alert{
        case delete, deleteSuccess, deleteFail, recommend, recommendSuccess, recommendFail
    }
    
    func loadData(){
        if date == "" || date == nil || examName == "" || howTO == "" || meter == "" || review == "" || term == "" || examDate == "" || mail == "" || mail == nil || id == "" || id == nil{
            let auth_mail = Auth.auth().currentUser?.email
            let docRef = db.collection("HandWriting").document(handWriting.docId)
            let readRef = docRef.collection("read").document(auth_mail!)
            
            docRef.getDocument(){(document, err) in
                if let document = document{
                    date.append(document.get("Date Time") as! String)
                    examDate.append(document.get("examDate") as! String)
                    examName.append(document.get("examName") as! String)
                    howTO.append(document.get("howTO") as! String)
                    meter.append(document.get("meter") as! String)
                    review.append(document.get("review") as! String)
                    term.append(document.get("term") as! String)
                    mail.append(document.get("mail") as! String)
                    id.append(document.get("id") as! String)
                    read = document.get("read") as! Int
                    recommend.recommend = document.get("recommend") as! Int
                    loadImage(index: document.get("imageIndex") as! Int)
                    
                    readRef.getDocument(){(document, err) in
                        if let document = document, document.exists{
                            return
                        }
                        
                        else{
                            docRef.updateData(["read" : read + 1]){
                                err in
                                if let err = err{
                                    print(err)
                                }
                            }
                            
                            readRef.setData(["read" : "true"])
                            
                            docRef.getDocument(){(document, err) in
                                if let document = document{
                                    read = document.get("read") as! Int
                                }
                                
                                else{
                                    print(err)
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func getRecommend(){
        let docRef = db.collection("HandWriting").document(handWriting.docId)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                recommend.recommend = document.get("recommend") as! Int
            }
        }
    }
    
    func doRecommend(){
        let auth_mail = Auth.auth().currentUser?.email
        let docRef = db.collection("HandWriting").document(handWriting.docId)
        let recommendRef = db.collection("HandWriting").document(handWriting.docId).collection("recommend").document(auth_mail!)
        
        recommendRef.getDocument(){(document, err) in
            if let document = document, document.exists{
                alertType = .recommendFail
                showAlert = true
            }
            
            else{
                getRecommend()
                
                docRef.updateData(["recommend" : recommend.recommend + 1]){err in
                    if let err = err{
                        print(err)
                        alertType = .recommendFail
                        showAlert = true
                    }
                    
                    else{
                        recommendRef.setData(["recommend" : "true"])
                        
                        docRef.getDocument(){(document, err) in
                            if let document = document{
                                recommend.recommend = document.get("recommend") as! Int
                                alertType = .recommendSuccess
                                showAlert = true
                            }
                            
                            else{
                                print(err)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkAdmin(){
        let mail = Auth.auth().currentUser?.email
        
        let docRef = db.collection("HandWriting").document(handWriting.docId)
        
        if userManagement.isAdmin{
            isAdmin = true
        }
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                let authorMail = document.get("mail") as! String
                
                if authorMail == mail{
                    isAuthor = true
                }
                
                else{
                    isAuthor = false
                }
            }
        }
        
    }
    
    func delete(){
        isHidden = false
        
        let docRef = db.collection("HandWriting").document(handWriting.docId)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                let readRef = docRef.collection("read")
                
                readRef.getDocuments(){(querySnapshot, err) in
                    if let err = err{
                        isHidden = true
                        alertType = .deleteFail
                        showAlert = true
                        print(err)
                    }
                    
                    else{
                        for document in querySnapshot!.documents{
                            var readerRef = readRef.document(document.documentID)
                            readerRef.delete()
                        }
                        
                        let recommendRef = docRef.collection("recommend")
                        
                        recommendRef.getDocuments(){(querySnapshot, err) in
                            if let err = err{
                                isHidden = true
                                alertType = .deleteFail
                                showAlert = true
                                print(err)
                            }
                            
                            else{
                                for document in querySnapshot!.documents{
                                    var recommenderRef = recommendRef.document(document.documentID)
                                    recommenderRef.delete()
                                }
                                
                                for i in 0..<items.count{
                                    let storageRef = Storage.storage().reference(withPath:"handWriting/" + (Auth.auth().currentUser?.email)! + "_" + id + "/" + String(i) + ".png")
                                    storageRef.delete{err in
                                        if let err = err{
                                            print(err)
                                        }
                                        
                                        else{
                                            
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                    }
                }
                
                docRef.delete()
                
                isHidden = true
                alertType = .deleteSuccess
                showAlert = true
            }
            
            else{
                isHidden = true
                alertType = .deleteFail
                showAlert = true
            }
        }
    }
    
    func loadImage(index : Int){
        self.index = index
        for i in 0..<index{
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imgRef = storageRef.child("handWriting/" + mail + "_" + id + "/" + String(i) + ".png")
            
            imgRef.downloadURL{(url, error) in
                if error != nil{
                    print((error?.localizedDescription)!)
                    return
                }
                
                items.append(url!)
                print(items)
            }
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text(handWriting.author)
                    Spacer()
                    Text(handWriting.dateTime)
                }
                
                HStack{
                    HStack{
                        Image(systemName: "eye").resizable().frame(width : 25, height : 20).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        Text(String(handWriting.read)).foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    HStack{
                        Image(systemName: "hand.thumbsup").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                        Text("\(recommend.recommend)").foregroundColor(.red)
                    }
                }
                
                ScrollView(.horizontal){
                    HStack {
                        ForEach(1..<items.count, id: \.self){ index in
                            WebImage(url: self.items[index])
                                .resizable()
                                .frame(width: 300, height : 300, alignment:.top)
                                .onTapGesture {
                                    selectedURL = items[index]
                                    showModal = true
                                }
                        }
                    }
                }
                
                Spacer()
                
                Group{
                    VStack{
                        Text("✏️ 시험 이름")
                            .fontWeight(.semibold)
                        
                        Divider()
                        
                        Text(examName)
                    }                      .padding(15)
.background(RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.gray).opacity(0.2))
                    
                    Spacer()
                    
                    VStack{
                        Text("🗓 시험 날짜")
                            .fontWeight(.semibold)
                        
                        Divider()
                        
                        Text(examDate)
                    }                      .padding(15)
.background(RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.gray).opacity(0.2))
                    
                    Spacer()
                    
                    VStack{
                        Text("💭 시험을 준비하게 된 계기")
                            .fontWeight(.semibold)
                        
                        Divider()
                        
                        Text(meter)
                    }                      .padding(15)
.background(RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.gray).opacity(0.2))
                    
                    Spacer()
                    
                    VStack{
                        Text("⏰ 시험 준비 기간")
                            .fontWeight(.semibold)
                        
                        Divider()
                        
                        Text(term)
                    }                      .padding(15)
.background(RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.gray).opacity(0.2))
                    
                    Spacer()
                    
                    VStack{
                        Text("🙋🏻‍♀️ 시험을 본 후기")
                            .fontWeight(.semibold)
                        
                        Divider()
                        
                        Text(review)
                    } .padding(15).background(RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.gray).opacity(0.2))
                    
                }

                Spacer()
                
                VStack{
                    Text("📚 자신만의 공부법")
                        .fontWeight(.semibold)
                    
                    Divider()
                    
                    Text(howTO)
                }                  .padding(15)
.background(RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.gray).opacity(0.2))
                
            }.padding()
            .navigationBarTitle(handWriting.title)
            .navigationBarTitleDisplayMode(.large)
            
            .onAppear(perform: {
                title = handWriting.title
                docId = handWriting.docId
                userManagement.getEmail()
                checkAdmin()
                loadData()
            })
            
            .sheet(isPresented : self.$showModal){
                SingleImageView(url: $selectedURL)
            }
            
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Text("")
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    HStack{
                        if !isAuthor{
                            Button(action : {
                                alertType = .recommend
                                showAlert = true
                            })
                            {
                                Image(systemName: "hand.thumbsup").foregroundColor(.red)
                            }
                        }

                        if isAuthor{
                            NavigationLink(destination : HandWritingEdit(examName: $title, meter: $examName, term: $meter, review: $term, howTO: $review, title: $howTO, id: $docId)){
                                Image(systemName: "pencil").foregroundColor(.blue)
                            }
                        }
                        
                        if isAdmin || isAuthor{
                            Button(action : {
                                alertType = .delete
                                showAlert = true
                            }){
                                Image(systemName: "trash").foregroundColor(.red)
                            }
                        }
                        
                    }
                    
                }

            }
            
            .alert(isPresented: $showAlert){
                switch alertType{
                case .recommend:
                    return Alert(title: Text("추천 확인".localized()), message: Text("이 글을 추천하시겠습니까?".localized()), primaryButton: .destructive(Text("예".localized())){
                        doRecommend()
                    }, secondaryButton: .destructive(Text("아니오".localized())))
                    
                case .recommendSuccess:
                    return Alert(title : Text("처리 완료".localized()), message: Text("정상 처리되었습니다.".localized()), dismissButton: .default(Text("확인".localized())){
                        getRecommend()
                    })
                    
                case .recommendFail:
                    return Alert(title : Text("오류".localized()), message: Text("이미 추천한 글이거나, 네트워크 상태가 불안정합니다.".localized()), dismissButton: .default(Text("확인".localized())))
                    
                case .delete:
                    return Alert(title: Text("제거 확인".localized()), message: Text("제거 시 복구할 수 없습니다.\n계속하시겠습니까?".localized()), primaryButton: .destructive(Text("예".localized())){
                        delete()
                    }, secondaryButton: .destructive(Text("아니오".localized())))
                    
                case .deleteSuccess:
                    return Alert(title : Text("처리 완료".localized()), message: Text("정상 처리되었습니다.".localized()), dismissButton: .default(Text("확인".localized())){
                        
                    })
                    
                case .deleteFail:
                    return Alert(title : Text("오류".localized()), message: Text("제거 중 문제가 발생하였습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오.".localized()), dismissButton: .default(Text("확인".localized())))
                }
                
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
//
//struct HandWritingDetail_Previews: PreviewProvider {
//    @State static var handWriting = HandWriting(title: "sss", author: "sss", read: 0, recommend: 0, dateTime: "sss")
//    static var previews: some View {
//        HandWritingDetails(handWriting: handWriting)
//    }
//}
