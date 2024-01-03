//
//  QRScannerViewModel.swift
//  QRScannerViewModel
//
//  Created by 하창진 on 2021/08/17.
//

import Foundation

class QRScannerViewModel : ObservableObject{
    let scanInterval : Double = 1.0
    @Published var flashON = false
    @Published var lastQRCode = ""
    
    func onFoundQRCode(_ code : String){
        self.lastQRCode = code
    }
}
