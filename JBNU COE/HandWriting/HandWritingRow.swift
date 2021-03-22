//
//  HandWritingRow.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/16.
//

import SwiftUI

struct HandWritingRow: View {
    @Binding var handWriting: HandWriting
    
    init(handWriting: Binding<HandWriting>){
        self._handWriting = handWriting
    }
    
    var body: some View {
        VStack(alignment : .leading){
            Text(handWriting.title)
                .fontWeight(.bold)
            
            HStack{
                Text(handWriting.author)
                Spacer()
                Text(handWriting.dateTime)
            }
            
            HStack{
                HStack{
                    Image(systemName: "eye").resizable().frame(width : 25, height : 20).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Text(String(handWriting.read)).foregroundColor(.blue)
                }
                
                Spacer()
                
                HStack{
                    Image(systemName: "hand.thumbsup").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                    Text(String(handWriting.recommend)).foregroundColor(.red)
                }
            }
        }.padding()
    }
}

struct HandWritingRow_Previews: PreviewProvider {
    @State static var handWriting = HandWriting(title: "Test", author: "소프트웨어공학과 18 하**", read: 0, recommend: 0, dateTime:"0000. 00. 00. 00:00")

    static var previews: some View {
        HandWritingRow(handWriting: $handWriting)
    }
}

