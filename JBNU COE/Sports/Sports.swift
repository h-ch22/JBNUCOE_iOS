//
//  Struct.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/22.
//

import Foundation

struct Sports : Codable{
    let name : String
    let allPeople : Int
    let currentPeople : Int
    let date : String
    let event : String
    let limit : String
    let location : String
    let adminName : String
    let studentNo : String
    let dept : String
    let phone : String
    
    init(name : String, allPeople : Int, currentPeople : Int, date: String, event : String, limit : String, location : String, adminName : String, studentNo : String, dept : String, phone : String){
        self.name = name
        self.allPeople = allPeople
        self.currentPeople = currentPeople
        self.date = date
        self.event = event
        self.limit = limit
        self.location = location
        self.adminName = adminName
        self.studentNo = studentNo
        self.dept = dept
        self.phone = phone
    }
}
