//
//  myFeedbackRow.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/04/10.
//

import SwiftUI

struct myFeedbackRow: View {
    @Binding var myfeedback: myFeedback
    
    init(myfeedback: Binding<myFeedback>){
        self._myfeedback = myfeedback
    }
    
    var body: some View {
        VStack(alignment : .leading){
            Text(myfeedback.title)
                .fontWeight(.bold)
            
            HStack{
                Spacer()
                Text(myfeedback.date)
                Spacer()
                Text(myfeedback.category)
                Spacer()
                Text(myfeedback.type)
                Spacer()
            }
            
            if myfeedback.answered{
                HStack{
                    Image(systemName : "checkmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.green)
                    
                    Text("답변 완료").foregroundColor(.green)
                }
            }
            
            else{
                HStack{
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.orange)
                    
                    Text("답변 대기")
                        .foregroundColor(.orange)
                }
            }
        }
    }
}
