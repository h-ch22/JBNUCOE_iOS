//
//  allianceListview.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/11.
//

import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI


extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC+9")
        
        dateFormatter.dateFormat = "yyyy-MM-dd kk:mm"
        
        if let date = dateFormatter.date(from: self) { return date } else { return nil }
        
    }
    
}


extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd kk:mm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC+9")
        return dateFormatter.string(from: self)
        
    }
    
}

class getStores: ObservableObject{
    @Published var alliance: [Alliance] = []
    @State var category : String = ""
    @State var engName : String = ""
    var storeList : [String] = []
    @State var allStoreDict : [String : String] = [:]
    @State var isEnable = ""

    func getAllianceList(category : String){
        db = Firestore.firestore()
        alliance.removeAll()
        storeList.removeAll()
        allStoreDict.removeAll()
        var benefitDictionary: Any?
        self.category = category

        let docRef = db.collection("Coalition").document(category)
        docRef.getDocument() { (document, error) in
            if let document = document {
                self.storeList.append(contentsOf: Array(document.data()!.keys))
                print(Array(document.data()!.keys))
                
                for i in 0..<self.storeList.count{
                    let benefit_db = document.data()?[self.storeList[i]] as? String ?? "준비 중입니다."
                    benefitDictionary = document.data()?[self.storeList[i]] as! [String : Any]
                    
                    let s = String(describing: benefitDictionary)
                    let split_Str = s.components(separatedBy: "Optional([\"benefits\":")
                    let final_Str = split_Str[1].components(separatedBy: "])")
                    
                    self.getTime(storeName: self.storeList[i], category: category, benefit: final_Str[0])
                }
                
            } else {
                print("Document does not exist in cache")
                print(category)
            }
        }
        
    }
    
    func getAllAllianceList(){
        alliance.removeAll()
        storeList.removeAll()
        allStoreDict.removeAll()
        var benefitDictionary: Any?
        category = "All"
        db = Firestore.firestore()
        
        db.collection("Coalition").getDocuments(){ (querySnapshot, err) in
            if let err = err{
                print(err)
            }
            
            else{
                for document in querySnapshot!.documents{
                    var storeList : [String] = []
                    
                    self.storeList.append(contentsOf: Array(document.data().keys))
                    
                    print("document key : ", document.data().keys);
                    print(document.documentID , "->", document.data())
                    
                    
                    storeList.append(contentsOf: document.data().keys)
                    
                    for i in 0..<storeList.count{
                        let benefit_db = document.data()[storeList[i]] as? String ?? "준비 중입니다."
                        benefitDictionary = document.data()[storeList[i]] as! [String : Any]
                        
                        let s = String(describing: benefitDictionary)
                        let split_Str = s.components(separatedBy: "Optional([\"benefits\":")
                        let final_Str = split_Str[1].components(separatedBy: "])")
                        
                        self.getTime(storeName: storeList[i], category: document.documentID, benefit: final_Str[0])
                        
                    }
                }
            }
        }
    }
    
    func getTime(storeName : String, category : String, benefit : String){
        
        let docRef = db.collection("location").document(storeName)
        var enable = ""
        
        docRef.getDocument(){document, err in
            if let document = document{
                let openTime = document.get("open") as! String
                let closeTime = document.get("close") as! String
                let brake = document.get("break") as! String
                let closed = document.get("closed") as! String
                
                if openTime != "unknown" && closeTime != "unknown"{
                    enable = openTime + " ~ " + closeTime
                }
                
                else{
                    enable = "알 수 없음"
                }
                
                self.setBenefits(benefit: benefit, category: category, storeName: storeName, isEnable: enable, brake: brake, closed: closed)
            }
            
        }
    }
    
    func setBenefits(benefit: String, category : String, storeName : String, isEnable : String, brake : String, closed : String){
        var benefits = [String : String]()
        
        benefits.updateValue(benefit, forKey: storeName)
        for (key, value) in benefits{
            self.loadimg(storeName: storeName, benefits: benefits, category : category, isEnable: isEnable, brake : brake, closed : closed)
        }
        
    }
    
    func loadimg(storeName : String, benefits : [String : String], category : String, isEnable : String, brake : String, closed : String){
        var urlDict = [String : String]()
        var engDict = [String : String]()
        var strURL : String = ""
        
        var imgurl = URL(string: "")
        var engName = ""
        
        db = Firestore.firestore()
        let docRef = db.collection("Store").document("eng")
        
        docRef.getDocument(){(document, error) in
            if let document = document{
                engName = document.get(storeName) as! String
                engDict.updateValue(engName, forKey : storeName)
                let storageRef = Storage.storage().reference(withPath:"storeLogo/" + engName + ".png")
                
                storageRef.downloadURL{(url, error) in
                    if error != nil{
                        print((error?.localizedDescription))
                        return
                    }
                    
                    imgurl = url!
                    strURL = imgurl!.absoluteString
                    
                    urlDict.updateValue(strURL, forKey: storeName)
                    self.setData(storeName: storeName, category: category, benefits: benefits, engDict: engDict, urlDict: urlDict, isEnable : isEnable, brake : brake, closed : closed)
                    
                }
            }
        }
    }
    
    func setData(storeName : String, category: String, benefits: [String : String], engDict : [String : String], urlDict : [String : String], isEnable : String, brake : String, closed : String){
        self.alliance.append(
            Alliance(storeName: storeName, benefits: benefits[storeName]!, engName: engDict[storeName]!, url: URL(string: urlDict[storeName]!)!, category: category, isEnable: isEnable, brake : brake, closed : closed)
        )
    }
}

struct allianceListView: View {
    @ObservedObject var getStores: getStores
    @Binding var category : String
    @State var storeList : [String] = []
    @State private var imageURL : [URL] = []
    @State private var i : Int = 0
    @State var benefitDict = [String : Any]()
    @State var benefits : [String : String] = [:]
    @State var engName : String = ""
    @Binding var categoryKR : String
    @State var engDict = [String : String]()
    @State var name_selected : String = ""
    @State var benefit_selected : String = ""
    @EnvironmentObject var setInfo : setStoreInfo
    @State private var searching = false
    @State private var searchedList = [Alliance]()
    @State var searchText = ""
    
    var body: some View {
        VStack (alignment:.leading){
            SearchBar(text: $searchText, placeholder: "제휴업체 검색".localized())
            
            List{
                ForEach(getStores.alliance.filter{
                    self.searchText.isEmpty ? true : $0.storeName.lowercased().contains(self.searchText.lowercased())
                }, id: \.self){ index in
                    
                    NavigationLink(destination: storeDetail(alliance: index)){
                        AllianceRow(alliance: index)
                    }
                }
            }
            
        }.navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(categoryKR.localized())
        .navigationBarItems(trailing: NavigationLink(destination: navigateToViewController(benefits: .constant(""), category: $category)
                                                        .navigationBarTitle(Text("지도 보기".localized()))
                                                        .navigationBarTitleDisplayMode(.inline)){
            Image(systemName: "map.fill")
        })
        
        .onAppear(perform: {
            if getStores.storeList.isEmpty{
                if category == "All"{
                    getStores.getAllAllianceList()
                }
                
                else{
                    getStores.getAllianceList(category: category)
                }
            }
            
        })
    }
}

struct navigateToViewController : UIViewControllerRepresentable{
    @Binding var benefits : String
    @Binding var category : String
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "MapView", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "mapViewController")
        
        MapViewController().getAllianceList(category: category)
        
        return viewController
    }
}

struct allianceListView_Previews: PreviewProvider {
    static var previews: some View {
        allianceListView(getStores: getStores(), category: .constant(""), categoryKR : .constant(""))
    }
}
