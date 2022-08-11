//
//  CMMotionViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/08/16.
//
import UIKit
import CoreMotion
import FirebaseAuth
import Firebase
import FirebaseDatabase

class CMMotionViewController: UIViewController {

//    let dataArray: Array<UIImage> = [UIImage(named: "beaner.svg")!]
    
    var motion = CMMotionManager()
    var nowPage: Int = 0
    
    var ref: DatabaseReference!
    var randomString: String!
    
    @IBOutlet var drivingRecord: UIButton!
    @IBOutlet var carInformation: UIButton!
    @IBOutlet var btnNext: UIButton!
    
    @IBOutlet var recordView: UIView!
    @IBOutlet var carView: UIView!
    @IBOutlet var buttonView: UIView!
    
    @IBOutlet var titleView: UIView!
    @IBOutlet var conScroll: UIScrollView!

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAuto: UILabel!
    @IBOutlet var lblSubAuto: UILabel!
    @IBOutlet var lblGuide: UILabel!
        
    @IBAction func switchDR(_ sender: UIButton) {
        drivingRecord.layer.addBorder([.bottom], color: UIColor(red: 0.94, green: 0.42, blue: 0.24, alpha: 1), width: 5.0)
        drivingRecord.setTitleColor(.black, for: .normal)
        carInformation.setTitleColor(.lightGray, for: .normal)
        carInformation.layer.addBorder([.bottom], color: UIColor.white, width: 5.0)
        recordView.isHidden = false
        carView.isHidden = true
    }
    
    @IBAction func switchCI(_ sender: UIButton) {
        carInformation.layer.addBorder([.bottom], color: UIColor(red: 0.94, green: 0.42, blue: 0.24, alpha: 1), width: 5.0)
        carInformation.setTitleColor(.black, for: .normal)
        drivingRecord.setTitleColor(.lightGray, for: .normal)
        drivingRecord.layer.addBorder([.bottom], color: UIColor.white, width: 5.0)
        recordView.isHidden = true
        carView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        navigationLogo()
        buttonView.superview?.bringSubviewToFront(buttonView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref = Database.database().reference()
        userName()
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.isNavigationBarHidden = false
        
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    func navigationLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 81, height: 16))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func userName() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyRen").child("UserAccount").child(userID!).child("name").observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.lblName.text = value + "님 안녕하세요"
            }
                }) { error in
            print(error.localizedDescription)
        }
    }
    
    func style() {
        
        tabBarController?.tabbar()
        
//        lblName.dynamicFont(fontSize: 26, weight: .semibold)
//        lblGuide.dynamicFont(fontSize: 16, weight: .regular)
//        lblAuto.dynamicFont(fontSize: 16, weight: .semibold)
//        lblSubAuto.dynamicFont(fontSize: 14, weight: .regular)
        
        buttonView.viewShadow() 
        buttonView.viewBoarder()
        
        self.navigationController?.addCustomBottomLine(color: UIColor.init(red: 0.83, green: 0.82, blue: 0.82, alpha: 1.0), height: 1.0)
        
        titleView.layer.addBorder([.bottom], color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), width: 1.0)
        drivingRecord.layer.addBorder([.bottom], color: UIColor(red: 0.94, green: 0.42, blue: 0.24, alpha: 1), width: 5.0)
        carInformation.layer.addBorder([.bottom], color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1), width: 5.0)
       
    }
    
  
//    // 5초마다 실행되는 타이머
//      func bannerTimer() {
//          let _: Timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (Timer) in
//              self.bannerMove()
//          }
//      }
//      // 배너 움직이는 매서드
//      func bannerMove() {
//          // 현재페이지가 마지막 페이지일 경우
//          if nowPage == dataArray.count-1 {
//          // 맨 처음 페이지로 돌아감
//              bannerCollectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
//              nowPage = 0
//              return
//          }
//          // 다음 페이지로 전환
//          nowPage += 1
//          bannerCollectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
//      }
    
    
    
  
}
  

//extension CMMotionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    //컬렉션뷰 개수 설정
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataArray.count
//    }
//
//    //컬렉션뷰 셀 설정
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
//        cell.imgView.image = dataArray[indexPath.row]
//        return cell
//    }
//
//    // UICollectionViewDelegateFlowLayout 상속
//    //컬렉션뷰 사이즈 설정
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: bannerCollectionView.frame.size.width  , height:  bannerCollectionView.frame.height)
//    }
//
//    //컬렉션뷰 감속 끝났을 때 현재 페이지 체크
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
//    }
//}

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
          
extension UIView {
    func viewShadow() {
        // subview 그림자
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowPath = nil
        
    }
    func viewBoarder() {
        // subview 테투리
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.0).cgColor
    }
}

