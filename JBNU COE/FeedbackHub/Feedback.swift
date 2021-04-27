//
//  Feedback.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI
import Foundation

struct Feedback {
    var title: String
    var id = UUID()
    var author : String
    var date : String
    var category : String
    var type : String
    var contents : String
    var answered : Bool
    
    init(title: String, author : String, date : String, category : String, type : String, contents : String, answered : Bool){
        self.title = title
        self.author = author
        self.category = category
        self.date = date
        self.type = type
        self.contents = contents
        self.answered = answered
    }
}
