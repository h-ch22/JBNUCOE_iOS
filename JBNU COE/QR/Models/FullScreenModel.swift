//
//  FullScreenModel.swift
//  FullScreenModel
//
//  Created by 하창진 on 2021/08/17.
//

import Foundation

enum FullScreenModel : Identifiable{
    case success, fail
    
    var id : Int{
        hashValue
    }
}
