//
//  Privacy.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/02/24.
//

import SwiftUI

struct Privacy: View {
    @ObservedObject var license: loadLicense

    var body: some View {
        ScrollView{
            VStack{
                Text(license.license)
            }
        }.navigationBarTitle("개인정보 처리 방침")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}
