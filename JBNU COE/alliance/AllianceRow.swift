//
//  AllianceRow.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI
import SDWebImageSwiftUI

struct AllianceRow: View {
    @Binding var alliance: Alliance
    
    init(alliance: Binding<Alliance>){
        self._alliance = alliance
    }
    
    var body: some View {
        HStack {
            WebImage(url: alliance.url)
                .resizable()
                .frame(width: 100, height: 100, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
            
            VStack(alignment:.leading) {
                Text(alliance.storeName).font(.title).fontWeight(.bold)
                Text(alliance.benefits)
                    .foregroundColor(.gray)
                
                if alliance.isEnable != "알 수 없음"{
                    HStack{
                        Image(systemName : "clock.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.blue)

                        Text("이용 가능 시간 : " + alliance.isEnable)
                            .foregroundColor(.blue)
                    }
                }
                
                if alliance.isEnable == "알 수 없음"{
                    HStack{
                        Image(systemName: "exclamationmark.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.orange)
                        
                        Text("영업 시간을 알 수 없습니다.")
                            .foregroundColor(.orange)
                    }
                }
                
                if alliance.brake != ""{
                    HStack{
                        Image(systemName: "pause.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.orange)
                        
                        Text("브레이크 타임 : " + alliance.brake)
                            .foregroundColor(.orange)
                    }
                }
                
                if alliance.closed != ""{
                    HStack{
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        
                        Text("휴무 : " + alliance.closed)
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

struct AllianceRow_Previews: PreviewProvider {
    @State static var alliance = Alliance(storeName: "", benefits: "", engName: "", url: URL(string: "")!, category: "", isEnable : "", brake : "", closed :"")

    static var previews: some View {
        AllianceRow(alliance : $alliance)
    }
}
