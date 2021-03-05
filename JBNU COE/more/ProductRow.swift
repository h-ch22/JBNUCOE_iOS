//
//  ProductRow.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/05.
//

import Foundation
import SwiftUI

struct ProductRow: View {
    @Binding var product: Product
    
    init(product: Binding<Product>){
        self._product = product
    }
    
    var body: some View {
        VStack(alignment : .leading){
            Text(product.date + " " + product.product)
                .fontWeight(.bold)
            
            HStack {
                
                Text("수량 : " + product.number)
                
                Spacer()
                
                if product.returned{
                    Text("반납 여부 : 예")
                        .foregroundColor(.blue)
                }
                
                else{
                    Text("반납 여부 : 아니오")
                        .foregroundColor(.red)
                }
                
            }
        }
    }
}
