//
//  QRCameraDelegate.swift
//  QRCameraDelegate
//
//  Created by 하창진 on 2021/08/17.
//

import Foundation
import AVFoundation

class QRCameraDelegate : NSObject, AVCaptureMetadataOutputObjectsDelegate{
    var scanInterval : Double = 1.0
    var lastTime = Date(timeIntervalSince1970: 0)
    var onResult : (String) -> Void = {_ in }
    var mockData : String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first{
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else{return}
            guard let stringValue = readableObject.stringValue else {return}
            foundBarCode(stringValue)
        }
    }
    
    @objc func onSimulateScanning(){
        foundBarCode(mockData ?? "Simulate QR-Code result.")
    }
    
    func foundBarCode(_ stringValue : String){
        print("qr found")
        let now = Date()
        if now.timeIntervalSince(lastTime) >= scanInterval{
            lastTime = now
            self.onResult(stringValue)
        }
    }
}
