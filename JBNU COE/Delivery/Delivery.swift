//
//  Delivery.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/04/17.
//

import Foundation

struct Delivery : Codable{
    let waybill : String
    let required : String
    let isReceipt : Bool
    
    init(waybill : String, required : String, isReceipt : Bool){
        self.waybill = waybill
        self.required = required
        self.isReceipt = isReceipt
    }
}
