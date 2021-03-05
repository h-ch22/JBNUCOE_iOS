//
//  StudentCouncil_introduce.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/20.
//

import SwiftUI

struct StudentCouncil_introduce: View {
    var body: some View {
        ScrollView{
            VStack(alignment:.center){
                Spacer()
                
                Text("조직도")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Image("Organization chart")
                    .resizable().frame(width: 300, height: 200)
                
                Spacer()
                
                Text("국별 소개")
                    .font(.title)
                    .fontWeight(.semibold)

                Group{
                    Spacer()
                                        
                    Text("기획국")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text("기획국은 공과대학의 모든 행사들을 책임지고 앞장서서 기획하는 국입니다!")
                        .multilineTextAlignment(.center)
                        .frame(width : 300)
                    
                    HStack {
                        Spacer()
                        
                        Image("img_shy")
                            .resizable().frame(width: 150, height: 150)
                        
                        Spacer()
                        
                        Image("img_nh")
                            .resizable().frame(width: 150, height: 150)
                        
                        Spacer()
                    }
                    
                    Text("공과대학 기획국장 유 승 훈\n공과대학 기획부국장 김 남 현")
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Text("대외협력국")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("대외협력국은 지속적인 제휴업체 관리, 공과대학의 대외적인 활동의 관리 및 감독을 하는 국입니다!")
                        .multilineTextAlignment(.center)
                        .frame(width : 300)
                    
                    HStack {
                        Spacer()
                        
                        Image("img_hj")
                            .resizable().frame(width: 150, height: 150)
                        
                        Spacer()
                        
                        Image("img_jw")
                            .resizable().frame(width: 80, height: 150)
                        
                        Spacer()
                    }
                    
                    Text("공과대학 대외협력국장 문 현 준\n공과대학 대외협력부국장 한 지 우")
                        .multilineTextAlignment(.center)
                }
                
                Group{
                    Spacer()
                    
                    Text("사무국")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("사무국은 공과대학 학생회의 모든 예산안 편성 및 학우님들의 소중한 학생회비를 총 관리 감독하는 국입니다!")
                        .multilineTextAlignment(.center)
                        .frame(width : 300)
                    
                    HStack {
                        Spacer()
                        
                        Image("img_hjy")
                            .resizable().frame(width: 140, height: 150)
                        
                        Spacer()
                        
                        Image("img_sy")
                            .resizable().frame(width: 150, height: 150)
                        
                        Spacer()
                    }
                    
                    Text("공과대학 사무국장 윤 하 준\n공과대학 사무부국장 강 송 연")
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Text("시설복지국")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("시설복지국은 공과대학 학우님들의 편의와 복지, 모든 시설물들을 책임지는 국입니다!")
                        .multilineTextAlignment(.center)
                        .frame(width : 300)
                    
                    HStack {
                        Spacer()
                        
                        Image("img_bc")
                            .resizable().frame(width: 150, height: 150)
                        
                        Spacer()
                        
                        Image("img_sh")
                            .resizable().frame(width: 150, height: 150)
                        
                        Spacer()
                    }
                    
                    Text("공과대학 시설복지국장 이 병 철\n공과대학 시설복지부국장 오 성 현")
                        .multilineTextAlignment(.center)
                }
                
                Group{
                    Spacer()
                    
                    Text("운영지원국")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("운영지원국은 공과대학 학생회에서 진행하는 행사 및 사업을 운영하는 국입니다!")
                        .multilineTextAlignment(.center)
                        .frame(width : 300)
                    HStack {
                        Spacer()
                        
                        Image("img_ij")
                            .resizable().frame(width: 150, height: 150)
                        
                        Spacer()
                        
                        Image("img_js")
                            .resizable().frame(width: 150, height: 150)
                        
                        Spacer()
                    }
                    
                    Text("공과대학 운영지원국장 최 인 정\n공과대학 운영지원부국장 최 지 수")
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Text("정책국")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("정책국은 공과대학 학생회의 공약 이행을 총괄하고, 재정 감사를 담당하는 국입니다!")
                        .multilineTextAlignment(.center)
                        .frame(width : 300)
                    
                    HStack {
                        Spacer()
                        
                        Image("img_sm")
                            .resizable().frame(width: 100, height: 150)
                        
                        Spacer()
                        
                        Image("img_hh")
                            .resizable().frame(width: 100, height: 150)
                        
                        Spacer()
                    }
                    
                    Text("공과대학 정책국장 배 선 명\n공과대학 정책부국장 정 환 희")
                        .multilineTextAlignment(.center)
                }
                
                Group{
                    Spacer()
                    
                    Text("홍보국")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("홍보국은 공과대학 SNS 관리, 각종 행사에 대한 홍보물을 총괄하여 담당합니다.\n또한, 공과대학 애플리케이션의 개발 및 유지보수를 맡고 있죠.")
                        .multilineTextAlignment(.center)
                        .frame(width : 300)
                    
                    HStack {
                        Spacer()
                        
                        Image("img_cj")
                            .resizable().frame(width: 120, height: 150)
                        
                        Spacer()
                        
                        Image("img_hy")
                            .resizable().frame(width: 150, height: 150)
                        
                        Spacer()
                    }
                    
                    Text("공과대학 홍보국장 하 창 진\n공과대학 홍보부국장 이 하 영")
                        .multilineTextAlignment(.center)
                }
                

            }.navigationBarTitle(Text("공대 학생회를 소개합니다."))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct StudentCouncil_introduce_Previews: PreviewProvider {
    static var previews: some View {
        StudentCouncil_introduce()
    }
}
