//
//  ApplyMercenary.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/20.
//

import SwiftUI
import FirebaseFirestore

struct ApplyMercenary: View {
    @ObservedObject var getMatches: getMatches
    
    var body: some View {
        List{
            ForEach(getMatches.matches.indices, id: \.self){index in
                NavigationLink(destination : MatchDetail(
                                sports: self.$getMatches.matches[index]
                )){
                    SportsRow(sports: self.$getMatches.matches[index])
                }
            }
        }
        .navigationBarTitle("용병 모집 현황".localized(), displayMode: .large)
        .navigationBarItems(trailing:
            Button(action: {
                getMatches.matches.removeAll()
                getMatches.getMatchList()
            }){
                Image(systemName: "arrow.clockwise")
                                        
            }
        )
        .onAppear(perform: {
            if getMatches.matches.isEmpty{
                getMatches.getMatchList()
            }
        })
            
        .buttonStyle(PlainButtonStyle())
        .listStyle(GroupedListStyle())
        
    }
}

//struct ApplyMercenary_Previews: PreviewProvider {
//    static var previews: some View {
//        ApplyMercenary()
//    }
//}
