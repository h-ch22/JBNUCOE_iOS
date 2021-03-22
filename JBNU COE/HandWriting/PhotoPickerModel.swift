//
//  PhotoPickerModel.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/16.
//

import SwiftUI
import Photos

struct PhotoPickerModel: Identifiable {
    enum MediaType{
        case photo
    }
    
    var id : String
    var photo : UIImage?
    var url : URL!
    var mediaType : MediaType = .photo
    
    init(with url : URL){
        mediaType = .photo
        id = UUID().uuidString
        self.url = url
        
        if let data = try? Data(contentsOf: url){
            photo = UIImage(data: data)
        }
    }
    
    mutating func delete(){
        photo = nil
        guard let url = url else{return}
        self.url = nil
    }
}
