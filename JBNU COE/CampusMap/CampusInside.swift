//
//  CampusInside.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/22.
//

import SwiftUI

struct showInsideImage: View {
    @Binding var floor: String
    @Binding var building : String
    @State var lastScaleValue: CGFloat = 1.0
    @State var scale : CGFloat = 1.0
    var aspectRatio: Binding<CGFloat>?
    @State var dragOffset: CGSize = CGSize.zero
    @State var dragOffsetPredicted: CGSize = CGSize.zero
    
    
    var body: some View {
        ZStack {
            Image("building_" + building + "_" + floor)
                .resizable()
                .frame(width : 300, height : 200)
                .scaleEffect(scale)
                .scaledToFill()
                .aspectRatio(self.aspectRatio?.wrappedValue, contentMode: .fit)
                .offset(x: self.dragOffset.width, y: self.dragOffset.height)
                .rotationEffect(.init(degrees: Double(self.dragOffset.width / 30)))
                .pinchToZoom()
                
                .gesture(DragGesture()
                            .onChanged { value in
                                self.dragOffset = value.translation
                                self.dragOffsetPredicted = value.predictedEndTranslation
                            }
                            .onEnded { value in
                                if((abs(self.dragOffset.height) + abs(self.dragOffset.width) > 570) || ((abs(self.dragOffsetPredicted.height)) / (abs(self.dragOffset.height)) > 3) || ((abs(self.dragOffsetPredicted.width)) / (abs(self.dragOffset.width))) > 3) {
                                    
                                    return
                                }
                                self.dragOffset = .zero
                            }
                )
        }
    }
}

struct CampusInside: View {
    @Binding var building : String
    @State var floor : String = ""
    @State var buildno : String = ""
    
    var body: some View {
        VStack {
            ScrollView(.horizontal){
                HStack {
                    if building == "1st"{
                        Button(action : {
                            floor = "1f"
                            buildno = "1"
                        }){
                            Text("1층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.red))
                        
                        Button(action : {
                            floor = "2f"
                            buildno = "1"
                        }){
                            Text("2층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.pink))
                        
                        Button(action : {
                            floor = "3f"
                            buildno = "1"
                        }){
                            Text("3층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.orange))
                    }
                    
                    if building == "2nd"{
                        Button(action : {
                            floor = "1f"
                            buildno = "2"
                        }){
                            Text("1층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.red))
                        
                        Button(action : {
                            floor = "2f"
                            buildno = "2"
                        }){
                            Text("2층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.pink))
                        
                        Button(action : {
                            floor = "3f"
                            buildno = "2"
                        }){
                            Text("3층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.orange))
                        
                        Button(action : {
                            floor = "4f"
                            buildno = "2"
                        }){
                            Text("4층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.yellow))
                    }
                    
                    if building == "3rd"{
                        Button(action : {
                            floor = "1f"
                            buildno = "3"
                        }){
                            Text("1층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.red))
                        
                        Button(action : {
                            floor = "2f"
                            buildno = "3"
                        }){
                            Text("2층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.pink))
                        
                        Button(action : {
                            floor = "3f"
                            buildno = "3"
                        }){
                            Text("3층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.orange))
                        
                        Button(action : {
                            floor = "4f"
                            buildno = "3"
                        }){
                            Text("4층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.yellow))
                    }
                    
                    if building == "4th"{
                        Button(action : {
                            floor = "b1f"
                            buildno = "4"
                        }){
                            Text("지하 1층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.red))
                        
                        Button(action : {
                            floor = "1f"
                            buildno = "4"
                        }){
                            Text("1층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.pink))
                        
                        Button(action : {
                            floor = "2f"
                            buildno = "4"
                        }){
                            Text("2층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.orange))
                        
                        Button(action : {
                            floor = "3f"
                            buildno = "4"
                        }){
                            Text("3층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.yellow))
                        
                        Button(action : {
                            floor = "4f"
                            buildno = "4"
                        }){
                            Text("4층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.green))
                    }
                    
                    if building == "5th"{
                        Button(action : {
                            floor = "1f"
                            buildno = "5"
                        }){
                            Text("1층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.red))
                        
                        Button(action : {
                            floor = "2f"
                            buildno = "5"
                        }){
                            Text("2층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.pink))
                        
                        Button(action : {
                            floor = "3f"
                            buildno = "5"
                        }){
                            Text("3층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.orange))
                        
                        Button(action : {
                            floor = "4f"
                            buildno = "5"
                        }){
                            Text("4층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.yellow))
                        
                        Button(action : {
                            floor = "5f"
                            buildno = "5"
                        }){
                            Text("5층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.green))
                    }
                    
                    if building == "6th"{
                        Button(action : {
                            floor = "b1f"
                            buildno = "6"
                        }){
                            Text("지하 1층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.red))
                        
                        Button(action : {
                            floor = "1f"
                            buildno = "6"
                        }){
                            Text("1층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.pink))
                        
                        Button(action : {
                            floor = "2f"
                            buildno = "6"
                        }){
                            Text("2층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.orange))
                        
                        Button(action : {
                            floor = "3f"
                            buildno = "6"
                        }){
                            Text("3층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.yellow))
                        
                        Button(action : {
                            floor = "4f"
                            buildno = "6"
                        }){
                            Text("4층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.green))
                        
                        Button(action : {
                            floor = "5f"
                            buildno = "6"
                        }){
                            Text("5층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.blue))
                    }
                    
                    if building == "7th"{
                        Button(action : {
                            floor = "1f"
                            buildno = "7"
                        }){
                            Text("1층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.red))
                        
                        Button(action : {
                            floor = "2f"
                            buildno = "7"
                        }){
                            Text("2층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.pink))
                        
                        Button(action : {
                            floor = "3f"
                            buildno = "7"
                        }){
                            Text("3층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.orange))
                        
                        Button(action : {
                            floor = "4f"
                            buildno = "7"
                        }){
                            Text("4층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.yellow))
                        
                        Button(action : {
                            floor = "5f"
                            buildno = "7"
                        }){
                            Text("5층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.green))
                        
                        Button(action : {
                            floor = "6f"
                            buildno = "7"
                        }){
                            Text("6층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.blue))
                    }
                    
                    if building == "8th"{
                        Button(action : {
                            floor = "1f"
                            buildno = "8"
                        }){
                            Text("1층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.red))
                        
                        Button(action : {
                            floor = "2f"
                            buildno = "8"
                        }){
                            Text("2층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.pink))
                        
                        Button(action : {
                            floor = "3f"
                            buildno = "8"
                        }){
                            Text("3층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.orange))
                        
                        Button(action : {
                            floor = "4f"
                            buildno = "8"
                        }){
                            Text("4층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.yellow))
                    }
                    
                    
                    if building == "9th"{
                        Button(action : {
                            floor = "1f"
                            buildno = "9"
                        }){
                            Text("1층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.red))
                        
                        Button(action : {
                            floor = "2f"
                            buildno = "9"
                        }){
                            Text("2층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.pink))
                        
                        Button(action : {
                            floor = "3f"
                            buildno = "9"
                        }){
                            Text("3층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.orange))
                        
                        Button(action : {
                            floor = "4f"
                            buildno = "9"
                        }){
                            Text("4층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.yellow))
                        
                        Button(action : {
                            floor = "5f"
                            buildno = "9"
                        }){
                            Text("5층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.green))
                        
                        Button(action : {
                            floor = "6f"
                            buildno = "9"
                        }){
                            Text("6층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.blue))
                        
                        Button(action : {
                            floor = "7f"
                            buildno = "9"
                        }){
                            Text("7층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.purple))
                        
                        Button(action : {
                            floor = "8f"
                            buildno = "9"
                        }){
                            Text("8층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.gray))
                        
                        Button(action : {
                            floor = "9f"
                            buildno = "9"
                        }){
                            Text("9층".localized()).foregroundColor(.white).padding([.horizontal], 15).padding([.vertical], 10)
                        }.background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.black))
                    }
                    
                    
                }
            }.padding([.horizontal], 10)
            .padding([.vertical], 20)
            
            Spacer()
            
            showInsideImage(floor: $floor, building: $buildno)
                        
            Spacer()
        }.navigationBarTitle("실내 지도 보기".localized())
        .navigationBarItems(trailing:
                                Button(action : {
                                    let numberString = "tel://" + "0632704545"
                                    let numberURL = URL(string: numberString)
                                    UIApplication.shared.openURL(numberURL!)
                                }, label : {Text("상황실 전화하기".localized())})
        )
        
    }
    
}
