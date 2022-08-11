//
//  PrivacyViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/11/29.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MyPrivacyViewController: UIViewController {

    @IBOutlet var privacyView: UIView!
    @IBOutlet var menuStackView: UIStackView!
    
    @IBOutlet var viewStack_1: UIView!
    @IBOutlet var viewStack_2: UIView!
    @IBOutlet var viewStack_3: UIView!
    @IBOutlet var viewStack_4: UIView!
    @IBOutlet var viewStack_5: UIView!
    @IBOutlet var viewStack_6: UIView!
    @IBOutlet var viewStack_7: UIView!
    
    @IBOutlet var barButtonLogout: UIBarButtonItem!
    @IBOutlet var buttonLogout: UIButton!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblCarNum: UILabel!
    @IBOutlet var lblInsurance: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblTell: UILabel!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        buttonAction()
        viewDisign()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebase()
        
    }
    
    func viewDisign() {
        privacyView.viewShadow()
        privacyView.viewBoarder()
        
        menuStackView.viewShadow()
        
        viewStack_1.viewBoarder()
        viewStack_2.viewBoarder()
        viewStack_3.viewBoarder()
        viewStack_4.viewBoarder()
        viewStack_5.viewBoarder()
        viewStack_6.viewBoarder()
        viewStack_7.viewBoarder()
        
        buttonLogout.sizeToFit()
        
    }
    
    func buttonAction() {
        buttonLogout.addTarget(self, action: #selector(logout), for: .touchUpInside)
        barButtonLogout.addTargetForAction(target: self, action: #selector(logout))
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
                }
        rootView()
    }
    
    func rootView() {
        let tabbar = UIStoryboard.init(name: "Main", bundle: nil)
            guard let mainView = tabbar.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
              (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(mainView, animated: false)
    }
    
    
    func firebase() {
        userName()
        userCarNumber()
        userInsurance()
        userEmail()
        userTell()
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

    func userName() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyRen").child("UserAccount").child(userID!).child("name").observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.lblName.text = value
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
    
    func userEmail() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("MyRen").child("UserAccount").child(userID!).child("emailId").observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.lblEmail.text = value
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

extension UIBarButtonItem {
    func addTargetForAction(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
        
    }
}
