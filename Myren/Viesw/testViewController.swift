//
//  testViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/11/28.
//

import UIKit
import MapKit
import CoreLocation

class testViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation! // 내 위치 저장
    
    var addresData : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        
        myMap.showsUserLocation = true
        myMap.setUserTrackingMode(.follow, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.delegate = self
        // 정확도를 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 데이터를 추적하기 위해 사용자에게 승인 요구
        locationManager.requestWhenInUseAuthorization()
        
        myMap.showsUserLocation = true
        
        //locationManager.startUpdatingLocation()
        
        
    }
    private func initView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedMapView(_:)))
        self.myMap.addGestureRecognizer(tap)
    }
    
}

//
// MARK:- 맵을 터치 했을 때
//

extension testViewController {
    
    /// 제스처 조작
    @objc private func didTappedMapView(_ sender: UITapGestureRecognizer) {
        let location: CGPoint = sender.location(in: self.myMap)
        let mapPoint: CLLocationCoordinate2D = self.myMap.convert(location, toCoordinateFrom: self.myMap)
        
        if sender.state == .ended {
            self.searchLocation(mapPoint)
            myMap.setCenter(mapPoint, animated: true)
        }
    }
    
    
    /// 하나만 출력하기 위하여 모든 포인트를 삭제
    private func removeAllAnnotations() {
        let allAnnotations = self.myMap.annotations
        self.myMap.removeAnnotations(allAnnotations)
    }
    
    
    // 위도와 경도, 스팬(영역 폭)을 입력받아 지도에 표시
    private func goLocation(latitudeValue: CLLocationDegrees,
                       longtudeValue: CLLocationDegrees,
                       delta span: Double) -> CLLocationCoordinate2D {
           let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
           let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
           let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
            myMap.setRegion(pRegion, animated: true)
           return pLocation
       }
    
    // 위치 정보에서 국가, 지역, 도로를 추출하여 레이블에 표시
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!,
                    longtudeValue: (pLocation?.coordinate.longitude)!,
                    delta: 0.01)
    }
    
    private func setAnnotation(latitudeValue: CLLocationDegrees,
                           longitudeValue: CLLocationDegrees,
                           delta span :Double,
                           title strTitle: String,
                           subtitle strSubTitle:String){
            let annotation = MKPointAnnotation()
            annotation.coordinate = goLocation(latitudeValue: latitudeValue, longtudeValue: longitudeValue, delta: 0.1)
            annotation.title = strTitle
            annotation.subtitle = strSubTitle
            myMap.addAnnotation(annotation)
        
    }
    
    /// 해당 포인트의 주소를 검색
    private func searchLocation(_ point: CLLocationCoordinate2D) {
        let geocoder: CLGeocoder = CLGeocoder()
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)
        
        // 포인트 리셋
        self.removeAllAnnotations()
        
        geocoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            if error == nil, let marks = placeMarks {
                marks.forEach { (placeMark) in
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                    
                    self.locationLabel.text =
                    "\(placeMark.administrativeArea ?? "")" + "\(placeMark.locality ?? "")" + "\(placeMark.thoroughfare ?? "")"
                    + "\(placeMark.subThoroughfare ?? "")"
                    
                    self.myMap.addAnnotation(annotation)
                }
            } else {
                self.locationLabel.text = "검색 실패"
            }
        }
    }
}
