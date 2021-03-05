//
//  Applies.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/30.
//

import Foundation

struct Applies : Codable{
    let name : String
    let studentNo : String
    let dept : String
    let phone : String
    
    init(name : String, studentNo : String, dept : String, phone : String){
        self.name = name
        self.studentNo = studentNo
        self.dept = dept
        self.phone = phone
    }
}
