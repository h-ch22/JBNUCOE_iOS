//
//  CampusMapView.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/21.
//

import SwiftUI
import NMapsMap

struct CampusMapView: View {
    @State var isAllSelected = true
    @State var selectedBuilding = ""
    
    var showInside : some View{
        NavigationLink(destination: CampusInside(building: $selectedBuilding)){Text("실내 지도 보기")}
    }
    
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                HStack {
                    Button(action : {
                        isAllSelected = true
                        selectedBuilding = ""
                    }){
                        Text("전체").foregroundColor(.blue).padding([.horizontal], 15).padding([.vertical], 10)
                    }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.white))
                    
                    Group{
                        Button(action : {
                            isAllSelected = false
                            selectedBuilding = "1st"
                            CampusMapViewController().addMarker(type : "1st")
                            CampusMapViewController().status_fin = "1st"
                        }){
                            Text("1호관").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.red))
                        
                        Button(action : {
                            isAllSelected = false
                            selectedBuilding = "2nd"
                        }){
                            Text("2호관").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.pink))
                        
                        Button(action : {
                            isAllSelected = false
                            selectedBuilding = "3rd"
                        }){
                            Text("3호관").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.orange))
                        
                        Button(action : {
                            isAllSelected = false
                            selectedBuilding = "4th"
                        }){
                            Text("4호관").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.yellow))
                        
                        Button(action : {
                            isAllSelected = false
                            selectedBuilding = "5th"
                        }){
                            Text("5호관").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.green))
                        
                        Button(action : {
                            isAllSelected = false
                            selectedBuilding = "6th"
                        }){
                            Text("6호관").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.blue))
                        
                        Button(action : {
                            isAllSelected = false
                            selectedBuilding = "7th"
                        }){
                            Text("7호관").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.purple))
                        
                        Button(action : {
                            isAllSelected = false
                            selectedBuilding = "8th"
                        }){
                            Text("8호관").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.gray))
                        
                        Button(action : {
                            isAllSelected = false
                            selectedBuilding = "9th"
                        }){
                            Text("9호관").foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.black))
                        
                        Button(action : {
                            isAllSelected = true
                        }){
                            Text("편의").foregroundColor(.black).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.white))
                    }
                }
            }.padding([.horizontal], 10)
            .padding([.vertical], 20)
            
            loadCampusMapView()
        }.navigationBarTitle("캠퍼스맵")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: self.isAllSelected ? AnyView(EmptyView()) :  AnyView(self.showInside))
        .onAppear(perform: {
            CampusMapViewController().addMarker(type : "All")
        })
    }
}

struct CampusMapView_Previews: PreviewProvider {
    static var previews: some View {
        CampusMapView()
    }
}
