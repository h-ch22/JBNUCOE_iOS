//
//  Alliance.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI
import Foundation


struct Alliance : Hashable{
    var storeName : String
    var benefits : String
    var engName : String
    var url : URL
    var category : String
    var isEnable : String
    var closed : String
    var brake : String
    
    init(storeName : String, benefits : String, engName : String, url : URL, category : String, isEnable : String, brake : String, closed : String){
        self.storeName = storeName
        self.benefits = benefits
        self.engName = engName
        self.url = url
        self.category = category
        self.isEnable = isEnable
        self.closed = closed
        self.brake = brake
    }
}
