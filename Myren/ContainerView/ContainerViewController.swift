//
//  ContainerViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/10/31.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import RealmSwift
class ContainerViewController: UIViewController {

    
    @IBOutlet var subCarInformation: UIView!
    @IBOutlet var subInsurance: UIView!
    
    @IBOutlet var viewCarNum: UIView!
    @IBOutlet var viewInsurance: UIView!
    @IBOutlet var viewCall: UIView!
    
    @IBOutlet var lblCarNum: UILabel!
    @IBOutlet var lblInsurance: UILabel!
    @IBOutlet var lblCarName: UILabel!
    @IBOutlet var lblCarSize: UILabel!
    @IBOutlet var lblCarOilseed: UILabel!
    @IBOutlet var lblTell: UILabel!
    
    @IBOutlet var lbl_1: UILabel!
    @IBOutlet var lbl_2: UILabel!
    @IBOutlet var lbl_3: UILabel!
    @IBOutlet var lbl_4: UILabel!
     
    //let realm = try! Realm()
   
    var ref: DatabaseReference!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        secondViewDisign()
        buttonStyle()
        secondViewDisign()
        buttonStyle()
        labelFont()
        
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userCarNumber()
        userCarName()
        userInsurance()
        userCarSize()
        userCarOilseed()
        userTell()
    }
    
    func labelFont() {
//        lbl_1.dynamicFont(fontSize: 20, weight: .semibold)
//        lbl_2.dynamicFont(fontSize: 14, weight: .regular)
//        lbl_3.dynamicFont(fontSize: 20, weight: .semibold)
//        lbl_4.dynamicFont(fontSize: 12, weight: .regular)
//
//        lblCarNum.dynamicFont(fontSize: 36, weight: .bold)
//        lblInsurance.dynamicFont(fontSize: 28, weight: .bold)
//        lblCarName.dynamicFont(fontSize: 14, weight: .medium)
//        lblCarSize.dynamicFont(fontSize: 14, weight: .medium)
//        lblCarOilseed.dynamicFont(fontSize: 14, weight: .medium)
//        lblTell.dynamicFont(fontSize: 14, weight: .medium)
        
    }
    func secondViewDisign() {
        // 내차정보 ... view
        subCarInformation.viewShadow()
        subCarInformation.viewBoarder()
        // 가입 보험정보... view
        subInsurance.viewShadow()
        subInsurance.viewBoarder()
        viewCarNum.viewBoarder()
        viewInsurance.viewBoarder()
    
    }
    
    func buttonStyle() {
        lblCarName.labelStyle()
        lblCarSize.labelStyle()
        lblCarOilseed.labelStyle()
        
        viewCall.layer.borderWidth = 1
        viewCall.layer.cornerRadius = 8
        viewCall.layer.borderColor = UIColor(red: 0.537, green: 0.525, blue: 0.525, alpha: 1).cgColor
        //btnTell.layer.masksToBounds = true
        
    }
    

  
    func userCarNumber() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyRen").child("UserAccount").child(userID!).child("carNumber").observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.lblCarNum.text = value
            }
                }) { error in
                    print(error.localizedDescription)
                    }
    }

    func userCarName() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyRen").child("UserAccount").child(userID!).child("displacement").observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.lblCarName.text = value
            }
                }) { error in
                    print(error.localizedDescription)
                    }
    }
    
    func userTell() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyRen").child("UserAccount").child(userID!).child("parentPhoneNumber").observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.lblTell.text = value
            }
                }) { error in
                    print(error.localizedDescription)
                    }
    }
    
    func userCarSize() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyRen").child("UserAccount").child(userID!).child("carType").observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.lblCarSize.text = value
            }
                }) { error in
                    print(error.localizedDescription)
                    }
    }
    
    func userCarOilseed() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyRen").child("UserAccount").child(userID!).child("parentPhoneNumber").observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.lblCarOilseed.text = value
            }
                }) { error in
                    print(error.localizedDescription)
                    }
    }
    
    func userInsurance() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyRen").child("UserAccount").child(userID!).child("insuranceCompany").observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.lblInsurance.text = value
            }
                }) { error in
                    print(error.localizedDescription)
                    }
    }
}

extension UILabel {
    func labelStyle() {
        self.layer.borderColor = UIColor(red: 0.77, green: 0.76, blue: 0.76, alpha: 1.0).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
}

