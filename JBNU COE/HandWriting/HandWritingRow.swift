//
//  HandWritingRow.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/16.
//

import SwiftUI

struct HandWritingRow: View {
    let handWriting: HandWriting
    
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
