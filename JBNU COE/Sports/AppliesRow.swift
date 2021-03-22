//
//  AppliesRow.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/30.
//

import Foundation
import SwiftUI

struct AppliesRow : View{
    @Binding var applies: Applies
    
    init(applies: Binding<Applies>){
        self._applies = applies
    }
    
    var body: some View {
        VStack(alignment : .leading){
            Text(applies.name)
                .fontWeight(.bold)
            
            HStack {
                Text(applies.dept + " " + applies.studentNo)
                Spacer()
                Text("연락처 : ".localized() + applies.phone)
            }
        }
    }
}
