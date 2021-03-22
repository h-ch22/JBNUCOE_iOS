//
//  storeDetail.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/13.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI
import FirebaseAuth
import CoreLocation
import Combine

struct storeDetail: View {
    @Binding var alliance : Alliance
    @State var engName : String = ""
    @State private var imageURL = URL(string: "")
    @State var phone = ""
    @State var menu = ""
    @State var price = ""
    @State private var menuImg = URL(string: "")
    
    func loadimg(engName : String){
        let storageRef = Storage.storage().reference(withPath:"storeLogo/" + alliance.engName + ".png")
        
        storageRef.downloadURL{(url, error) in
            if error != nil{
                print((error?.localizedDescription))
                return
            }
            
            self.imageURL = url!
            print(imageURL)
        }
    }
    
    func getPhone(){
        let phoneRef = db.collection("location").document(alliance.storeName)

        phoneRef.getDocument(){(document, err) in
            if let document = document{
                let phone_str = document.get("tel") as! String
                
                phone.append(phone_str)
            }
        }
    }
    
    func loadMenu(){
        menu = ""
        price = ""
        
        db = Firestore.firestore()
        let docRef = db.collection("location").document(storeName)
        docRef.getDocument(){document, err in
            if let document = document{
                let menu = document.get("menu") as! String
                let price = document.get("price") as! String
                
                self.menu.append(menu)
                self.price.append(price)
                
                loadMenuImg()
            }
        }
    }
    
    func loadMenuImg(){
        let storageRef = Storage.storage().reference(withPath:"menu/" + alliance.engName + ".jpg")
        
        storageRef.downloadURL{(url, error) in
            if error != nil{
                print((error?.localizedDescription))
                return
            }
            
            self.menuImg = url!
        }
    }
    
    @State var storeName : String = ""
    @State var benefit: String  = ""
    
    var body: some View {
        ScrollView{
            VStack(alignment:.center){
                VStack(alignment: .center) {
                    HStack {
                        WebImage(url: imageURL)
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .leading)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                            .padding(10)
                        
                        VStack(alignment:.leading){
                            Spacer().frame(height : 30)
                            
                            Text(alliance.storeName)
                                .font(.title)
                                .fontWeight(.bold)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(alliance.benefits)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer().frame(height : 30)
                            
                        }
                        
                    }
                    
                    Divider()

                    HStack(alignment : .center){
                        Button(action: {
                            let numberString = "tel://" + phone
                            let numberURL = URL(string: numberString)
                            UIApplication.shared.openURL(numberURL!)
                        }){
                            HStack{
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.blue)
                                
                                Text("전화하기".localized())
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Spacer().frame(width : 30)

                        HStack{
                            NavigationLink(destination : loadMap(storeName: $storeName, benefits: $benefit)){
                                HStack{
                                    Image(systemName : "map.fill")
                                        .foregroundColor(.blue)
                                    
                                    Text("지도 보기".localized())
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                                                
                    }.padding(5)
                }.frame(width : 350, height : 250)
                .background(RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.gray).opacity(0.2))
                .padding(15)
                
                VStack(alignment:.center){
                    Spacer()
                    
                    Text("대표 메뉴".localized())
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Divider()
                    
                    Spacer()
                    
                    HStack{
                        WebImage(url: menuImg)
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .leading)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                            .padding(10)
                        
                        VStack(alignment:.leading){
                            Text(menu)
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            Text(price)
                        }
                    }
                }.padding(15)
                .frame(width : 350, height : 300)
                .background(RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.blue).opacity(0.2))
                
                
                Spacer()
                
            }
            
            
            
        }.navigationBarTitle(alliance.storeName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            loadimg(engName: alliance.engName)
            getPhone()
            storeName = alliance.storeName
            benefit = alliance.benefits
            loadMenu()
        })
//        .onDisappear(perform: {
//            menu = ""
//            price = ""
//        })
        
    }
}

struct loadMap : UIViewControllerRepresentable{
    @Binding var storeName : String
    @Binding var benefits : String
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "MapView", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "mapViewController")
        
        MapViewController().setMarker(storeName: storeName, benefits: benefits)
        
        return viewController
    }
}

struct storeDetail_Previews: PreviewProvider {
    @State static var alliance = Alliance(storeName: "", benefits: "", engName: "", url: URL(string: "")!, category: "", isEnable: "", brake : "", closed : "")

    static var previews: some View {
        storeDetail(alliance: $alliance)
    }
}
