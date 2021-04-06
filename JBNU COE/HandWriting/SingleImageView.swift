//
//  SingleImageView.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/03/22.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct SingleImageView: View {
    @Binding var url : URL?
    @State var lastScaleValue: CGFloat = 1.0
    @State var scale : CGFloat = 1.0
    var aspectRatio: Binding<CGFloat>?
    @State var dragOffset: CGSize = CGSize.zero
    @State var dragOffsetPredicted: CGSize = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView{
            VStack{
                WebImage(url: url)
                    .resizable()
                    .scaleEffect(scale)
                    .aspectRatio(self.aspectRatio?.wrappedValue, contentMode: .fit)
                    .offset(x: self.dragOffset.width, y: self.dragOffset.height)
                    .rotationEffect(.init(degrees: Double(self.dragOffset.width / 30)))
                    .pinchToZoom()
                    .gesture(DragGesture()
                                .onChanged { value in
                                    self.dragOffset = value.translation
                                    self.dragOffsetPredicted = value.predictedEndTranslation
                                }
                                .onEnded { value in
                                    if((abs(self.dragOffset.height) + abs(self.dragOffset.width) > 570) || ((abs(self.dragOffsetPredicted.height)) / (abs(self.dragOffset.height)) > 3) || ((abs(self.dragOffsetPredicted.width)) / (abs(self.dragOffset.width))) > 3) {
                                        
                                        return
                                    }
                                    
                                    self.dragOffset = .zero
                                }
                    )
            }.navigationBarTitleDisplayMode(.inline)
            
            .navigationBarItems(leading : Button("닫기"){
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
