//
//  CalendarListEntry.swift
//  Widget_JBNUCOEExtension
//
//  Created by 하창진 on 2021/07/07.
//

import Foundation
import WidgetKit

struct CalendarListEntry : TimelineEntry{
    var date = Date()
    let model : [CalendarModel]
}
