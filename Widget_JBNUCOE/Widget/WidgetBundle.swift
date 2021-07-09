//
//  WidgetBundle.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/07/07.
//

import WidgetKit
import SwiftUI

@main
struct JBNU_CH_WidgetBundle: WidgetBundle{
    @WidgetBundleBuilder
    
    var body : some Widget{
        Widget_Notice()
        Widget_Calendar()
    }
}

