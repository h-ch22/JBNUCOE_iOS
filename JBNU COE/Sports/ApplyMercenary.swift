//
//  ApplyMercenary.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/20.
//

import SwiftUI
import FirebaseFirestore

class getMatches:ObservableObject{
    @Published var matches: [Sports] = []
    
    func getMatchList(){
        db = Firestore.firestore()
        db.collection("Sports").getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print(err)
            }
            
            else{
                for document in QuerySnapshot!.documents{
                    print("\(document.documentID) -> \(document.data())")
                    
                    self.getMatchData(name: document.documentID)
                }
            }
        }
    }
    
    func getMatchList(mail: String){
        db = Firestore.firestore()
        
        let docRef = db.collection("Sports")
        let query = docRef.whereField("mail", isEqualTo: mail).getDocuments(){(querySnapshot, err) in
            if let err = err{
                print(err)
            }
            
            else{
                for document in querySnapshot!.documents{
                    self.matches.append(Sports(name: document.documentID,
                                               allPeople: document.get("allPeople") as! Int,
                                               currentPeople: document.get("currentPeople") as! Int,
                                               date: document.get("date") as! String,
                                               event: document.get("event") as! String,
                                               limit: document.get("limit") as! String,
                                               location: document.get("location") as! String,
                                               adminName: document.get("adminName") as! String,
                                               studentNo: document.get("studentNo") as! String,
                                               dept: document.get("dept") as! String,
                                               phone : document.get("phone") as! String))
                    
                    self.matches.sort{
                        $0.date > $1.date
                    }
                }
            }
        }
    }
    
    func getMatchData(name : String){
        let docRef = db.collection("Sports").document(name)
        
        docRef.getDocument(){(document, err) in
            if let document = document{
                self.matches.append(Sports(name: name,
                                           allPeople: document.get("allPeople") as! Int,
                                           currentPeople: document.get("currentPeople") as! Int,
                                           date: document.get("date") as! String,
                                           event: document.get("event") as! String,
                                           limit: document.get("limit") as! String,
                                           location: document.get("location") as! String,
                                           adminName: document.get("adminName") as! String,
                                           studentNo: document.get("studentNo") as! String,
                                           dept: document.get("dept") as! String,
                                           phone : document.get("phone") as! String))
                
                
                self.matches.sort{
                    $0.date > $1.date
                }
            }

        }
        
    }
}

struct ApplyMercenary: View {
    @ObservedObject var getMatches: getMatches
    
    var body: some View {
        List{
            ForEach(getMatches.matches.indices, id: \.self){index in
                NavigationLink(destination : MatchDetail(
                                sports: self.$getMatches.matches[index]
                )){
                    SportsRow(sports: self.$getMatches.matches[index])
                }
            }
        }
        .navigationBarTitle("용병 모집 현황".localized(), displayMode: .large)
        .navigationBarItems(trailing:
            Button(action: {
                getMatches.matches.removeAll()
                getMatches.getMatchList()
            }){
                Image(systemName: "arrow.clockwise")
                                        
            }
        )
        .onAppear(perform: {
            if getMatches.matches.isEmpty{
                getMatches.getMatchList()
            }
        })
            
        .buttonStyle(PlainButtonStyle())
        .listStyle(GroupedListStyle())
        
    }
}

//struct ApplyMercenary_Previews: PreviewProvider {
//    static var previews: some View {
//        ApplyMercenary()
//    }
//}
