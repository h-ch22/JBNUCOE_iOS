//
//  EventRow.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/05/17.
//

import SwiftUI

struct EventRow: View {
    let event: EventItem
    
    var body: some View {
        VStack(alignment : .leading){
            Text(event.title)
                .fontWeight(.bold)
            
            HStack{
                Image(systemName: "clock.fill")
                
                Text(event.startDate)
                    .foregroundColor(.blue)
                
                Text(" ~ ")
                    .foregroundColor(.blue)
                
                Text(event.endDate)
            }
            
            HStack{
                
            }
        }
    }
}
