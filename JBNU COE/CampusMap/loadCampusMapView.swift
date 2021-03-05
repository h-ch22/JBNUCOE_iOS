//
//  loadCampusMapView.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/19.
//

import SwiftUI
import UIKit

struct loadCampusMapView : UIViewControllerRepresentable{
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "CampusMap", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "CampusMapView")
        
        
        return viewController
    }
}
