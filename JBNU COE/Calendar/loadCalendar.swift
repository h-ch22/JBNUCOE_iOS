//
//  loadCalendar.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/20.
//

import SwiftUI

struct loadCalendar : UIViewControllerRepresentable{
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Calendar", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "CalendarViewController")
        
        return viewController
    }
}
