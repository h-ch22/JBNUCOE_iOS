//
//  SportsMapLoader.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/22.
//

import SwiftUI
import UIKit

struct SportsMapLoader : UIViewControllerRepresentable{
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "SportsMap", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "SportsMapViewController")
                
        return viewController
    }
}
