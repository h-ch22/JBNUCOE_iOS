//
//  noticeListView.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/11.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

class getNotices: ObservableObject{
    @Published var notices: [Notice] = []
    
    func getNotices(){
        db.collection("Notice").getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print(err)
            }
            
            else{
                
                for document in QuerySnapshot!.documents{
                        self.getNoticeData(name: document.documentID)
                }
            }
        }
    }
    
    func getNoticeData(name : String){
        let docRef = db.collection("Notice").document(name)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                
                if !self.notices.contains(where: {($0.title == name)}){
                    self.notices.append(
                        Notice(title: name, date: document.get("timeStamp") as? String ?? "", contents: document.get("contents") as? String ?? "", read: document.get("read") as? Int ?? 0)
                    )
                }
                
                self.notices.sort{
                    $0.date > $1.date
                }
            }
        }
        
    }
}

struct noticeListView: View {
    @ObservedObject var getNotices: getNotices
    
    var body: some View {
        NavigationView{
            List(getNotices.notices.indices, id: \.self){ index in
                NavigationLink(destination: noticeDetail(notice: self.$getNotices.notices[index])){
                    NoticeRow(notice: self.$getNotices.notices[index])
                }
                
            }.navigationBarTitle("공지사항", displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: {
                    getNotices.notices.removeAll()
                    getNotices.getNotices()
                }){
                    Image(systemName: "arrow.clockwise")
                                            
                }
            )
        }
        .onAppear(perform: {
            getNotices.getNotices()
        }).buttonStyle(PlainButtonStyle())
        .listStyle(GroupedListStyle())
    }
}

struct noticeListView_Previews: PreviewProvider {
    static var previews: some View {
        noticeListView(getNotices: getNotices())
    }
}
