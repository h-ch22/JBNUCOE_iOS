//
//  StudentCouncil_main.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/20.
//

import SwiftUI

struct StudentCouncil_main: View {
    @ObservedObject var text = loadText()

    var body: some View {
            ScrollView{
                VStack{
                    Image("ic_coelogo")
                        .resizable()
                        .frame(width: 150, height: 150)
                    
                    Text("우리의 이야기, 들어보실래요?".localized())
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()

                    Group{
                        NavigationLink(destination: StudentCouncil_greet(text: text)){
                            HStack{
                                Image(systemName: "person.2.fill")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                                    .foregroundColor(Color.blue)

                                Text("인사말".localized())
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.blue)
                            }
                        }.frame(width : UIScreen.main.bounds.width / 1.5,
                                height : 40)
                        .padding(30)
                        .background(RoundedRectangle(cornerRadius: 20)
                                                        .foregroundColor(.blue).opacity(0.2))
                        
                    Spacer()

                        NavigationLink(destination: StudentCouncil_introduce()){
                            HStack{
                                Image(systemName: "hand.wave.fill")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                                    .foregroundColor(Color.blue)

                                Text("국 소개".localized())
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.blue)
                            }
                        }.frame(width : UIScreen.main.bounds.width / 1.5,
                                height : 40)
                        .padding(30)
                        .background(RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.blue).opacity(0.2))
                    
                    Spacer()

                        NavigationLink(destination: StudentCouncil_PledgeProgress()){
                            HStack{
                                Image(systemName: "list.bullet.rectangle")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                                    .foregroundColor(Color.blue)

                                Text("실시간 공약 이행률".localized())
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.blue)
                            }
                        }.frame(width : UIScreen.main.bounds.width / 1.5,
                                height : 40)
                        .padding(30)
                        .background(RoundedRectangle(cornerRadius: 20)
                                                        .foregroundColor(.blue).opacity(0.2))
                    
                    Spacer()
                    }
                       
                }

            }
        .navigationBarTitle(Text("공대학생회 소개".localized()))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StudentCouncil_main_Previews: PreviewProvider {
    static var previews: some View {
        StudentCouncil_main()
    }
}
