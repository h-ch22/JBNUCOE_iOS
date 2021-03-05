//
//  NaverMapViewController.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/12.
//

import Foundation
import UIKit
import SwiftUI
import NMapsMap

class NaverMapViewController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapview = NMFMapView(frame: view.frame)
        view.addSubview(mapview)
    }
}
