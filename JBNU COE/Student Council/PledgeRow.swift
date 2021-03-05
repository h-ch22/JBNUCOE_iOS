//
//  PledgeRow.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/02/13.
//

import SwiftUI

struct PledgeRow: View {
    @Binding var pledge: Pledge

    init(pledge: Binding<Pledge>){
        self._pledge = pledge
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(pledge.pledge)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
                if pledge.implemented == "이행 완료"{
                    HStack{
                        Image(systemName : "checkmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                        
                        Text("이행 완료")
                            .foregroundColor(.green)
                    }
                }
                
                else{
                    HStack{
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.orange)
                        
                        Text("준비 중")
                            .foregroundColor(.orange)
                    }
                }

        }
    }
}
