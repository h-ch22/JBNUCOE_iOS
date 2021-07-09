//
//  FeedbackHub_category.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI

struct FeedbackHub_category: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isFacilitySelected = false
    @State var isWelfareSelected = false
    @State var isCommunicationSelected = false
    @State var isPromiseSelected = false
    @State var isEventSelected = false
    @State var isAppSelected = false
    @State var isComplaintsSelected = false
    @Binding var show : Bool
    @State var isOtherSelected = false
    @State var category = ""
    @State var isEnabled = false
    @EnvironmentObject var user : UserManagement
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack {
                    Spacer()
                    
                    Image("bg_feedbackHub")
                        .resizable()
                        .frame(width : 250, height: 250)
                    Text("카테고리를 선택해주세요.".localized())
                        .font(.title)
                        .fontWeight(.bold)
                                
                    Spacer()
                    
                    VStack {
                        HStack{
                            Button(action: {
                                isEnabled = true
                                category = "Facility"
                                isFacilitySelected = true
                                isWelfareSelected = false
                                isCommunicationSelected = false
                                isPromiseSelected = false
                                isEventSelected = false
                                isAppSelected = false
                                isOtherSelected = false
                                isComplaintsSelected = false
                            }){
                                HStack{
                                    Image(systemName: "wrench.and.screwdriver.fill")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(isFacilitySelected ? Color.orange : Color.gray)
                                    
                                    Text("시설".localized())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(isFacilitySelected ? Color.orange : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                                        .stroke(isFacilitySelected ? Color.orange : Color.gray, lineWidth: 3))
                            
                            Button(action: {
                                isEnabled = true
                                category = "Welfare"
                                isFacilitySelected = false
                                isWelfareSelected = true
                                isCommunicationSelected = false
                                isPromiseSelected = false
                                isEventSelected = false
                                isAppSelected = false
                                isOtherSelected = false
                                isComplaintsSelected = false
                            }){
                                HStack{
                                    Image(systemName: "cross.fill")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(isWelfareSelected ? Color.orange : Color.gray)
                                    
                                    Text("복지".localized())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(isWelfareSelected ? Color.orange : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                                        .stroke(isWelfareSelected ? Color.orange : Color.gray, lineWidth: 3))
                        }
                        
                        HStack {
                            Button(action: {
                                isEnabled = true
                                category = "Communication"
                                isFacilitySelected = false
                                isWelfareSelected = false
                                isCommunicationSelected = true
                                isPromiseSelected = false
                                isEventSelected = false
                                isAppSelected = false
                                isOtherSelected = false
                                isComplaintsSelected = false
                            }){
                                HStack{
                                    Image(systemName: "bubble.left.and.bubble.right.fill")
                                        .resizable()
                                        .frame(width : 35, height : 30)
                                        .foregroundColor(isCommunicationSelected ? Color.orange : Color.gray)
                                    
                                    Text("소통".localized())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(isCommunicationSelected ? Color.orange : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                                        .stroke(isCommunicationSelected ? Color.orange : Color.gray, lineWidth: 3))
                            
                            Button(action: {
                                isEnabled = true
                                category = "Promise"
                                isFacilitySelected = false
                                isWelfareSelected = false
                                isCommunicationSelected = false
                                isPromiseSelected = true
                                isEventSelected = false
                                isAppSelected = false
                                isOtherSelected = false
                                isComplaintsSelected = false
                            }){
                                HStack{
                                    Image(systemName: "list.bullet.rectangle")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(isPromiseSelected ? Color.orange : Color.gray)
                                    
                                    Text("공약".localized())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(isPromiseSelected ? Color.orange : Color.gray)
                                }
                            }.frame(width :120 ,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                                        .stroke(isPromiseSelected ? Color.orange : Color.gray, lineWidth: 3))
                        }
                        
                        HStack {
                            Button(action: {
                                isEnabled = true
                                category = "Event"
                                isFacilitySelected = false
                                isWelfareSelected = false
                                isCommunicationSelected = false
                                isPromiseSelected = false
                                isEventSelected = true
                                isAppSelected = false
                                isOtherSelected = false
                                isComplaintsSelected = false
                            }){
                                HStack{
                                    Image(systemName: "rays")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(isEventSelected ? Color.orange : Color.gray)
                                    
                                    Text("행사".localized())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(isEventSelected ? Color.orange : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                                        .stroke(isEventSelected ? Color.orange : Color.gray, lineWidth: 3))
                            
                            Button(action: {
                                isEnabled = true
                                category = "App"
                                isFacilitySelected = false
                                isWelfareSelected = false
                                isCommunicationSelected = false
                                isPromiseSelected = false
                                isEventSelected = false
                                isAppSelected = true
                                isOtherSelected = false
                                isComplaintsSelected = false
                            }){
                                HStack{
                                    Image(systemName: "apps.iphone")
                                        .resizable()
                                        .frame(width : 20, height : 30)
                                        .foregroundColor(isAppSelected ? Color.orange : Color.gray)
                                    
                                    Text("앱".localized())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(isAppSelected ? Color.orange : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                                        .stroke(isAppSelected ? Color.orange : Color.gray, lineWidth: 3))
                        }
                        
                        Spacer()
                        
                        HStack{
                            Button(action: {
                                isEnabled = true
                                category = "Complaints"
                                isFacilitySelected = false
                                isWelfareSelected = false
                                isComplaintsSelected = true
                                isCommunicationSelected = false
                                isPromiseSelected = false
                                isEventSelected = false
                                isAppSelected = false
                                isOtherSelected = false
                            }){
                                HStack{
                                    Image(systemName: "cube.box.fill")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(isComplaintsSelected ? Color.orange : Color.gray)
                                    
                                    Text("민원\n사업".localized())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .foregroundColor(isComplaintsSelected ? Color.orange : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                                        .stroke(isComplaintsSelected ? Color.orange : Color.gray, lineWidth: 3))
                            
                            Button(action: {
                                isEnabled = true
                                category = "Others"
                                isFacilitySelected = false
                                isWelfareSelected = false
                                isCommunicationSelected = false
                                isComplaintsSelected = false
                                isPromiseSelected = false
                                isEventSelected = false
                                isAppSelected = false
                                isOtherSelected = true
                            }){
                                HStack{
                                    Image(systemName: "ellipsis.circle.fill")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(isOtherSelected ? Color.orange : Color.gray)
                                    
                                    Text("기타".localized())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(isOtherSelected ? Color.orange : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                                        .stroke(isOtherSelected ? Color.orange : Color.gray, lineWidth: 3))
                        }
                        
                        
                        Spacer()
                        
                        if user.isAdmin{
                            NavigationLink(destination: FeedbackListView(getFeedbacks: getFeedbacks()).navigationBarTitle("전체 피드백")){
                                HStack {
                                    Text("모든 피드백 보기")
                                    
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .frame(width : 5, height : 10)
                                }
                            }
                        }
                        
                        if(isEnabled){
                            NavigationLink(destination: FeedbackHub_main(category: $category).navigationTitle("피드백 보내기".localized())){
                                HStack{
                                    Text("다음 단계로".localized())
                                        .foregroundColor(.white)
                                    Image(systemName : "chevron.right")
                                        .foregroundColor(.white)
                                }
                                .frame(width : UIScreen.main.bounds.width,
                                        height : 60)
                                .background(Rectangle().foregroundColor(
                                    .orange
                                ))
                            }
                        }
                        
                        
                    }
                }
            }.navigationBarTitle(Text("카테고리 선택".localized())).navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {self.presentationMode.wrappedValue.dismiss()}){
                Text("닫기".localized())
            }, trailing: NavigationLink(destination: showMyFeedback(getFeedbacks: getMyFeedbacks())) {
                Text("보낸 피드백 확인")
            })
            
        }
    }
}

struct FeedbackHub_category_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackHub_category(show: .constant(true))
    }
}
