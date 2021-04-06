//
//  HandWriting_ListView.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/16.
//

import SwiftUI

class getHandWritingList: ObservableObject{
    @Published var handWriting: [HandWriting] = []
    
    func getHandWriting(){
        handWriting.removeAll()

        db.collection("HandWriting").getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print(err)
            }
            
            else{
                for document in QuerySnapshot!.documents{
                        self.getHandWritingData(name: document.documentID)
                }
            }
        }
    }
    
    func getHandWritingData(name : String){
        let docRef = db.collection("HandWriting").document(name)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                
                if !self.handWriting.contains(where: {($0.title == name)}){
                    self.handWriting.append(
                        HandWriting(docId : name, title: document.get("title") as? String ?? "", author: document.get("author") as? String ?? "", read: document.get("read") as? Int ?? 0, recommend: document.get("recommend") as? Int ?? 0, dateTime: document.get("Date Time") as? String ?? "")
                    )
                }
                
                self.handWriting.sort{
                    $0.dateTime > $1.dateTime
                }
            }
        }
    }
    
    func sortByDate(){
        self.handWriting.sort{
            $0.dateTime > $1.dateTime
        }
    }
    
    func sortByRecommend(){
        self.handWriting.sort{
            $0.recommend > $1.recommend
        }
    }
    
    func sortByRead(){
        self.handWriting.sort{
            $0.read > $1.read
        }
    }
}

struct HandWriting_ListView: View {
    @ObservedObject var getHandWritingList: getHandWritingList
    @State var showSheet = false
    @State var showModal = false
    @State var searchText = ""
    var body: some View {
        VStack{
            SearchBar(text: $searchText, placeholder: "합격자 수기 검색".localized())
            
            List{
                ForEach(getHandWritingList.handWriting.filter{
                    self.searchText.isEmpty ? true : $0.title.lowercased().contains(self.searchText.lowercased())
                }, id: \.self){ index in
                    
                    NavigationLink(destination : HandWritingDetails(handWriting: index)){
                        HandWritingRow(handWriting : index)
                    }
                }
            }
            
        }.navigationBarTitle("합격자 수기 공유".localized()).navigationBarTitleDisplayMode(.large)
        .onAppear(perform: {
            getHandWritingList.getHandWriting()
        })
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                HStack{
                    Button(action : {
                            getHandWritingList.getHandWriting()})
                    {
                        Image(systemName: "arrow.clockwise")
                    }
                                        
                    Button(action : {showSheet = true}){
                        Image(systemName: "text.aligncenter").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                    
                    Button(action: {showModal = true}){
                        Image(systemName: "plus")
                            .foregroundColor(.red)
                    }
                }
                
            }
        }
        .actionSheet(isPresented : $showSheet){
            ActionSheet(title : Text("정렬 방식 선택".localized()),
                        message : Text("원하시는 정렬 방식을 선택하십시오.\n(기본값 : 최신순)".localized()),
                        buttons: [.default(Text("최신순".localized()), action:{getHandWritingList.sortByDate()}), .default(Text("추천순".localized()), action: {getHandWritingList.sortByRecommend()}), .default(Text("조회순".localized()), action : {getHandWritingList.sortByRead()}),.cancel(Text("취소".localized()).foregroundColor(.red))])
        }
        
        .sheet(isPresented : self.$showModal){
            HandWriting_Write()
        }
    }
}
