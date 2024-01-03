//
//  QRScannerView.swift
//  QRScannerView
//
//  Created by 하창진 on 2021/08/17.
//

import SwiftUI

struct QRScannerView: View {
    @ObservedObject var model = QRScannerViewModel()
    @State private var fullScreenModel : FullScreenModel?
    
    var body: some View {
        ZStack{
            QRCameraView()
                .found(r: self.model.onFoundQRCode)
                .torchLight(isOn: self.model.flashON)
                .interval(delay : self.model.scanInterval)
            
            VStack{
                VStack{
                    Text("제휴 업체의 QR코드를 인식시켜주세요!")
                        .fontWeight(.semibold)
                    
                    Text(self.model.lastQRCode)
                        .bold()
                        .lineLimit(5)
                        .padding()
                        .onChange(of: model.lastQRCode){newValue in
                            if model.lastQRCode == "건어물을 굽는 남자들"{
                                fullScreenModel = .success
                            }
                            
                            else{
                                fullScreenModel = .fail
                            }
                        }

                    
                }.padding(20)
                
                Spacer()
                
                HStack{
                    Button(action: {
                        self.model.flashON.toggle()
                    }){
                        Image(systemName : self.model.flashON ? "bolt.fill" : "bolt.slash.fill")
                            .imageScale(.large)
                            .foregroundColor(self.model.flashON ? Color.yellow : Color.blue)
                            .padding()
                    }
                }.background(Color.background_button)
                    .cornerRadius(10)
            }.padding()
                .fullScreenCover(item: $fullScreenModel){item in
                    switch item{
                    case .success:
                        QR_Success(storeName: $model.lastQRCode, time: Date()).environmentObject(UserManagement())
                        
                    case .fail:
                        QR_Fail()
                    }
                }
                .navigationBarTitle("QR 체크인", displayMode: .inline)
        }
    }
}

struct QRScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRScannerView()
    }
}
