//
//  AccessViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/08/20.
//

import UIKit
import MessageUI
import FirebaseAuth
import CoreLocation
import FirebaseDatabase
import Firebase
import MapKit

class AccessViewController: UIViewController, MFMessageComposeViewControllerDelegate , CLLocationManagerDelegate {
    
    @IBOutlet var myMap: MKMapView!
    
    @IBOutlet weak var mian: UIButton!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet var lblInsurance: UILabel!
    @IBOutlet weak var lblProtector: UILabel!
    @IBOutlet var lblOfficials: UILabel!
    
    @IBOutlet var lbl_1: UILabel!
    @IBOutlet var lbl_2: UILabel!
    @IBOutlet var lbl_3: UILabel!
    @IBOutlet var lbl_4: UILabel!
    @IBOutlet var lbl_5: UILabel!
    @IBOutlet var lbl_6: UILabel!
    @IBOutlet var lbl_7: UILabel!
    @IBOutlet var lbl_8: UILabel!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var subView: UIView!
    
    @IBOutlet var btnMain: UIButton!
    
    lazy var locationManager: CLLocationManager = {
           let manager = CLLocationManager()
           manager.desiredAccuracy = kCLLocationAccuracyBest
           manager.distanceFilter = kCLHeadingFilterNone
           manager.requestWhenInUseAuthorization()
           manager.delegate = self
           return manager
       }()
    
    var ref: DatabaseReference!
    var latitude: Double?
    var longtitude: Double?
    var data : String!
    var timeData : String!
    var latitudeData : String!
    var longitudeData :String!
    
    @IBAction func navigationItem(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.popToRootViewController(animated: false)
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    @IBAction func mainButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
        (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.popToRootViewController(animated: false)
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mian.layer.cornerRadius = 8
        
        delay()
        subView.mapViewShadow()
        subView.mapViewBoarder()
        
        btnMain.mapViewBoarder()
        
        ref = Database.database().reference()
        
        lblInsurance.labelBoarder()
        lblProtector.labelBoarder()
        lblOfficials.labelBoarder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        
        enadble()
        style()
        userProtector()
        userInsurance()
        
        lblTime.text = timeData
        
        self.tabBarController?.tabBar.isHidden = true
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        // 사용할때만 위치정보를 사용한다는 팝업이 발생
        locationManager.requestWhenInUseAuthorization()
        // 항상 위치정보를 사용한다는 판업이 발생
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        myMap.showsUserLocation = true
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.locationManager.stopUpdatingLocation()
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    
//    @IBOutlet weak var lblAddress: UILabel!
//    @IBOutlet var lblInsurance: UILabel!
//    @IBOutlet weak var lblProtector: UILabel!
//    @IBOutlet var lblOfficials: UILabel!
//
//    @IBOutlet var lbl_1: UILabel!
//    @IBOutlet var lbl_2: UILabel!
//    @IBOutlet var lbl_3: UILabel!
//    @IBOutlet var lbl4: UILabel!
//    @IBOutlet var lbl_5: UILabel!
//    @IBOutlet var lbl_6: UILabel!
//    @IBOutlet var lbl_7: UILabel!
//    @IBOutlet var lbl_8: UILabel!
    
    
    func style() {

        lbl_1.dynamicFont(fontSize: 25, weight: .semibold)
        lbl_2.dynamicFont(fontSize: 14, weight: .medium)
        lbl_3.dynamicFont(fontSize: 14, weight: .medium)
        lbl_4.dynamicFont(fontSize: 14, weight: .medium)
        lbl_5.dynamicFont(fontSize: 14, weight: .medium)
        lbl_6.dynamicFont(fontSize: 12, weight: .medium)
        lbl_7.dynamicFont(fontSize: 12, weight: .medium)
        lbl_8.dynamicFont(fontSize: 12, weight: .medium)

        lblTime.dynamicFont(fontSize: 18, weight: .semibold)
        lblInsurance.dynamicFont(fontSize: 14, weight: .medium)
        lblProtector.dynamicFont(fontSize: 14, weight: .medium)
        lblOfficials.dynamicFont(fontSize: 14, weight: .medium)
    }
    
    func enadble() {
        self.tabBarController?.tabBar.items?[0].isEnabled = true
        self.tabBarController?.tabBar.items?[1].isEnabled = true
        //self.tabBarController?.tabBar.items?[2].isEnabled = true
        
    }
    
    func delay() {
        // 5초의 딜레이 시간 뒤 DB에 저장된 보호자번호에를 호출 후 전화 및 문자를 보냄
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3)  { [self] in
            if let url = NSURL(string: "tel://" + lblProtector.text!),
               UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
            let messageComposer = MFMessageComposeViewController()
            messageComposer.messageComposeDelegate = self
                if MFMessageComposeViewController.canSendText(){
                    messageComposer.recipients = [lblProtector.text!]
                    messageComposer.body =
                    "https://maps.google.com/?q=\(self.latitude!),\(self.longtitude!)"     //현제위치의 위도, 경도를 통해서 구글맵 링크를 같이 붙혀서 전송
                    self.present(messageComposer, animated: true, completion: nil)
                    
            }
            return
        }
        
        
    }
    
    func userProtector() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyRen").child("UserAccount").child(userID!).child("parentPhoneNumber").observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? String ?? "01098679020"
            DispatchQueue.main.async {
                self.lblProtector.text = value
            }
                }) { error in
                    print(error.localizedDescription)
        }
    }
    
    func userInsurance() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyRen").child("UserAccount").child(userID!).child("insuranceCompany").observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? String ?? "현대해상"
            DispatchQueue.main.async {
                self.lblInsurance.text = value
            }
                }) { error in
                    print(error.localizedDescription)
        }
    }

    func goLocation(latitudeValue: CLLocationDegrees, longtudeValue: CLLocationDegrees,
                    delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        myMap.setRegion(pRegion, animated: true)
        
        return pLocation
    }

    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        let pLocation = locations.last
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!,
                       longtudeValue: (pLocation?.coordinate.longitude)!,
                       delta: 0.01)
        if let location = locations.first {
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
            
            let location: CLLocation = locations[locations.count - 1]
            let longitude: CLLocationDegrees = location.coordinate.longitude
            let latitude: CLLocationDegrees = location.coordinate.latitude
            
            self.longtitude = longitude
            self.latitude = latitude
            
            let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            let geoCoder: CLGeocoder = CLGeocoder()
            let local: Locale = Locale(identifier: "Ko-kr") // Korea
            geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
                if let address: [CLPlacemark] = place {
                    print("시(도): \(String(describing: address.last?.administrativeArea))")
                    print("구(군): \(String(describing: address.last?.locality))")
                    print("지역(동): \(String(describing: address.last?.thoroughfare))")
                    print("지역(동): \(String(describing: address.last?.subThoroughfare))")
                }
            }
           }
       }
       
       // 위도 경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }


    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch result {
            case MessageComposeResult.sent:
                print("전송 완료")
                break
            case MessageComposeResult.cancelled:
                print("취소")
                break
            case MessageComposeResult.failed:
                print("전송 실패")
                break
            @unknown default:
                fatalError()
            }
            controller.dismiss(animated: true, completion: nil)
        }
}

extension String {
    func stringFromDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: now)
    }
}

