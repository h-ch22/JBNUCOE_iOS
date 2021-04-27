//
//  myFeedback.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/04/10.
//

import SwiftUI
import Foundation

struct myFeedback {
    var title: String
    var id = UUID()
    var date : String
    var category : String
    var type : String
    var contents : String
    var answered : Bool
    init(title: String, date : String, category : String, type : String, contents : String, answered : Bool){
        self.title = title
        self.category = category
        self.date = date
        self.type = type
        self.contents = contents
        self.answered = answered
    }
}
