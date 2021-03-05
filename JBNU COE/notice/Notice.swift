//
//  Notice.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/14.
//

import SwiftUI
import Foundation

struct Notice : Equatable{
    var title : String
    var contents : String
    var date : String
    var read : Int
    
    init(title : String, date : String, contents : String, read : Int){
        self.title = title
        self.date = date
        self.contents = contents
        self.read = read
    }
}
