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

struct noticeDetail: View {
    @Binding var notice : Notice
    @State var date = ""
    @State var contents = ""
    @State var index = ""
    @State var imageURL = URL(string: "")
    @State var url = ""
    @State var lastScaleValue: CGFloat = 1.0
    @State var scale : CGFloat = 1.0
    
    func updateData(){
        let docRef = db.collection("Notice").document(notice.title)
        
    }
    
    func loadNotice(){
        let docRef = db.collection("Notice").document(notice.title)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                date.append(document.get("timeStamp") as! String)
                contents.append(document.get("contents") as! String)
                index.append(document.get("index") as! String)
                url.append(document.get("url") as! String)
                var read = document.get("read") as! Int
                
                loadNoticeImage(index : index)
                
                docRef.updateData(["read" : read + 1]){
                    err in
                    if let err = err{
                        print(err)
                    }
                }
            }
        }
            
    }
    
    func loadNoticeImage(index : String){
        let storageRef = Storage.storage().reference(withPath: "notice/" + index + ".png")
        
        storageRef.downloadURL{(url, error) in
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
            
            self.imageURL = url!
            print(self.imageURL)
        }
    }
    
    var body: some View {
            ScrollView{
                VStack {
                    Text(date)
                    
                    Spacer()
                    
                    WebImage(url: imageURL)
                        .resizable()
                        .frame(width: 300, height : 300, alignment:.top)
                        .gesture(MagnificationGesture()
                            .onChanged { value in
                                self.scale = value.magnitude
                        }
                            .onEnded{value in
                                self.scale = 1.0
                        })
                    
                    Spacer().frame(height : 30)
                    
                    Text(contents.replacingOccurrences(of: "\\n", with: "\n"))
                    
                    Spacer()
                    
                    if(url != ""){
                        Link(destination : URL(string: url)!){
                            HStack{
                                Text("URL 연결하기")
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
    }
}

struct noticeDetail_Previews: PreviewProvider {
    @State static var notice = Notice(title: "", date: "", contents: "", read : 0)

    static var previews: some View {
        noticeDetail(notice: $notice)
    }
}
