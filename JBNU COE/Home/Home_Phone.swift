//
//  Home_Phone.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/11.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

extension Color{
    static let background_home = Color("bg_alliance")
    static let background_button = Color("bg_button")
    static let txtcolor = Color("color_txt")
}

enum time{
    case morning, lunch, afternoon, dinner, night, none
}

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
                ZStack{
                    Color.background_home.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
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
                                }.padding([.horizontal], 20).padding([.vertical], 40)
                            }.background(Circle().foregroundColor(.white).opacity(0.5)).padding(5).padding([.horizontal], 40)
                        }.frame(height : 250)
                        
                        Spacer()
                        
                        Text("원하시는 카테고리를 선택해보세요!".localized()).foregroundColor(.purple)
                        
                        Spacer().frame(height : 50)
                        
                            HStack{
                                Group{
                                    NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)) {
                                        VStack{
                                            Image("ic_all")
                                                .resizable()
                                                .frame(width : 50, height: 50)
                                            
                                            Text("전체 보기".localized()).foregroundColor(.purple)
                                        }.frame(width: 70, height: 70)
                                        .padding()
                                        .background(Color.background_button)
                                        .cornerRadius(5)
                                    }.simultaneousGesture(TapGesture().onEnded{
                                        category = "All"
                                        categoryKR = "전체 보기"
                                    })
                                    
                                    NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)) {
                                        VStack{
                                            Image("ic_meal")
                                                .resizable()
                                                .frame(width : 50, height: 50)
                                            
                                            Text("식사".localized()).foregroundColor(.purple)
                                        }.frame(width: 70, height: 70)
                                        .padding()
                                        .background(Color.background_button)
                                        .cornerRadius(5)
                                    }.simultaneousGesture(TapGesture().onEnded{
                                        category = "Meal"
                                        categoryKR = "식사"
                                    })
                                    
                                }
                                
                                NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)) {
                                    VStack {
                                        Image("ic_cafe")
                                            .resizable()
                                            .frame(width : 50, height: 50)
                                        
                                        Text("카페").foregroundColor(.purple)
                                    }.frame(width: 70, height: 70)
                                    .padding()
                                    .background(Color.background_button)
                                    .cornerRadius(5)
                                    
                                }.simultaneousGesture(TapGesture().onEnded{
                                    category = "Cafe"
                                    categoryKR = "카페"
                                })
                            }
                        
                        HStack{
                                NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category:
                                                                                $category, categoryKR: $categoryKR)) {
                                    VStack {
                                        Image("ic_liquor")
                                            .resizable()
                                            .frame(width : 50, height: 50)
                                        
                                        Text("술").foregroundColor(.purple)
                                    }.frame(width: 70, height: 70)
                                    .padding()
                                    .background(Color.background_button)
                                    .cornerRadius(5)
                                    
                                }.simultaneousGesture(TapGesture().onEnded{
                                    category = "Alcohol"
                                    categoryKR = "술"
                                })
                                
                                NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)) {
                                    VStack {
                                        Image("ic_sports")
                                            .resizable()
                                            .frame(width : 50, height: 50)
                                        
                                        Text("스포츠").foregroundColor(.purple)
                                    }.frame(width: 70, height: 70)
                                    .padding()
                                    .background(Color.background_button)
                                    .cornerRadius(5)
                                    
                                }.simultaneousGesture(TapGesture().onEnded{
                                    category = "Sports"
                                    categoryKR = "스포츠"
                                })
                                
                                NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)) {
                                    VStack {
                                        Image("ic_convenience")
                                            .resizable()
                                            .frame(width : 50, height: 50)
                                        
                                        Text("편의").foregroundColor(.purple)
                                    }.frame(width: 70, height: 70)
                                    .padding()
                                    .background(Color.background_button)
                                    .cornerRadius(5)
                                    
                                }.simultaneousGesture(TapGesture().onEnded{
                                    category = "Convenience"
                                    categoryKR = "편의"
                                })
                                
                        }.padding()
                        
                        Group{
                            Text("이런 활동 어때요?".localized()).foregroundColor(.purple)
                            
                            Spacer()
                            
                            NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)){
                                
                                VStack {
                                    Spacer()

                                    Text("출출하지 않으신가요?".localized()).font(.body).fontWeight(.semibold).foregroundColor(.purple)
                                    
                                    Spacer()
                                    
                                    Text("🍔 제휴업체에서 식사하기".localized()).foregroundColor(.txtcolor)
                                    
                                    Spacer()
                                }.frame(width: 300, height: 70)
                                .padding()
                                .background(Color.background_button)
                                .cornerRadius(5)
                                
                            }.simultaneousGesture(TapGesture().onEnded{
                                category = "Meal"
                                categoryKR = "식사"
                            })
                            
                            Spacer()
                            
                            NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)){
                                
                                VStack {
                                    Spacer()

                                    Text("🇰🇷 김치보다 커피를 더 많이 마시는 한국인".localized())
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.purple)
                                        .multilineTextAlignment(.center)
                                        .fixedSize()
                                    
                                    Spacer()
                                    
                                    Text("☕️ 제휴업체에 어떤 카페가 있는지 알아볼까요?".localized()).foregroundColor(.txtcolor).fixedSize()
                                    
                                    Spacer()
                                }.frame(width: 300, height: 70)
                                .padding()
                                .background(Color.background_button)
                                .cornerRadius(5)
                                
                            }.simultaneousGesture(TapGesture().onEnded{
                                category = "Cafe"
                                categoryKR = "카페"
                            })
                            
                            Spacer()
                            
                            NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)){
                                
                                VStack {
                                    Spacer()

                                    Text("🎱 집에 가기 전에 한 판?".localized())
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.purple)
                                        .multilineTextAlignment(.center)
                                        .fixedSize()
                                    
                                    Spacer()
                                    
                                    Text("🎳 제휴업체에서 스포츠 업체 확인하기".localized()).foregroundColor(.txtcolor).fixedSize()
                                    
                                    Spacer()
                                }.frame(width: 300, height: 70)
                                .padding()
                                .background(Color.background_button)
                                .cornerRadius(5)
                                
                            }.simultaneousGesture(TapGesture().onEnded{
                                category = "Sports"
                                categoryKR = "스포츠"
                            })
                            
                            Spacer()
                            
                            NavigationLink(destination: allianceListView(getStores: JBNU_COE.getStores(), category: $category, categoryKR: $categoryKR)){
                                
                                VStack {
                                    Spacer()

                                    Text("노래? 게임? 스타일링? 쇼핑?".localized())
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.purple)
                                        .multilineTextAlignment(.center)
                                        .fixedSize()
                                    
                                    Spacer()
                                    
                                    Text("✨ 당신이 하고 싶은 일을 찾아보세요!".localized()).foregroundColor(.txtcolor).fixedSize()
                                    
                                    Spacer()
                                }.frame(width: 300, height: 70)
                                .padding()
                                .background(Color.background_button)
                                .cornerRadius(5)
                                
                            }.simultaneousGesture(TapGesture().onEnded{
                                category = "Convenience"
                                categoryKR = "편의"
                            })
                        }

                        Spacer()
                        
                    }.navigationBarTitle("제휴 업체".localized(), displayMode: .large)
                    .navigationBarBackButtonHidden(true)
//                    .navigationBarItems(trailing: NavigationLink(destination : QRScannerView()){
//                        Image(systemName : "qrcode.viewfinder")
//                    })
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
                
                
            }.onAppear(perform: {
                getStores.alliance.removeAll()
            })
                
                VStack {
                    Text("선택된 카테고리 없음".localized())
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text("계속 하려면 화면 좌측의 버튼을 터치해 카테고리를 선택하십시오.".localized())
                        .foregroundColor(.gray)
                }
            }
        
    }
}

struct Home_Phone_Previews: PreviewProvider {
    static var previews: some View {
        Home_Phone(getStores: getStores())
    }
}
