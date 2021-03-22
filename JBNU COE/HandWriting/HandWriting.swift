//
//  HandWriting.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/16.
//

import Foundation

struct HandWriting : Equatable{
    var title : String
    var author : String
    var read : Int
    var recommend : Int
    var dateTime : String
    
    init(title : String, author : String, read : Int, recommend : Int, dateTime : String){
        self.title = title
        self.author = author
        self.read = read
        self.recommend = recommend
        self.dateTime = dateTime
    }
}
