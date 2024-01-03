//
//  QR_Fail.swift
//  QR_Fail
//
//  Created by 하창진 on 2021/08/17.
//

import SwiftUI

struct QR_Fail: View {
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack{
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(.orange)
            
            Text("죄송합니다, 고객님")
                .fontWeight(.semibold)
            
            Spacer().frame(height : 20)
            
            Text("인식된 QR코드는 등록되지 않은 업체입니다.\n공과대학 제휴업체임에도 인식이 되지 않을 경우 공과대학 학생회 SNS로 공대앱 계정과 함께 영수증을 첨부해주세요.\n불편을 드려 죄송합니다.")
                .multilineTextAlignment(.center)
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
        }
    }
}

struct QR_Fail_Previews: PreviewProvider {
    static var previews: some View {
        QR_Fail()
    }
}
