//
//  Product.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/05.
//

import Foundation
import SwiftUI
import Foundation

struct Product : Equatable{
    var product : String
    var number : String
    var date : String
    var returned : Bool
    
    init(product : String, number : String, date : String, returned : Bool){
        self.product = product
        self.number = number
        self.date = date
        self.returned = returned
    }
}
