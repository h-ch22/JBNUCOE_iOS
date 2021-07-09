//
//  noticeListView.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/11.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct noticeListView: View {
    @ObservedObject var getNotices: getNotices
    @State private var searchText = ""
    @State private var showAlert = false
    
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
                    getNotices.getNotices(){result in
                        
                    }
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
            getNotices.getNotices(){result in
                
            }
        }).buttonStyle(PlainButtonStyle())
        .listStyle(GroupedListStyle())
    }
}

struct noticeListView_Previews: PreviewProvider {
    static var previews: some View {
        noticeListView(getNotices: getNotices())
    }
}
