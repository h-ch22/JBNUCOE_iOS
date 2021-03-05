//
//  FeedbackRow.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI

struct FeedbackRow: View {
    @Binding var feedback: Feedback
    
    init(feedback: Binding<Feedback>){
        self._feedback = feedback
    }
    
    var body: some View {
        VStack(alignment : .leading){
            Text(feedback.title)
                .fontWeight(.bold)
            
            HStack{
                Spacer()
                Text(feedback.date)
                Spacer()
                Text(feedback.author)
                Spacer()
                Text(feedback.category)
                Spacer()
                Text(feedback.type)
                Spacer()
            }
        }
    }
}

struct FeedbackRow_Previews: PreviewProvider {
    @State static var feedback = Feedback(title: "", author: "", date: "", category: "", type: "", contents: "")
    static var previews: some View {
        FeedbackRow(feedback: $feedback)
    }
}
