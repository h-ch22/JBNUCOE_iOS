//
//  showMyRoom.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/30.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Firebase

class getAppliedMatches : ObservableObject{
    @Published var appliedMatches: [Sports] = []
    @EnvironmentObject var userManagement : UserManagement
    
    func getAppliedList(){
        db = Firestore.firestore()
        
        let docRef = db.collection("Sports")
        
        docRef.getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print(err)
            }
            
            else{
                for document in QuerySnapshot!.documents{
                    print("\(document.documentID) -> \(document.data())")
                    
                    let applyRef = docRef.document(document.documentID)
                        .collection("applies").getDocuments(){(QuerySnapshot, err) in
                            if let err = err{
                                print(err)
                            }
                            
                            else{
                                for appliedDocument in QuerySnapshot!.documents{
                                    print(appliedDocument.documentID)
                                    
                                    if appliedDocument.documentID == Auth.auth().currentUser?.email as! String{
                                        self.appliedMatches.append(Sports(name: document.documentID,
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
                                        
                                        self.appliedMatches.sort{
                                            $0.date > $1.date
                                        }
                                    }
                                }
                            }
                        }
                }
            }
        }
    }
}

struct showMyRoom: View {
    @ObservedObject var getMatches: getMatches
    @EnvironmentObject var userManagement : UserManagement
    @ObservedObject var getApplied : getAppliedMatches
    
    var body: some View {
        Form{
            Section(header : Text("관리 중인 방".localized())){
                List(getMatches.matches.indices, id: \.self){ index in
                        NavigationLink(destination : myRoomDetails(sports: self.$getMatches.matches[index], getApplies: getApplies())){
                            SportsRow(sports: self.$getMatches.matches[index])
                        }
                }
            }
            
            Section(header : Text("지원한 방".localized())){
                List(getApplied.appliedMatches.indices, id: \.self){index in
                        NavigationLink(destination : myRoomDetails(sports: self.$getApplied.appliedMatches[index], getApplies: getApplies())){
                            SportsRow(sports: self.$getApplied.appliedMatches[index])
                        }
                }
            }
        }
        
        .navigationBarTitle("지원한 방 보기".localized())
        .navigationBarTitleDisplayMode(.large)
        
        .navigationBarItems(trailing:
                                Button(action: {
                                    getApplied.appliedMatches.removeAll()
                                    getMatches.matches.removeAll()
                                    getMatches.getMatchList(mail: userManagement.mail)
                                    getApplied.getAppliedList()
                                }){
                                    Image(systemName: "arrow.clockwise")
                                    
                                }
        )
        .onAppear(perform: {
            if getMatches.matches.isEmpty{
                getMatches.getMatchList(mail: userManagement.mail)
            }
            
            if getApplied.appliedMatches.isEmpty{
                getApplied.getAppliedList()
            }
        })

        .buttonStyle(PlainButtonStyle())
        .listStyle(GroupedListStyle())
    }
}


//struct showMyRoom_Previews: PreviewProvider {
//    static var previews: some View {
//        showMyRoom()
//    }
//}
