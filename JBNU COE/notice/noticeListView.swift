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
    @State private var searchText = ""
    
    var body: some View {
        NavigationView{
            VStack{
                SearchBar(text: $searchText, placeholder: "공지사항 검색".localized())
                
                List{
                    ForEach(getNotices.notices.filter{
                        self.searchText.isEmpty ? true : $0.title.lowercased().contains(self.searchText.lowercased())
                    }, id: \.self){ index in
                        
                        NavigationLink(destination : noticeDetail(notice : index)){
                            NoticeRow(notice : index)
                        }
                    }
                }
            
                
            }.navigationBarTitle("공지사항".localized(), displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: {
                    getNotices.notices.removeAll()
                    getNotices.getNotices()
                }){
                    Image(systemName: "arrow.clockwise")
                                            
                }
            )
            
            VStack {
                Text("선택된 카테고리 없음".localized())
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                
                Text("계속 하려면 화면 좌측의 버튼을 터치해 카테고리를 선택하십시오.".localized())
                    .foregroundColor(.gray)
            }
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
