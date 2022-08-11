//
//  DirectReportViewController.swift
//  Pods
//
//  Created by 장준명 on 2022/11/02.
//

import UIKit
import MapKit
import CoreMotion
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseAuth

class DirectReportViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var myMap: MKMapView!
    
    @IBOutlet var directView: UIView!
    
    @IBOutlet var checkOne: UIButton!
    @IBOutlet var checkTwo: UIButton!
    @IBOutlet var checkThree: UIButton!
    
    @IBOutlet var checkOneOn: UIButton!
    @IBOutlet var checkTwoOn: UIButton!
    @IBOutlet var checkThreeOn: UIButton!
    
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var navigationBtn: UIBarButtonItem!
    
    @IBOutlet var lblCA: UILabel!   // 접촉 사고 lbl
    @IBOutlet var lblCrash: UILabel!    //충돌사고 lbl
    @IBOutlet var lblPA: UILabel!       //대인사고 lbl
    
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var directReport: UIButton!
    
    @IBOutlet var lbl_1: UILabel!
    @IBOutlet var lbl_2: UILabel!
    
    var data : String!
    var latitudeData : String!
    var longitudeData : String!
    var timeData : String!
    var addresData : String!
    
    var ref: DatabaseReference!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation! // 내 위치 저장
    
    let now = NSDate()
    let dateFormatter = DateFormatter()
    
    @IBAction func btnCheckOne(_ sender: UIButton) {
        checkOneOn.isHidden = false
        checkTwoOn.isHidden = true
        checkThreeOn .isHidden = true
        
        nextBtn.isEnabled = true
    }
    
    @IBAction func btnCheckTwo(_ sender: UIButton) {
        checkOneOn.isHidden = true
        checkTwoOn.isHidden = false
        checkThreeOn .isHidden = true
        
        nextBtn.isEnabled = true
    }
    
    @IBAction func btnCheckThree(_ sender: UIButton) {
        checkOneOn.isHidden = true
        checkTwoOn.isHidden = true
        checkThreeOn .isHidden = false
        
        nextBtn.isEnabled = true
    }
        
    @IBAction func btnDireckReport(_ sender: UIButton) {
        let userID = Auth.auth().currentUser?.uid
        let randomToken = ref.child("MyRen").child("DrivingRecord").childByAutoId()
        
        if checkOneOn.isHidden == false {
            
            randomToken.setValue(["accidentType": lblCA.text, "address" : addresData, "date": timeData, "key": userID!, "latitude": latitudeData, "longitude": longitudeData])
            
            guard let nextVC = self.storyboard?.instantiateViewController(identifier:"AccessViewController") as?  AccessViewController else { return }
            nextVC.timeData = timeData
            nextVC.data = lblCA.text
           
            nextVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else if checkTwoOn.isHidden == false{
          
            randomToken.setValue(["accidentType":  lblCrash.text, "address" : addresData, "date": timeData, "key": userID!, "latitude": latitudeData, "longitude": longitudeData])
            
            
            guard let nextVC = self.storyboard?.instantiateViewController(identifier:"AccessViewController") as?  AccessViewController else { return }
            nextVC.timeData = timeData
            nextVC.data = lblCrash.text
            nextVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
           
            randomToken.setValue(["accidentType":  lblPA.text, "address" : addresData, "date": timeData, "key": userID!, "latitude": latitudeData, "longitude": longitudeData])
            
            guard let nextVC = self.storyboard?.instantiateViewController(identifier:"AccessViewController") as?  AccessViewController else { return }
            nextVC.timeData = timeData
            nextVC.data = lblPA.text
            
            nextVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
        (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.popToRootViewController(animated: false)
    }
    
    
    @IBAction func navigationBack(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
        (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.popToRootViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        myMap.showsUserLocation = true
        myMap.setUserTrackingMode(.follow, animated: true)
        
        ref = Database.database().reference()
        
        locationManager.delegate = self
        // 정확도를 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 데이터를 추적하기 위해 사용자에게 승인 요구
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트를 시작
        //locationManager.startUpdatingLocation()
        // 위치 보기 설정
        myMap.showsUserLocation = true
        
        directView.mapViewBoarder()
        directView.mapViewShadow()
        
        nextBtn.mapViewBoarder()
        backBtn.mapViewBoarder()
        
        btnHidden()
        
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        timeData = dateFormatter.string(from: now as Date)
        
        self.navigationController?.addCustomBottomLine(color: UIColor.init(red: 0.83, green: 0.82, blue: 0.82, alpha: 1.0), height: 1.0)
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //locationManager.stopUpdatingLocation()
    }
    
    private func initView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedMapView(_:)))
        self.myMap.addGestureRecognizer(tap)
    }
    
    func style() {
        lblAddress.dynamicFont(fontSize: 25, weight: .semibold)
        
        lblCA.dynamicFont(fontSize: 16, weight: .regular)
        lblCrash.dynamicFont(fontSize: 16, weight: .regular)
        lblPA.dynamicFont(fontSize: 16, weight: .regular)
        
        lbl_1.dynamicFont(fontSize: 25, weight: .semibold)
        lbl_2.dynamicFont(fontSize: 14, weight: .medium)
    }
    

    func btnHidden() {
        checkOneOn.isHidden = true
        checkTwoOn.isHidden = true
        checkThreeOn .isHidden = true
    }

}


extension DirectReportViewController {
    
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
    
    func setAnnotation(latitudeValue: CLLocationDegrees,
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
                    
                    self.lblAddress.text =
                    "\(placeMark.country ?? "") " +
                    "\(placeMark.administrativeArea ?? "") " + "\(placeMark.locality ?? "") " + "\(placeMark.thoroughfare ?? "") "
                    + "\(placeMark.subThoroughfare ?? "") "
                    
                    
                    self.latitudeData = "\(point.latitude)"
                    self.longitudeData = "\(point.longitude)"
                    
                    self.addresData = self.lblAddress.text
                    
                    self.myMap.addAnnotation(annotation)
                }
            } else {
                self.lblAddress.text = "검색 실패"
            }
        }
    }
}
