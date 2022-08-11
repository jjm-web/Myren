//
//  ReportViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/08/17.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import RealmSwift
import Gifu

class SubData: Object {
    @objc dynamic var realmDate:String = ""
    @objc dynamic var realmAccidDate:String = ""

}

class ReportViewController: UIViewController, CLLocationManagerDelegate {

    var time : Float = 0.0
    var timer : Timer?
    var count : Int = 29
    
    var data : String!
    var latitudeData : String!
    var longitudeData : String!
    var addressData : String!
    var timeData : String!
    var distanceData : String!
    
    var ref: DatabaseReference!
    
    let timeSelector : Selector = #selector(ReportViewController.updateTime)
    let interval = 1.0
    //let realm = try! Realm()
    
    let now = NSDate()
    let dateFormatter = DateFormatter()
    
    lazy var locationManager: CLLocationManager = {
           let manager = CLLocationManager()
           manager.desiredAccuracy = kCLLocationAccuracyBest
           manager.distanceFilter = kCLHeadingFilterNone
           manager.requestWhenInUseAuthorization()
           manager.delegate = self
           return manager
       }()
 
    @IBOutlet var gifImage: GIFImageView!
    
    @IBOutlet weak var buttonCancle: UIButton!
    @IBOutlet weak var buttonMap: UIButton!
    @IBOutlet var navigationBack: UIBarButtonItem!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRearTime: UILabel!
    @IBOutlet var lblAccident: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet var lbl_1: UILabel!
    @IBOutlet var lbl_2: UILabel!
    @IBOutlet var lbl_3: UILabel!
    @IBOutlet var lbl_4: UILabel!
    @IBOutlet var lbl_5: UILabel!
    
    @IBOutlet var subView: UIView!
    
    @IBAction func mapButton(_ sender: Any) {
        guard let userAddress = addressData,
              let userLatitude = latitudeData,
              let userLongitude = longitudeData,
              let userRearTime = lblRearTime.text,
              let userAccident = data else {
            return
        }
        
        let userID = Auth.auth().currentUser?.uid
        
        let randomToken = ref.child("MyRen").child("DrivingRecord").childByAutoId()
        
        randomToken.setValue(["accidentType":  userAccident, "address" : userAddress, "date": userRearTime, "key": userID!, "latitude": userLatitude, "longitude": userLongitude])

        
//        let crush = SubData()
//        
//        crush.realmDate = userRearTime
//        crush.realmAccidDate = userAccident
//
//        do{
//            try realm.write{
//                realm.add(crush)
//            }
//        } catch {
//            print("Error Add \(error)")
//        }

        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AccessViewController") as? AccessViewController else { return }
        nextVC.latitudeData = userLatitude
        nextVC.longitudeData = userLongitude
        nextVC.timeData = userRearTime
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        //nextVC.randomString = String.random()
        self.navigationController?.pushViewController(nextVC, animated: true)
        self.dismiss(animated: true)
    }
    
    @IBAction func backNavigation(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
        (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.popToRootViewController(animated: false)
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true)
        //       self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func Back(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.popToRootViewController(animated: false)
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    func progress() {
        DispatchQueue.main.async {
            self.gifImage.prepareForAnimation(withGIFNamed: "progress") {
                print("")
                print("===============================")
                print("[ViewController >> testMain() :: gifufigure GIF 파일 애니메이션 준비 완료]")
                print("===============================")
                    print("")
                }
        
        // [애니메이션 동작 수행]
        self.gifImage.animate(withGIFNamed: "progress", animationBlock:  { })
                    
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        style()
        setProgress()
        progress()
        txtTimer()
        ref = Database.database().reference()
      
        subView.mapViewShadow()
        subView.mapViewBoarder()
        
        lblAddress.labelBoarder()
        lblRearTime.labelBoarder()
        lblAccident.labelBoarder()
        
        buttonCancle.viewBoarder()
        buttonCancle.layer.borderColor = CGColor(red: 0.94, green: 0.42, blue: 0.24, alpha: 1.0)
        buttonMap.viewBoarder()
        
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        lblRearTime.text = dateFormatter.string(from: now as Date)
        lblAccident?.text = data
        lblAddress.text = addressData
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        // 사용할때만 위치정보를 사용한다는 팝업이 발생
        locationManager.requestWhenInUseAuthorization()
        // 항상 위치정보를 사용한다는 판업이 발생
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        buttonMap.isEnabled = false
        buttonCancle.isEnabled = false
        lblTimer.text = String(count)
        timer?.invalidate()
        timer = nil
        count = 0
        lblTimer.text = "30"
        enadble()
        self.locationManager.stopUpdatingLocation()
    }
    
    func enadble() {
        self.tabBarController?.tabBar.items?[0].isEnabled = true
        self.tabBarController?.tabBar.items?[1].isEnabled = true
        self.tabBarController?.tabBar.items?[2].isEnabled = true
    }
    
    func style() {

        lbl_1.dynamicFont(fontSize: 25, weight: .semibold)
        lbl_2.dynamicFont(fontSize: 14, weight: .medium)
        lbl_3.dynamicFont(fontSize: 14, weight: .medium)
        lbl_4.dynamicFont(fontSize: 14, weight: .medium)
        lbl_5.dynamicFont(fontSize: 14, weight: .medium)
        
        lblTimer.dynamicFont(fontSize: 64, weight: .medium)
        
        lblAccident.dynamicFont(fontSize: 14, weight: .medium)
        lblAddress.dynamicFont(fontSize: 14, weight: .medium)
        lblRearTime.dynamicFont(fontSize: 14, weight: .medium)
    }

    func txtTimer() {
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        buttonMap.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        buttonCancle.addTarget(self, action: #selector(canclePage), for: .touchUpInside)
    }
    
    @objc func setProgress() {
        time += 0.00001
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.00001, target: self, selector: #selector(setProgress), userInfo: nil, repeats: true)
        //circularProgressBar.setProgress(time, animated: true)
        if time >= 1.0 {
            timer?.invalidate()
            timer = nil
            return
        }
    }
   
    @objc func updateTime() {
        lblTimer.text = String(count)
        count -= 1
        if (lblTimer.text == String(0)) && (buttonMap.isEnabled == true) {
            timer?.invalidate()
            timer = nil
            count = 0
            lblTimer.text = "0"
            mapButton((Any).self)
            buttonMap.isEnabled = false
        }
    }
    @objc func nextPage() {
            lblTimer.text = String(count)
            timer?.invalidate()
            timer = nil
            count = 0
            lblTimer.text = "0"
            mapButton((Any).self)
            buttonMap.isEnabled = false
    }
    
    @objc func canclePage() {
        lblTimer.text = String(count)
        timer?.invalidate()
        timer = nil
        
        count = 0
        lblTimer.text = "0"
        Back((Any).self)
        
        buttonMap.isEnabled = false
        buttonCancle.isEnabled = false
        }
    
    func tabbarImage() {
        self.tabBarController?.tabBar.items![0].image = UIImage(named: "home_off")
        self.tabBarController?.tabBar.items![0].selectedImage = UIImage(named: "home_off")
        
        self.tabBarController?.tabBar.items![1].image = UIImage(named: "report_off")
        self.tabBarController?.tabBar.items![1].selectedImage = UIImage(named: "report_off")

    }
    
    
//    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("didUpdateLocations")
//        if let location = locations.first {
//            print("위도: \(location.coordinate.latitude)")
//            print("경도: \(location.coordinate.longitude)")
//
//            self.latitudeData = " \(Double(location.coordinate.latitude))"
//            self.longitudeData = " \(Double(location.coordinate.longitude))"
//
//            let location: CLLocation = locations[locations.count - 1]
//            let longitude: CLLocationDegrees = location.coordinate.longitude
//            let latitude: CLLocationDegrees = location.coordinate.latitude
//
//            let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
//            let geoCoder: CLGeocoder = CLGeocoder()
//            let local: Locale = Locale(identifier: "Ko-kr") // Korea
//            geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
//                if let address: [CLPlacemark] = place {
//
//                    print("시(도): \(String(describing: address.last?.administrativeArea))")
//                    print("구(군): \(String(describing: address.last?.locality))")
//                    print("지역(동): \(String(describing: address.last?.thoroughfare))")
//                    print("지역(동): \(String(describing: address.last?.subThoroughfare))")
//
//                    self.lblAddress.text =  "\(String((address.last?.country)! )) " + "\(String((address.last?.administrativeArea)! )) " + "\(String((address.last?.locality)! )) "
//                    + "\(String((address.last?.thoroughfare)! )) " + "\(String((address.last?.subThoroughfare)! )) "
//                }
//            }
//        }
//    }
//       // 위도 경도 받아오기 에러
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }

}

extension String {
    func StringFromDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: now)
    }
}

extension UILabel {
    func labelBoarder() {
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = CGColor(red: 0.83, green: 0.82, blue: 0.82, alpha: 1.0)
        
    }
}

