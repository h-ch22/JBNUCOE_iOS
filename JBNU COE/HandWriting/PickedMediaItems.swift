//
//  PickedMediaItems.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/16.
//

import Combine
import SwiftUI
import PhotosUI

class PickedMediaItems: ObservableObject{
    @Published var items = [PhotoPickerModel]()
    
    func append(item: PhotoPickerModel){
        items.append(item)
    }
    
    func delete(index : Int){
        items[index].delete()
    }
}
