//
//  QR_Success.swift
//  QR_Success
//
//  Created by 하창진 on 2021/08/17.
//

import SwiftUI

struct QR_Success: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var storeName : String
    let time : Date
    @EnvironmentObject var helper : UserManagement
    @State private var time_string = ""
    
    var body: some View {
        VStack{
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(.green)
            
            Text("등록이 완료되었어요!")
                .fontWeight(.semibold)
            
            Spacer().frame(height : 30)
            
            HStack{
                Text("등록 업체")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(storeName)
                    .font(.caption)
            }
            
            HStack{
                Text("등록 시간")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(time_string)
                    .font(.caption)
            }
            
            HStack{
                Text("방문자")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(helper.dept + " " + helper.studentNo + " " + helper.name)
                    .multilineTextAlignment(.leading)
                    .font(.caption)
            }
            
            Spacer().frame(height : 15)
            
            Text("고객님의 데이터가 안전하게 서버로 전송되었습니다.")
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer().frame(height : 20)

            Button(action:{
                self.presentationMode.wrappedValue.dismiss()
            }){
                HStack{
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                    
                    Text("뒤로")
                        .foregroundColor(.white)
                }.padding([.horizontal], 50)
                    .padding(20)
                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.blue))
            }

        }.onAppear(perform: {
            helper.getEmail()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy. MM. dd. kk:mm:ss"
            
            time_string = formatter.string(from: time)
            
        })
            .padding(20)
    }
}

//struct QR_Success_Previews: PreviewProvider {
//    static var previews: some View {
//        QR_Success()
//    }
//}
