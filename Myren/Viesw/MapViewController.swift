//
//  MapScreen.swift
//  MapKit-Directions
//
//  Created by Sean Allen on 9/1/18.
//  Copyright © 2018 Sean Allen. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import MapKit
import RealmSwift

class DateRealm : Object {
    @objc dynamic var dbStreat: String = ""
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var myMap: MKMapView!
    
    @IBOutlet var reportBtn: UIButton!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var coordiBtn: UIButton!
    
    @IBOutlet var buttonView: UIView!
    
    @IBOutlet var lblspeed: UILabel!
    @IBOutlet var lbl_2: UILabel!
    
    var latitudeData : Double!
    var longitudeData : Double!
    var distanceData : Double!
    var firestLatitude : Double!
    var firstLongtitude : Double!
    
    var addressData : String!
    
    var accident : String = ""
        
//    let dateSelected = DateRealm()
//    let realm = try! Realm()

    let locationManager = CLLocationManager()
    var currentLocation: CLLocation! // 내 위치 저장
    var motionManager = CMMotionManager()
    
    var speed: CLLocationSpeed = CLLocationSpeed()
    var bfSpeed: CLLocationSpeed = CLLocationSpeed()
    var afSpeed: CLLocationSpeed = CLLocationSpeed()
    
    var timer = Timer()
    var data : String = ""
    
    let sdStop : String = "급정거"
    let sdDeparture : String = "급출발"
    let sdDeceleration : String = "급감속"
    let sdAcceleration : String = "급가속"
    let directReport : String = "직접신고"
    let collisionCrash : String = "추돌 ・ 충돌"
    
    @IBAction func navigationButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    @IBAction func reportButton(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "DirectReportViewController") as? DirectReportViewController else { return }
        //vc.data = "직접신고"
        vc.modalPresentationStyle = .fullScreen
        self.dismiss(animated: true) {
        self.tabBarController?.selectedIndex = 1
        }
        
    }
    
    override func viewDidLoad() {
        
        style()
        
        tabBarController?.tabbar()
        navigationController?.naviagation()
        
        reportBtn.isEnabled = true
        naviagationBar()
        myMap.showsCompass = false
        
        let compassBtn = MKCompassButton(mapView: myMap)
        compassBtn.frame = CGRect(x: 350, y: 60, width: 50, height: 50)
        compassBtn.compassVisibility = .visible // compass will always be on map
        //compassBtn.backgroundColor = .black
       
        myMap.addSubview(compassBtn)
        
        buttonView.mapViewShadow()
        buttonView.mapViewBoarder()
        
        reportBtn.layer.cornerRadius = 10
        backBtn.layer.cornerRadius = 10
        
        coordiBtn.locationBtn()
        coordiBtn.mapViewShadow()
        
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        Speed()
        rearSpeed()
        
        locationManager.delegate = self
        // 정확도를 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 데이터를 추적하기 위해 사용자에게 승인 요구
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트를 시작
        locationManager.startUpdatingLocation()
        // 위치 보기 설정
        myMap.showsUserLocation = true
        
        locationManager.startUpdatingLocation()
        //수집시작 (가속도, 자이로센서)
        motionManager.startGyroUpdates(to: OperationQueue.current! , withHandler: {
            (gyroData: CMGyroData!, error: Error!) -> Void in
            self.outputRotationData(gyroData.rotationRate)
            if (error != nil) {
                print("\(String(describing: error))")
            }
        })
        
        //얼마만큼 자주 데이터를 수집할 것인지 설정 (1초애 한번 = 1)
        motionManager.accelerometerUpdateInterval = 0.5
        motionManager.gyroUpdateInterval = 0.5
        //수집시작 (가속도, 자이로센서)
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!
                                                , withHandler: {
            (accelerometerData: CMAccelerometerData!, error: Error!) -> Void in
            self.outputAccelerationData(accelerometerData.acceleration)
            if (error != nil) {
                print("\(String(describing: error))")
            }
        })
        
        let coor = locationManager.location?.coordinate
        
        firestLatitude = coor?.latitude
        firstLongtitude = coor?.longitude
        
        print("\(String(describing: firestLatitude))")
        print("\(String(describing: firstLongtitude))")
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        myMap.showsUserLocation = false
        locationManager.stopUpdatingLocation()
        motionManager.stopGyroUpdates()
        motionManager.stopAccelerometerUpdates()
        timer.invalidate()
        
    }
    @IBAction func crLocationBtn(_ sender: UIButton) {
        myMap.setCenter(myMap.userLocation.coordinate, animated: true)
    }
    
//    func labelFont() {
//        lbl_1.dynamicFont(fontSize: 25, weight: .semibold)
//        lbl_2.dynamicFont(fontSize: 14, weight: .regular)
//        lblspeed.dynamicFont(fontSize: 25, weight: .semibold)
//    }
    
    func style() {
        lblspeed.dynamicFont(fontSize: 25, weight: .semibold)
        lbl_2.dynamicFont(fontSize: 14, weight: .medium)
        
        reportBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        reportBtn.titleLabel?.minimumScaleFactor = 0.5
        reportBtn.sizeToFit()
        
        backBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        backBtn.titleLabel?.minimumScaleFactor = 0.5
        backBtn.sizeToFit()
        
    }
    
    func naviagationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.image = UIImage(named: "leftarrow_icon")
        backBarButtonItem.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func goLocation(latitudeValue: CLLocationDegrees, longtudeValue: CLLocationDegrees,
                    delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        myMap.setRegion(pRegion, animated: true)
        
        return pLocation
    }
    
    func outputAccelerationData(_ acceleration: CMAcceleration) {
        
//        var Ax = acceleration.x
//                var Ay = acceleration.y
//               var Az = acceleration.z
//
//               print("가속도 : x = \(Ax)")
//               print("가속도 : y = \(Ay)")
//               print("가속도 : z = \(Az)")
//
//               let total = 1.5
//                if (Ax >= total || Ax >= total) && (Ay <= total || Ay <= -total) && (Az >= total || Az <= -total){
//                   actionReportbtn((Any).self)
//               }
    }
    
    func disEnable() {
        self.tabBarController?.tabBar.items?[0].isEnabled = true
        self.tabBarController?.tabBar.items?[1].isEnabled = false
        self.tabBarController?.tabBar.items?[2].isEnabled = false
    }
    
    func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
            let from = CLLocation(latitude: firestLatitude, longitude: firstLongtitude)
            let to = CLLocation(latitude: latitudeData, longitude: longitudeData)
            var distance = from.distance(from: to)
            
            distanceData = distance
            return distance
        }
    
    func outputRotationData(_ rotation: CMRotationRate) {

        let Rx = rotation.x
        let Ry = rotation.y
        let Rz = rotation.z

                print("자이로 : x = \(Rx)")
                print("자이로 : y = \(Ry)")
                print("자이로 : z = \(Rz)")
                print("======================================")
                print("======================================")
                print("======================================")
        
        let total = 1.5                    
        if (Rx >= total || Rx >= total) && (Ry <= total || Ry <= -total) && (Rz >= total || Rz <= -total){
            
            guard let vc = self.storyboard?.instantiateViewController(identifier: "ReportViewController") as? ReportViewController else { return }
            vc.addressData = addressData
            vc.latitudeData = "\(String(describing: latitudeData))"
            vc.longitudeData = "\(String(longitudeData))"
            vc.distanceData = "\(String(distanceData))"
            vc.data = "충돌 감지"
            disEnable()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            self.dismiss(animated: true)
        }
}

    func Speed() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            guard let userSpeed = self.locationManager.location?.speed else { return }
            self.speed = userSpeed * 3.6
            if self.speed < 0 { self.speed = 0 }
            self.lblspeed.text = String(format: "현재 시속 %.0fkm/h", self.speed)     //현재속도
            //print("speed : \(self.speed)")
            
        }
        
    }

    func rearSpeed() {
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { timer in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                guard let userSpeed = self.locationManager.location?.speed else { return }
                self.bfSpeed = userSpeed * 3.6
                if self.bfSpeed < 0 { self.bfSpeed = 0 }
                print("bfspeed : \(self.bfSpeed)")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.0) { [self] in
                   
                guard let afuserSpeed = self.locationManager.location?.speed else { return }
                afSpeed = afuserSpeed * 3.6
                if afSpeed < 0 { afSpeed = 0 }
                print("afSpeed : \(afSpeed)")
                if (self.bfSpeed >= 20) && (afSpeed <= 5){
    
                    print("사고내역 : 급정거")
                    guard let vc = self.storyboard?.instantiateViewController(identifier: "ReportViewController") as? ReportViewController else { return }
                    vc.addressData = addressData
                    vc.data = "급정거"
                    vc.modalPresentationStyle = .fullScreen
                    navigationController?.pushViewController(vc, animated: true)
                    disEnable()
                } else if (self.bfSpeed >= 30) && ((self.bfSpeed - afSpeed) >= 15){

                    print("사고내역 : 급감속")
                    guard let vc = self.storyboard?.instantiateViewController(identifier: "ReportViewController") as? ReportViewController else { return }
                    vc.addressData = addressData
                    vc.data = "급감속"
                    vc.modalPresentationStyle = .fullScreen
                    navigationController?.pushViewController(vc, animated: true)
                    disEnable()
                } else if (self.bfSpeed <= 5 && afSpeed >= 15){
                        
                    print("사고내역 : 급출발")
                        
                    guard let vc = self.storyboard?.instantiateViewController(identifier: "ReportViewController") as? ReportViewController else { return }
                    vc.addressData = addressData
                    vc.data = "급출발"
                    vc.modalPresentationStyle = .fullScreen
                    navigationController?.pushViewController(vc, animated: true)
                    disEnable()
                } else if(self.bfSpeed >= 10 && (afSpeed - self.bfSpeed) >= 15){
                        
                    print("사고내역 : 급가속")
                    
                    guard let vc = self.storyboard?.instantiateViewController(identifier: "ReportViewController") as? ReportViewController else { return }
                    vc.addressData = addressData
                    vc.data = "급가속"
                    vc.modalPresentationStyle = .fullScreen
                    navigationController?.pushViewController(vc, animated: true)
                    disEnable()
                }
            }
        }
    } //출력 두번 전송 = return 부여
     
        
        
    // 위치 정보에서 국가, 지역, 도로를 추출하여 레이블에 표시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!,
                        longtudeValue: (pLocation?.coordinate.longitude)!,
                        delta: 0.01)
        
        //print("didUpdateLocations")
        if let location = locations.first {
//            print("위도: \(location.coordinate.latitude)")
//            print("경도: \(location.coordinate.longitude)")
            
            self.latitudeData = location.coordinate.latitude
            self.longitudeData = location.coordinate.longitude
            
            let location: CLLocation = locations[locations.count - 1]
            let longitude: CLLocationDegrees = location.coordinate.longitude
            let latitude: CLLocationDegrees = location.coordinate.latitude
            
            let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            let geoCoder: CLGeocoder = CLGeocoder()
            let local: Locale = Locale(identifier: "Ko-kr") // Korea
            geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
                if let address: [CLPlacemark] = place {
                    
//                    print("시(도): \(String(describing: address.last?.administrativeArea))")
//                    print("구(군): \(String(describing: address.last?.locality))")
//                    print("지역(동): \(String(describing: address.last?.thoroughfare))")
//                    print("지역(동): \(String(describing: address.last?.subThoroughfare))")
                    
                    self.addressData = "\(String((address.last?.country)!)) " + "\(String((address.last?.administrativeArea)!)) " + "\(String((address.last?.locality)!))  "
                    //+ "\(String((address.last?.thoroughfare)! )) "
                    //+ "\(String((address.last?.subThoroughfare)!))"
                }
            }
        }

    }
}



extension UIView {
    func mapViewShadow() {
        // subview 그림자
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowPath = nil
        
    }
    func mapViewBoarder() {
        // subview 테투리
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.827, green: 0.82, blue: 0.82, alpha: 1).cgColor
    }
}

extension UIButton {
    func locationBtn() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowPath = nil

    }
}


extension UIButton {
    @IBInspectable var adjustFontSizeToWidth: Bool {
        get {
            return ((self.titleLabel?.adjustsFontSizeToFitWidth) != nil)
        }
        set {
            self.titleLabel?.numberOfLines = 1
            self.titleLabel?.adjustsFontSizeToFitWidth = newValue;
            self.titleLabel?.lineBreakMode = .byClipping;
            self.titleLabel?.baselineAdjustment = .alignCenters
        }
    }
}
