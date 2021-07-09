//
//  noticeDetail.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/11.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import SDWebImageSwiftUI

struct URLList : Hashable{
    var index : Int
    var url : URL?
}

struct noticeDetail: View {
    let notice : Notice
    @State var date = ""
    @State var contents = ""
    @State var index = ""
    @State var imageURL = URL(string: "")
    @State var url = ""
    @State var lastScaleValue: CGFloat = 1.0
    @State var scale : CGFloat = 1.0
    @State var imageIndex : Int = 0
    @State var items = [URLList]()
    @State var showModal = false
    @State var selectedURL = URL(string: "")
    
    func loadNotice(){
        if contents == ""{
            let docRef = db.collection("Notice").document(notice.title)
            
            docRef.getDocument(){(document, err) in
                if let document = document{
                    date.append(document.get("timeStamp") as! String)
                    contents.append(document.get("contents") as! String)
                    index.append(document.get("index") as! String)
                    url.append(document.get("url") as! String)
                    var read = document.get("read") as! Int
                    
                    if document.get("imageIndex") != nil{
                        let imageIndex = document.get("imageIndex") as! Int
                        loadNoticeImage(index : index, imageIndex: imageIndex)
                    }
                    
                    else{
                        loadNoticeImage(index: index, imageIndex: 1)
                    }
                    
                    docRef.updateData(["read" : read + 1]){
                        err in
                        if let err = err{
                            print(err)
                        }
                    }
                }
            }
        }
    }
    
    func loadNoticeImage(index : String, imageIndex : Int){
        self.imageIndex = imageIndex
        
        if imageIndex > 1{
            for i in 0..<imageIndex{
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let imgRef = storageRef.child("notice/" + index + "/" + String(i) + ".png")
                
                imgRef.downloadURL{(url, error) in
                    if error != nil{
                        print((error?.localizedDescription)!)
                        return
                    }
                    
                    else{
                        items.append(URLList(index: i, url: url!))
                    }
                    
                    items.sort(by : {$0.index < $1.index})
                    
                    print(items , "\n")
                }
            }
        }
        
        if imageIndex == 1{
            let storageRef = Storage.storage().reference(withPath: "notice/" + index + ".png")
            
            storageRef.downloadURL{(url, error) in
                if error != nil{
                    print((error?.localizedDescription)!)
                    return
                }
                
                self.imageURL = url!
                items.append(URLList(index: 0, url: url!))
            }
        }
        
        else{
            
        }
        

    }
    
    var body: some View {
        ScrollView{
            VStack {
                Text(date)
                
                Spacer()
                
                if !items.isEmpty{
                    ScrollView(.horizontal){
                        HStack {
                            ForEach(items.indices, id: \.self){ index in
                                WebImage(url: items[index].url)
                                    .resizable()
                                    .frame(width: 300, height : 300, alignment:.top)
                                    .onTapGesture {
                                        selectedURL = items[index].url
                                        showModal = true
                                    }
                            }
                            
                        }
                    }
                }
                
                Spacer().frame(height : 30)
                
                Text(contents.replacingOccurrences(of: "\\n", with: "\n"))
                
                Spacer()
                
                if(url != ""){
                    Link(destination : URL(string: url)!){
                        HStack{
                            Text("URL 연결하기".localized())
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(20)
                    .frame(width : UIScreen.main.bounds.width / 2)
                    .background(RoundedRectangle(cornerRadius : 16).foregroundColor(.blue))
                    
                }
                
            }.padding(30)
            
        }.navigationBarTitle(notice.title, displayMode: .large)
        .onAppear(perform: {
            loadNotice()
        })
        .sheet(isPresented : self.$showModal){
            SingleImageView(url: $selectedURL)
        }
    }
}

extension String{
    func localized(bundle: Bundle = .main, tableName : String = "Localizable") -> String{
        return NSLocalizedString(self, tableName : tableName, value : "\(self)", comment: "")
    }
}

//struct noticeDetail_Previews: PreviewProvider {
//    @State static var notice = Notice(title: "", date: "", contents: "", read : 0)
//
//    static var previews: some View {
//        noticeDetail(notice: $notice)
//    }
//}
