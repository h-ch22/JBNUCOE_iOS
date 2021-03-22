//
//  SportsMapViewController.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/22.
//

import Foundation
import UIKit
import NMapsMap
import CoreLocation

class SportsMapViewController : UIViewController, CLLocationManagerDelegate{
    static var mapView : NMFMapView!
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        SportsMapViewController.mapView = NMFMapView(frame: view.frame)
        requestPermission()

        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.84697588595311,
                                                                   lng: 127.12936719828784))
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        cameraUpdate.reason = 1000
            
        SportsMapViewController.mapView.moveCamera(cameraUpdate)
        
        SportsMapViewController.mapView.positionMode = .direction

        view.addSubview(SportsMapViewController.mapView)
        
    }
    
    func requestPermission(){
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .notDetermined:
                manager.requestWhenInUseAuthorization()

                return

        case .denied, .restricted:
            let alert = UIAlertController(title: "위치 서비스 비활성화됨".localized(), message: "정확한 현재 위치 표시를 위해 위치 서비스를 켜주세요.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인".localized(), style: .default, handler: nil)
            alert.addAction(okAction)

            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break

        }

        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("지도 탭 : ", latlng as! String)
    }

    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        if symbol.caption == "서울특별시청" {
            print("서울시청 탭")
            return true

        } else {
            print("symbol 탭")
            return false
        }
    }
}
