//
//  MapViewController.swift
//  JBNU COE
//
//  Created by 하창진 on 2021/01/15.
//

import Foundation
import UIKit
import NMapsMap
import FirebaseFirestore
import CoreLocation
import Combine

class MapViewController : UIViewController, CLLocationManagerDelegate{
    var storeList : [String] = []
    static var mapView : NMFMapView!
    var locationList : [String : String] = [:]
    var category : String = ""
    var marker = NMFMarker()
    var markerList : [NMFMarker] = []
    var i = 0
    var campusList : [NMFMarker] = []
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapViewController.mapView = NMFMapView(frame: view.frame)
        
        requestPermission()
                
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.84697588595311,
                                                                   lng: 127.12936719828784))
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        cameraUpdate.reason = 1000
            
        MapViewController.mapView.moveCamera(cameraUpdate)
        
        MapViewController.mapView.positionMode = .direction
        
        MapViewController.mapView.logoInteractionEnabled = true
        MapViewController.mapView.logoAlign = .leftTop
        
        view.addSubview(MapViewController.mapView)
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
    
    func setValue(category : String){
        print("viewcontroller", category)
    }
    
    func getAllianceList(category : String){
        db = Firestore.firestore()
        self.category = category
        
        if category == "All"{
            getAllAllianceList()
        }
        
        if category != "All"{
            let docRef = db.collection("Coalition").document(category)
            docRef.getDocument() { (document, error) in
                if let document = document {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    self.storeList.append(contentsOf: Array(document.data()!.keys))

                    
                    for i in 0..<self.storeList.count{
                        self.loadLocation(storeName: self.storeList[i])
                    }
                    
                    
                } else {
                    print("Document does not exist in cache")
                    print(category)
                    print(error)
                }
            }
        }
    }
    
    func getAllAllianceList(){
        db = Firestore.firestore()
        
        db.collection("Coalition").getDocuments(){ (querySnapshot, err) in
            if let err = err{
                print(err)
            }
            
            else{
                for document in querySnapshot!.documents{
                    var storeList : [String] = []
                    
                    self.storeList.append(contentsOf: Array(document.data().keys))
                    
                    print("document key : ", document.data().keys);
                    print(document.documentID , "->", document.data())
                    storeList.append(contentsOf: document.data().keys)
                    
                    for i in 0..<storeList.count{
                        self.loadAllLocation(storeName: storeList[i])
                    }
                }
            }
        }
    }
    
    func loadLocation(storeName : String){
        let locationRef = db.collection("location").document(storeName)
        
        locationRef.getDocument(){(document, err) in
            if let document = document{
                self.locationList.updateValue(document.get("location") as! String, forKey: storeName)
                
                self.setMarker(storeName: storeName, loc: document.get("location") as! String)
            }
        }
    }
    
    func loadAllLocation(storeName : String){
        let locationRef = db.collection("location").document(storeName)
        
        locationRef.getDocument(){(document, err) in
            if let document = document{
                self.locationList.updateValue(document.get("location") as! String, forKey: storeName)
                
                self.setMarker(storeName: storeName, loc: document.get("location") as! String)
            }
        }
    }
    
    func setMarker(storeName : String, benefits : String){
        let locationRef = db.collection("location").document(storeName)
        
        locationRef.getDocument(){ [self](document, err) in
            if let document = document{
                
                var loc = document.get("location") as! String
                
                var loc_split = loc.components(separatedBy: ", ")
                var lat = loc_split[0]
                var lng = loc_split[1]
                
                var lat_tmp = lat.components(separatedBy: "Optional(")
                var lat_tmptmp = lat_tmp[0].components(separatedBy: ")")
                var lat_fin = Double(lat_tmptmp[0])
                
                var lng_tmp = lng.components(separatedBy: "Optional(")
                var lng_tmptmp = lng_tmp[0].components(separatedBy: ")")
                var lng_fin = Double(lng_tmptmp[0])
                
                marker.position = NMGLatLng(lat: lat_fin!, lng: lng_fin!)
                marker.iconPerspectiveEnabled = true
                marker.captionText = storeName
                marker.subCaptionText = benefits
                marker.subCaptionColor = UIColor.blue
                marker.mapView = MapViewController.mapView
            }
        }
    }
    
    func setMarker(storeName : String, loc : String){
        var loc_split = loc.components(separatedBy: ", ")
        var lat = loc_split[0]
        var lng = loc_split[1]
        
        var lat_tmp = lat.components(separatedBy: "Optional(")
        var lat_tmptmp = lat_tmp[0].components(separatedBy: ")")
        var lat_fin = Double(lat_tmptmp[0])
        
        var lng_tmp = lng.components(separatedBy: "Optional(")
        var lng_tmptmp = lng_tmp[0].components(separatedBy: ")")
        var lng_fin = Double(lng_tmptmp[0])
        
        DispatchQueue.global(qos: .default).async{
            var markers =  [NMFMarker]()
            
            for index in 0...self.storeList.count{
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: lat_fin!, lng: lng_fin!)
                marker.captionText = storeName
                markers.append(marker)
            }
            
            DispatchQueue.main.async{[weak self] in
                for marker in markers{
                    marker.mapView = MapViewController.mapView
                }
            }
        }
    }
    
    func loadBenefits(storeName : String){
        
        var benefit : String = ""
        var benefitDictionary: Any?
        
        db = Firestore.firestore()
        
        let docRef = db.collection("Coalition").document(category)
        
        docRef.getDocument(){(document, error) in
            if let document = document{
                let benefit_db = document.data()?[storeName] as? String ?? "준비 중입니다."
                benefitDictionary = document.data()?[storeName] as! [String : Any]
                
                let s = String(describing: benefitDictionary)
                var split_Str = s.components(separatedBy: "Optional([\"benefits\":")
                var final_Str = split_Str[1].components(separatedBy: "])")
                self.setBenefits(benefit : final_Str[0], storeName: storeName)
            }
        }
        
    }
    
    func setBenefits(benefit: String, storeName : String){
        var benefits = [String : String]()
        
        benefits.updateValue(benefit, forKey: storeName)
        
    }
}
