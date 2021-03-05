//
//  SportsTabView.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/20.
//

import SwiftUI

struct SportsMain: View {
    @State var showModal = false

    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .center){
                    Spacer()

                    Image("sports_background")
                        .resizable()
                        .frame(width: 350, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Text("공스는 공과대학 학우님들을 위한 스포츠 상대 팀 또는 부족한 인원을 더욱 편리하게 구할 수 있도록 도와드리는 서비스입니다.")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .frame(width : 250)
                    
                    Spacer()
            
                    NavigationLink(destination: ApplyMercenary(getMatches: getMatches())){
                        HStack{
                            Text("용병 모집 현황 확인하기")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                    }.frame(width: 250, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(
                        RoundedRectangle(cornerRadius: 15).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    )
                    
                    Spacer()
                    
                    Button(action: {showModal = true}){
                        HStack{
                            Text("용병 구인 신청하기")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                            Image(systemName: "chevron.right.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Spacer()

                }.navigationBarTitle(Text("공스 시작하기"))
                .navigationBarItems(trailing: NavigationLink(destination: showMyRoom(getMatches: getMatches(), getApplied: getAppliedMatches())) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                })
                .sheet(isPresented: $showModal, content: {
                    ApplyMatch(showModal: $showModal)
                })
                .onAppear(perform: {
                    getMatches().matches.removeAll()
                })
            }
        }
    }
}
