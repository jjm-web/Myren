//
//  Created by 장준명 on 2022/08/17.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class SecondReportViewController: UIViewController, CLLocationManagerDelegate {

    var time : Float = 0.0
    var timer : Timer?
    var count : Int = 30
    let timeSelector : Selector = #selector(SecondReportViewController.updateTime)
    let interval = 1.0
    
    lazy var locationManager: CLLocationManager = {
           let manager = CLLocationManager()
           manager.desiredAccuracy = kCLLocationAccuracyBest
           manager.distanceFilter = kCLHeadingFilterNone
           manager.requestWhenInUseAuthorization()
           manager.delegate = self
           return manager
       }()
       
    let now = NSDate()
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var buttonCancle: UIButton!
    @IBOutlet weak var buttonMap: UIButton!

    @IBOutlet weak var lblAddress: UILabel!

    @IBOutlet weak var lblRearTime: UILabel!
    @IBOutlet var lblAccident: UILabel!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var subView: UIView!
    
    var data : String!
    var ref: DatabaseReference!
    
    @IBAction func mapButton(_ sender: Any) {
        guard let userAddress = lblAddress.text,
//              let userLatitude = lblLatitude.text,
//              let userLongitude = lblLongitude.text,
              let userRearTime = lblRearTime.text,
              let userAccident = data else {
            return
        }
        let user = Auth.auth().currentUser
    
        ref.child("MyRen").child("DrivingRecord").child(user!.uid).setValue(["accidentType":  userAccident, "address" : userAddress, "date": userRearTime, "key": user!.uid, /*"latitude": userLatitude, "longitude": userLongitude*/])
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AccessViewController") as? AccessViewController else { return }
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func Back(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progress()
        setProgress()
        txtTimer()
        ref = Database.database().reference()
        
        buttonCancle.layer.cornerRadius = 10
        buttonCancle.layer.borderWidth = 1
        buttonCancle.layer.borderColor = CGColor(red: 0.94, green: 0.42, blue: 0.42, alpha: 1.0)
        
        buttonMap.layer.cornerRadius = 10
        
        subView.layer.cornerRadius = 12
        subView.layer.borderWidth = 1
        subView.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        lblRearTime.text = dateFormatter.string(from: now as Date)
        lblAccident?.text = data
        
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
        self.locationManager.stopUpdatingLocation()
    }
    
    func progress() {
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 6)
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
        progressView.setProgress(time, animated: true)
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
    
    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if let location = locations.first {
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
//            self.lblLatitude.text = " \(Double(location.coordinate.latitude))"
//            self.lblLongitude.text = " \(Double(location.coordinate.longitude))"
            
            let location: CLLocation = locations[locations.count - 1]
            let longitude: CLLocationDegrees = location.coordinate.longitude
            let latitude: CLLocationDegrees = location.coordinate.latitude
            
            let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            let geoCoder: CLGeocoder = CLGeocoder()
            let local: Locale = Locale(identifier: "Ko-kr") // Korea
            geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
                if let address: [CLPlacemark] = place {
                    
                    print("시(도): \(String(describing: address.last?.administrativeArea))")
                    print("구(군): \(String(describing: address.last?.locality))")
                    print("지역(동): \(String(describing: address.last?.thoroughfare))")
                    print("지역(동): \(String(describing: address.last?.subThoroughfare))")
                    
                    self.lblAddress.text = "\(String((address.last?.administrativeArea)! )) " + "\(String((address.last?.locality)! )) "
                    + "\(String((address.last?.thoroughfare)! )) " + "\(String((address.last?.subThoroughfare)! )) "
                }
            }
        }
    }
       // 위도 경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}

