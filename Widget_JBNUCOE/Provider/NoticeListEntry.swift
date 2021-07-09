//
//  NoticeListEntry.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/07/07.
//

import Foundation
import WidgetKit

struct NoticeListEntry : TimelineEntry{
    var date = Date()
    let noticeList : [Notice]
}
