//
//  calendarData.swift
//  Widget_JBNUCOEExtension
//
//  Created by 하창진 on 2021/07/07.
//

import SwiftUI

struct calendarData : Decodable {
    let data: [CalendarModel]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([CalendarModel].self, forKey: CodingKeys.data)
    }
}
