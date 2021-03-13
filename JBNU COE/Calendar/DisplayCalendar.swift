//
//  DisplayCalendar.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/11.
//

import SwiftUI

struct DisplayCalendar: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CalendarViewController {
            // this will work if you are not using Storyboards at all.
            return CalendarViewController()
        }

        func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
            // update code
        }
}
