//
//  setStoreInfo.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/13.
//

import Foundation

class setStoreInfo : ObservableObject{
    @Published var storeName : String = ""
    @Published var benefit : String = ""
    
    public func update(storeName : String, benefit : String){
        self.storeName = storeName
        self.benefit = benefit
        
        print(storeName)
        print(benefit)
    }
    
    public func reset(){
        self.storeName = ""
        self.benefit = ""
    }
    
    public func getStoreName() -> String{
        return storeName
    }
    
    public func getBenefit() -> String{
        return benefit
    }
}
