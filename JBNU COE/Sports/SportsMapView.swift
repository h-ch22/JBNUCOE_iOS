//
//  SportsMapView.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/22.
//

import SwiftUI

struct SportsMapView: View {
    @Binding var showView : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView{
            VStack{
                SportsMapLoader()
            }.navigationBarTitle("지도에서 확인하기".localized()).navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }){
                Text("확인".localized())
            }, trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }){
                Text("닫기".localized())
            })
        }
        
    }
}

struct SportsMapView_Previews: PreviewProvider {
    static var previews: some View {
        SportsMapView(showView: .constant(true))
    }
}
