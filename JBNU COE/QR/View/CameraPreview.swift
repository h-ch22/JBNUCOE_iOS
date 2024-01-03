//
//  CameraPreview.swift
//  CameraPreview
//
//  Created by 하창진 on 2021/08/17.
//

import UIKit
import AVFoundation

class CameraPreview : UIView{
    private var label : UILabel?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var session = AVCaptureSession()
    weak var delegate : QRCameraDelegate?
    
    init(session : AVCaptureSession){
        super.init(frame : .zero)
        self.session = session
    }
    
    required init?(coder : NSCoder){
        fatalError("카메라를 초기화할 수 없습니다.")
    }
    
    func createSimulatorView(delegate: QRCameraDelegate){
        self.delegate = delegate
        self.backgroundColor = UIColor.black
        label = UILabel(frame: self.bounds)
        label?.numberOfLines = 4
        label?.text = "QR코드를 스캔하려면 터치하세요."
        label?.textColor = UIColor.white
        label?.textAlignment = .center
        if let label = label {
            addSubview(label)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func onClick(){
        delegate?.onSimulateScanning()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        #if targetEnvironment(simulator)
            label?.frame = self.bounds
        #else
            previewLayer?.frame = self.bounds
        #endif
    }
}
