//
//  EventItem.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/05/17.
//

import SwiftUI
import Foundation

struct EventItem : Hashable{
    var title : String
    var contents : String
    var startDate : String
    var endDate : String
    var maxUser : Int
    var currentUser : Int
    var available : Bool
    
    init(title : String, contents : String, startDate : String, endDate : String, maxUser : Int, currentUser : Int, available : Bool){
        self.title = title
        self.contents = contents
        self.startDate = startDate
        self.endDate = endDate
        self.maxUser = maxUser
        self.currentUser = currentUser
        self.available = available
    }
}
