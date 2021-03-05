//
//  storeDetailUI.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/12.
//

import SwiftUI
import MapKit
import FirebaseFirestore

struct storeDetailUI: View {
    @Binding var storeName : String
    @Binding var benefitName : String
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    VStack {
                        Text(storeName)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(benefitName)
                            .multilineTextAlignment(.center)
                    }.padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.yellow, lineWidth: 3)
                    )
                    
                    VStack {
                        Text("대표 메뉴")
                            .font(.title)
                            .fontWeight(.bold)
                    }.padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.yellow, lineWidth: 3)
                    )
                    
                    
                }
            }
        }.navigationBarTitle(storeName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            db = Firestore.firestore()
        })
    }
}

struct storeDetailUI_Previews: PreviewProvider {
    static var previews: some View {
        storeDetailUI(storeName: .constant(""), benefitName: .constant(""))
    }
}
