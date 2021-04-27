//
//  DeliveryRow.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/04/17.
//

import SwiftUI

struct DeliveryRow: View {
    @Binding var delivery: Delivery
    
    init(delivery: Binding<Delivery>){
        self._delivery = delivery
    }
    
    var body: some View {
        VStack(alignment : .leading){
            Text(delivery.required)
                .fontWeight(.bold)
                .fixedSize()
            
            Text(delivery.waybill)
                .fontWeight(.bold)
                .fixedSize()
            
            if delivery.isReceipt{
                HStack{
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                    
                    Text("수령 완료")
                        .foregroundColor(.green)
                }
            }
            
            else{
                HStack{
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                    
                    Text("수령하지 않음")
                        .foregroundColor(.red)
                }
            }
        }
    }
}
