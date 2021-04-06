//
//  Home_Phone.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/11.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct Home_Phone: View {
    @State var search : String = ""
    @State var category : String = ""
    @State var categoryKR : String = ""
    @State private var selectedPage = 0
    @State var timeRemaining = 2
    @ObservedObject var getStores: getStores

    var timer = Timer.publish(every:1, on: .current, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack {
                    ZStack(alignment : .topTrailing) {
                        TabView(selection: $selectedPage){
                            Ad_1().tag(0)
                            Ad_2().tag(1)
                            Ad_3().tag(2)
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                        .onReceive(timer){input in
                            if timeRemaining > 0{
                                timeRemaining -= 1
                            }
                            
                            else{
                                timeRemaining = 2
                                if selectedPage < 2 {
                                    withAnimation{
                                        selectedPage += 1
                                    }
                                    
                                }
                                
                                else{
                                    withAnimation{
                                        selectedPage = 0
                                    }
                                    
                                }
                            }
                            
                        }
                        
                        NavigationLink(destination: AdDetailLoader(selected: $selectedPage)) {
                            HStack{
                                Image(systemName: "chevron.right").foregroundColor(.white)
                            }.padding([.horizontal], 60).padding([.vertical], 15)
                        }.background(Circle().foregroundColor(.white).opacity(0.5)).padding(5)
                    }
                
                    Spacer()
                    
                    Text("원하시는 카테고리를 선택해보세요!".localized())
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)) {
                            VStack{
                                Image("ic_all")
                                    .resizable()
                                    .frame(width : 100, height: 100)
                                Text("전체 보기".localized()).foregroundColor(.gray)
                            }
                        }.simultaneousGesture(TapGesture().onEnded{
                            category = "All"
                            categoryKR = "전체 보기"
                        })
                        
                        
                        NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)) {
                            VStack{
                                Image("ic_meal")
                                    .resizable()
                                    .frame(width : 100, height: 100)
                                Text("식사".localized()).foregroundColor(.gray)
                            }
                        }.simultaneousGesture(TapGesture().onEnded{
                            category = "Meal"
                            categoryKR = "식사"
                        })
                        
                        
                        NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)) {
                            VStack{
                                Image("ic_sports")
                                    .resizable()
                                    .frame(width : 100, height: 100)
                                Text("스포츠".localized()).foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        
                    }.simultaneousGesture(TapGesture().onEnded{
                        category = "Sports"
                        categoryKR = "스포츠"
                    })
                    Spacer()
                    
                    Divider()
                    
                    Spacer()
                    
                    Group{
                        HStack {
                            Spacer()
                            
                            NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)) {
                                VStack{
                                    Image("ic_cafe")
                                        .resizable()
                                        .frame(width : 100, height: 100)
                                    Text("카페".localized()).foregroundColor(.gray)
                                }
                            }.simultaneousGesture(TapGesture().onEnded{
                                category = "Cafe"
                                categoryKR = "카페"
                            })
                            
                            
                            NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)) {
                                VStack{
                                    Image("ic_convenience")
                                        .resizable()
                                        .frame(width : 100, height: 100)
                                    Text("편의".localized()).foregroundColor(.gray)
                                }
                            }.simultaneousGesture(TapGesture().onEnded{
                                category = "Convenience"
                                categoryKR = "편의"
                            })
                            
                            
                            NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category:
                                                                            $category, categoryKR: $categoryKR)) {
                                VStack{
                                    Image("ic_alcohol")
                                        .resizable()
                                        .frame(width : 100, height: 100)
                                    Text("술".localized()).foregroundColor(.gray)
                                }
                            }.simultaneousGesture(TapGesture().onEnded{
                                category = "Alcohol"
                                categoryKR = "술"
                            })
                            Spacer()
                            
                            
                        }
                        
                        Spacer()
                        
                    }
                }.navigationBarTitle("제휴 업체".localized(), displayMode: .large)
                .navigationBarBackButtonHidden(true)
                .onDisappear(perform: {
                    withAnimation{
                        selectedPage = 0
                    }
                    
                    
                })
                
                .onAppear(perform: {
                    withAnimation{
                        selectedPage = 0
                    }
                })
            }
            
            VStack {
                Text("선택된 카테고리 없음".localized())
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                
                Text("계속 하려면 화면 좌측의 버튼을 터치해 카테고리를 선택하십시오.".localized())
                    .foregroundColor(.gray)
            }
        }.onAppear(perform: {
            getStores.alliance.removeAll()
        })
        
        
    }
}

//struct Home_Phone_Previews: PreviewProvider {
//    static var previews: some View {
//        Home_Phone()
//    }
//}
