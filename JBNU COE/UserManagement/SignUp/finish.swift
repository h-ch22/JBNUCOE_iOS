//
//  finish.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/15.
//

import SwiftUI

struct finish: View {
    @Binding var show : Bool
    @State var change = false
    
    var body: some View {
        NavigationView{
            VStack {
                Image(systemName: "checkmark.circle")
                    .resizable().frame(width: 150, height: 150, alignment: .center)
                    .foregroundColor(.green)
                
                Text("감사합니다.".localized())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer().frame(height : 40)
                
                NavigationLink(destination: ContentView(show: $show
                ).navigationBarHidden(true)){
                    HStack{
                        Text("시작하기".localized())
                            .foregroundColor(.white)
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                }.padding(20)
                .padding([.horizontal], 40)
                .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.blue))
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .onTapGesture(perform: {
                    change = true
                })
            }
        }
            
        
    }
}

struct finish_Previews: PreviewProvider {
    static var previews: some View {
        finish(show: .constant(true))
    }
}
