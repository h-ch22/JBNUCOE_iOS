//
//  CampusMapViewController.swift
//  JBNU COE
//
//  Created by Changjin Ha on 2021/02/25.
//

import Foundation
import SwiftUI
import UIKit
import NMapsMap
import CoreLocation

class CampusMapViewController : UIViewController, CLLocationManagerDelegate{
    static var mapView : NMFMapView!
    let manager = CLLocationManager()
    let marker_1st = NMFMarker(position: NMGLatLng(lat: 35.846603, lng: 127.132516))
    let marker_2nd = NMFMarker(position : NMGLatLng(lat: 35.84674036906721, lng: 127.13163697267295))
    let marker_3rd = NMFMarker(position : NMGLatLng(lat: 35.84694685101836, lng: 127.13354746193421))
    let marker_4th = NMFMarker(position : NMGLatLng(lat: 35.847528438957795, lng: 127.13274930197618))
    let marker_5th = NMFMarker(position : NMGLatLng(lat: 35.84751123227527, lng: 127.13142894162004))
    let marker_6th = NMFMarker(position : NMGLatLng(lat: 35.84700879549727, lng: 127.13437109512583))
    let marker_7th = NMFMarker(position : NMGLatLng(lat: 35.846041767811116, lng: 127.13428193896029))
    let marker_8th = NMFMarker(position : NMGLatLng(lat: 35.84822358581627, lng: 127.13352198881267))
    let marker_9th = NMFMarker(position : NMGLatLng(lat: 35.84764200298654, lng: 127.13378521177964))
    let marker_jeongdamwon = NMFMarker()
    let marker_hoosanggwan = NMFMarker()
    let marker_jinsoodang = NMFMarker()
    let marker_libraryCU = NMFMarker()
    let marker_enginerringCU = NMFMarker()
    let marker_jeongdamwonCU = NMFMarker()
    let marker_haksangCU = NMFMarker()
    let marker_fountainCafe = NMFMarker()
    let marker_CafeBene = NMFMarker()
    let marker_jinsoodangCafe = NMFMarker()
    let marker_silkroadCafe = NMFMarker()
    let marker_bookStore = NMFMarker()
    let marker_postoffice = NMFMarker()
    let marker_haksang1 = NMFMarker()
    let marker_haksang2 = NMFMarker()
    let marker_hoosangCafe = NMFMarker()
    let marker_learnLibrary = NMFMarker()
    let marker_learnLibraryCU = NMFMarker()
    let marker_library = NMFMarker()
    let marker_council = NMFMarker()
    let infoWindow = NMFInfoWindow()
    var defaultDataSource = NMFInfoWindowDefaultTextSource.data()
    
    var status_fin = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CampusMapViewController.mapView = NMFMapView(frame: view.frame)
        
        requestPermission()
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.84697588595311,
                                                               lng: 127.12936719828784))
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        cameraUpdate.reason = 1000
        
        CampusMapViewController.mapView.moveCamera(cameraUpdate)
        
        CampusMapViewController.mapView.positionMode = .direction
        
        CampusMapViewController.mapView.logoInteractionEnabled = true
        CampusMapViewController.mapView.logoAlign = .leftTop
        
        let handler = {[weak self] (overlay : NMFOverlay) -> Bool in
            if let marker = overlay as? NMFMarker{
                self?.infoWindow.close()
                self?.defaultDataSource.title = marker.userInfo["tag"] as! String
                self?.infoWindow.open(with: self!.marker_1st)
            }
            
            return true
        }
        
        marker_1st.captionText = "공대 1호관".localized()
        marker_1st.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_1st.iconTintColor = UIColor.red
        marker_1st.captionColor = UIColor.red
        marker_1st.userInfo = ["tag" : "1호관"]
        marker_1st.touchHandler = handler

        marker_1st.mapView = CampusMapViewController.mapView
        
        marker_2nd.captionText = "공대 2호관".localized()
        marker_2nd.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_2nd.iconTintColor = UIColor.systemPink
        marker_2nd.captionColor = UIColor.systemPink
        marker_2nd.mapView = CampusMapViewController.mapView
        
        marker_3rd.captionText = "공대 3호관".localized()
        marker_3rd.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_3rd.iconTintColor = UIColor.orange
        marker_3rd.captionColor = UIColor.orange
        marker_3rd.mapView = CampusMapViewController.mapView
        
        marker_4th.captionText = "공대 4호관".localized()
        marker_4th.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_4th.iconTintColor = UIColor.systemYellow
        marker_4th.captionColor = UIColor.systemYellow
        marker_4th.mapView = CampusMapViewController.mapView
        
        marker_5th.captionText = "공대 5호관".localized()
        marker_5th.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_5th.iconTintColor = UIColor.green
        marker_5th.captionColor = UIColor.green
        marker_5th.mapView = CampusMapViewController.mapView
        
        marker_6th.captionText = "공대 6호관".localized()
        marker_6th.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_6th.iconTintColor = UIColor.blue
        marker_6th.captionColor = UIColor.blue
        marker_6th.mapView = CampusMapViewController.mapView
        
        marker_7th.captionText = "공대 7호관".localized()
        marker_7th.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_7th.iconTintColor = UIColor.purple
        marker_7th.captionColor = UIColor.purple
        marker_7th.mapView = CampusMapViewController.mapView
        
        marker_8th.captionText = "공대 8호관".localized()
        marker_8th.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_8th.iconTintColor = UIColor.gray
        marker_8th.captionColor = UIColor.gray
        marker_8th.mapView = CampusMapViewController.mapView
        
        marker_9th.captionText = "공대 9호관".localized()
        marker_9th.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_9th.iconTintColor = UIColor.black
        marker_9th.captionColor = UIColor.black
        marker_9th.mapView = CampusMapViewController.mapView
        
        marker_jeongdamwon.position = NMGLatLng(lat: 35.8444444, lng: 127.130381)
        marker_jeongdamwon.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_jeongdamwon.captionText = "정담원 (9층)"
        marker_jeongdamwon.iconTintColor = UIColor.darkGray
        marker_jeongdamwon.captionColor = UIColor.darkGray
        marker_jeongdamwon.mapView = CampusMapViewController.mapView
        
        marker_hoosanggwan.position = NMGLatLng(lat: 35.847622, lng: 127.134277)
        marker_hoosanggwan.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_hoosanggwan.captionText = "후생관"
        marker_hoosanggwan.iconTintColor = UIColor.darkGray
        marker_hoosanggwan.captionColor = UIColor.darkGray
        marker_hoosanggwan.mapView = CampusMapViewController.mapView
        
        marker_jinsoodang.position = NMGLatLng(lat: 35.845103, lng: 127.131508)
        marker_jinsoodang.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_jinsoodang.captionText = "진수당 (2층)"
        marker_jinsoodang.iconTintColor = UIColor.darkGray
        marker_jinsoodang.captionColor = UIColor.darkGray
        marker_jinsoodang.mapView = CampusMapViewController.mapView
        
        marker_libraryCU.position = NMGLatLng(lat: 35.848066, lng: 127.131562)
        marker_libraryCU.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_libraryCU.captionText = "중앙도서관 CU"
        marker_libraryCU.iconTintColor = UIColor.link
        marker_libraryCU.captionColor = UIColor.link
        marker_libraryCU.mapView = CampusMapViewController.mapView
        
        marker_haksangCU.position = NMGLatLng(lat: 35.84577388335406, lng:  127.1284092844406)
        marker_haksangCU.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_haksangCU.captionText = "학생회관 CU"
        marker_haksangCU.iconTintColor = UIColor.link
        marker_haksangCU.captionColor = UIColor.link
        marker_haksangCU.mapView = CampusMapViewController.mapView
        
        marker_enginerringCU.position = NMGLatLng(lat: 35.846795745359074, lng: 127.13256670847532)
        marker_enginerringCU.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_enginerringCU.captionText = "공대 CU / 복사집"
        marker_enginerringCU.iconTintColor = UIColor.link
        marker_enginerringCU.captionColor = UIColor.link
        marker_enginerringCU.mapView = CampusMapViewController.mapView
        
        marker_jeongdamwonCU.position = NMGLatLng(lat: 35.845200, lng: 127.131508)
        marker_jeongdamwonCU.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_jeongdamwonCU.captionText = "법대 CU"
        marker_jeongdamwonCU.iconTintColor = UIColor.link
        marker_jeongdamwonCU.captionColor = UIColor.link
        marker_jeongdamwonCU.mapView = CampusMapViewController.mapView
        
        marker_learnLibraryCU.position = NMGLatLng(lat: 35.8474045079655, lng:  127.13559224021542)
        marker_learnLibraryCU.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_learnLibraryCU.captionText = "학습도서관 CU"
        marker_learnLibraryCU.iconTintColor = UIColor.link
        marker_learnLibraryCU.captionColor = UIColor.link
        marker_learnLibraryCU.mapView = CampusMapViewController.mapView
        
        marker_CafeBene.position = NMGLatLng(lat: 35.84440848120266, lng: 127.13027610192006)
        marker_CafeBene.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_CafeBene.captionText = "카페베네 (4층)"
        marker_CafeBene.iconTintColor = UIColor.brown
        marker_CafeBene.captionColor = UIColor.brown
        marker_CafeBene.mapView = CampusMapViewController.mapView
        
        marker_silkroadCafe.position = NMGLatLng(lat:35.844651994131475, lng: 127.13037266144602)
        marker_silkroadCafe.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_silkroadCafe.captionText = "실크로드 카페"
        marker_silkroadCafe.iconTintColor = UIColor.brown
        marker_silkroadCafe.captionColor = UIColor.brown
        marker_silkroadCafe.mapView = CampusMapViewController.mapView
        
        marker_jinsoodangCafe.position = NMGLatLng(lat: 35.84544775438156, lng: 127.13109685789078)
        marker_jinsoodangCafe.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_jinsoodangCafe.captionText = "진수당 카페"
        marker_jinsoodangCafe.iconTintColor = UIColor.brown
        marker_jinsoodangCafe.captionColor = UIColor.brown
        marker_jinsoodangCafe.mapView = CampusMapViewController.mapView
        
        marker_fountainCafe.position = NMGLatLng(lat: 35.84711317215268, lng: 127.12881698021691)
        marker_fountainCafe.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_fountainCafe.captionText = "분수대 카페"
        marker_fountainCafe.iconTintColor = UIColor.brown
        marker_fountainCafe.captionColor = UIColor.brown
        marker_fountainCafe.mapView = CampusMapViewController.mapView
        
        marker_hoosangCafe.position = NMGLatLng(lat: 35.847643663419845, lng: 127.13466956032488)
        marker_hoosangCafe.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_hoosangCafe.captionText = "후생관 카페"
        marker_hoosangCafe.iconTintColor = UIColor.brown
        marker_hoosangCafe.captionColor = UIColor.brown
        marker_hoosangCafe.mapView = CampusMapViewController.mapView
        
        marker_postoffice.position = NMGLatLng(lat: 35.84631308026555, lng: 127.12855412372954)
        marker_postoffice.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_postoffice.captionText = "우체국"
        marker_postoffice.iconTintColor = UIColor.systemIndigo
        marker_postoffice.captionColor = UIColor.systemIndigo
        marker_postoffice.mapView = CampusMapViewController.mapView
        
        marker_bookStore.position = NMGLatLng(lat: 35.84586954758972, lng: 127.12816252120756)
        marker_bookStore.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_bookStore.captionText = "교보문고"
        marker_bookStore.iconTintColor = UIColor.systemIndigo
        marker_bookStore.captionColor = UIColor.systemIndigo
        marker_bookStore.mapView = CampusMapViewController.mapView
        
        marker_haksang1.position = NMGLatLng(lat: 35.8456347351689, lng: 127.12822152980677)
        marker_haksang1.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_haksang1.captionText = "제 1 학생회관"
        marker_haksang1.iconTintColor = UIColor.systemIndigo
        marker_haksang1.captionColor = UIColor.systemIndigo
        marker_haksang1.mapView = CampusMapViewController.mapView
        
        marker_haksang2.position = NMGLatLng(lat: 35.846147842891945, lng: 127.12863459000118)
        marker_haksang2.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_haksang2.captionText = "제 2 학생회관"
        marker_haksang2.iconTintColor = UIColor.systemIndigo
        marker_haksang2.captionColor = UIColor.systemIndigo
        marker_haksang2.mapView = CampusMapViewController.mapView
        
        marker_learnLibrary.position = NMGLatLng(lat: 35.84748712538619, lng: 127.1354205788359)
        marker_learnLibrary.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_learnLibrary.captionText = "학습도서관"
        marker_learnLibrary.iconTintColor = UIColor.systemIndigo
        marker_learnLibrary.captionColor = UIColor.systemIndigo
        marker_learnLibrary.mapView = CampusMapViewController.mapView
        
        marker_library.position = NMGLatLng(lat: 35.84821763358062, lng: 127.13157965549078)
        marker_library.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_library.captionText = "중앙도서관"
        marker_library.iconTintColor = UIColor.systemIndigo
        marker_library.captionColor = UIColor.systemIndigo
        marker_library.mapView = CampusMapViewController.mapView
        
        marker_council.position = NMGLatLng(lat: 35.846621812331634, lng:  127.13307632814308)
        marker_council.iconImage = NMF_MARKER_IMAGE_BLACK
        marker_council.captionText = "공과대학 학생회실 (243호)"
        marker_council.iconTintColor = UIColor.systemIndigo
        marker_council.captionColor = UIColor.systemIndigo
        marker_council.mapView = CampusMapViewController.mapView
        
        view.addSubview(CampusMapViewController.mapView)
    }
    
    func requestPermission(){
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
            return
            
        case .denied, .restricted:
            let alert = UIAlertController(title: "위치 서비스 비활성화됨", message: "정확한 현재 위치 표시를 위해 위치 서비스를 켜주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
            
        }
        
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func addMarker(type : String){

    }
}
