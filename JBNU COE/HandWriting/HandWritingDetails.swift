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

struct HandWritingDetails: View {
    @Binding var handWriting : HandWriting
    @State var date = ""
    @State var contents = ""
    @State var index = 0
    @State var items = [URL(string: "")]
    @State var read = 0
    @State var recommend = 0
    @State var mail = ""
    @State var id = ""
    @State var isAdmin : Bool = false
    @State var showAlert : Bool = false
    @State var alertType : alert = .delete
    @EnvironmentObject var userManagement : UserManagement
    @State var isHidden = true
    @State var isAuthor = false
    
    enum alert{
        case delete, deleteSuccess, deleteFail, recommend, recommendSuccess, recommendFail
    }
    
    func loadData(){
        if date == "" || date == nil || contents == "" || contents == nil || mail == "" || mail == nil || id == "" || id == nil{
            let auth_mail = Auth.auth().currentUser?.email
            let docRef = db.collection("HandWriting").document(handWriting.title)
            let readRef = docRef.collection("read").document(auth_mail!)
            
            docRef.getDocument(){(document, err) in
                if let document = document{
                    date.append(document.get("Date Time") as! String)
                    contents.append(document.get("contents") as! String)
                    mail.append(document.get("mail") as! String)
                    id.append(document.get("id") as! String)
                    read = document.get("read") as! Int
                    recommend = document.get("recommend") as! Int
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
    
    func doRecommend(){
        let auth_mail = Auth.auth().currentUser?.email
        let docRef = db.collection("HandWriting").document(handWriting.title)
        let recommendRef = db.collection("HandWriting").document(handWriting.title).collection("recommend").document(auth_mail!)
        
        recommendRef.getDocument(){(document, err) in
            if let document = document, document.exists{
                alertType = .recommendFail
                showAlert = true
            }
            
            else{
                docRef.updateData(["recommend" : recommend + 1]){err in
                    if let err = err{
                        print(err)
                        alertType = .recommendFail
                        showAlert = true
                    }
                    
                    else{
                        recommendRef.setData(["recommend" : "true"])
                        
                        docRef.getDocument(){(document, err) in
                            if let document = document{
                                recommend = document.get("recommend") as! Int
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
        
        let docRef = db.collection("HandWriting").document(handWriting.title)
        
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
        
        let docRef = db.collection("HandWriting").document(handWriting.title)
        
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
    
    func edit(){
        
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
                        Text(String(handWriting.recommend)).foregroundColor(.red)
                    }
                }
                
                ScrollView(.horizontal){
                    HStack {
                        ForEach(1..<items.count, id: \.self){
                            WebImage(url: self.items[$0])
                                .resizable()
                                .frame(width: 300, height : 300, alignment:.top)
                        }
                    }
                }
                
                Spacer()
                
                Text(contents)
                    .multilineTextAlignment(.leading)
                
            }.padding()
            .navigationBarTitle(handWriting.title)
            .navigationBarTitleDisplayMode(.large)
            
            .onAppear(perform: {
                userManagement.getEmail()
                checkAdmin()
                loadData()
            })
            
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
                            NavigationLink(destination : HandWritingEdit(title: $handWriting.title, contents: $contents)){
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
                    return Alert(title : Text("처리 완료".localized()), message: Text("정상 처리되었습니다.".localized()), dismissButton: .default(Text("확인".localized())))
                    
                case .recommendFail:
                    return Alert(title : Text("오류".localized()), message: Text("이미 추천한 글이거나, 네트워크 상태가 불안정합니다.".localized()), dismissButton: .default(Text("확인".localized())))
                    
                case .delete:
                    return Alert(title: Text("제거 확인".localized()), message: Text("제거 시 복구할 수 없습니다.\n계속하시겠습니까?".localized()), primaryButton: .destructive(Text("예".localized())){
                        delete()
                    }, secondaryButton: .destructive(Text("아니오".localized())))
                    
                case .deleteSuccess:
                    return Alert(title : Text("처리 완료".localized()), message: Text("정상 처리되었습니다.".localized()), dismissButton: .default(Text("확인".localized())))
                    
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
