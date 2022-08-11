//
//  PrivacyViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/10/05.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import IQKeyboardManagerSwift

class PrivacyViewController: UIViewController {
    
    @IBOutlet var viewName: UIView!
    @IBOutlet var viewEmail: UIView!
    @IBOutlet var viewPassword: UIView!
    @IBOutlet var viewRePassword: UIView!
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtUserEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtPasswordConfirm: UITextField!
    
    @IBOutlet var lblPasswordConfirmed: UILabel!
    @IBOutlet var lblEmailOverlap: UILabel!
    
    @IBOutlet var nextBtn: UIButton!
    
    @IBOutlet var backBtnITem: UIBarButtonItem!
    @IBOutlet var nextBtnItem: UIBarButtonItem!
    
    @IBOutlet var lblMenu: UILabel!
    @IBOutlet var lblPage: UILabel!
    
    @IBOutlet var lblname: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet var lblRePassword: UILabel!
    
    var nameData: String!
    var emailData: String!
    var passwordData: String = ""
    
    var ref: DatabaseReference!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        naviagation()
        ref = Database.database().reference()
        //textfildLayout()
        txtName.delegate = self
        txtUserEmail.delegate = self
        txtPassword.delegate = self
        txtPasswordConfirm.delegate = self
        
        nextBtn.btnRadius()
        fontStyle()
        
    }
    
    @IBAction func overlapEmail(_ sender: Any) {
    
        guard let userEmail = txtUserEmail.text else {
            return
        }
        ref.child("MyRen").child("UserAccount").child("userEmail").observeSingleEvent(of: .value) { snapshot in
        // if snapshot is nil, then completion closure argument will be allocated "false"
        guard snapshot.value as? String != userEmail else {
            self.lblEmailOverlap.text = "이메일이 중복됐습니다"
            self.lblEmailOverlap.textColor = .red
            return
        }
        // completion closure argument will be allocated "true"
        self.lblEmailOverlap.text = "이메일 사용가능합니다"
        self.lblEmailOverlap.textColor = .orange
                
            }
        }
    
    
    @IBAction func btnItemBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        nextButton()
    }
    
    @IBAction func btnItemSubmit(_ sender: Any) {
        nextButton()
    }
    
    
    func nextButton() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier:"SubPrivacyViewController") as? SubPrivacyViewController else { return }
           
        nextVC.nameData = self.txtName.text
        nextVC.emailData = self.txtUserEmail.text
        nextVC.passwordData = self.txtPassword.text
           
        nextVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nextVC, animated: true)
        self.dismiss(animated: true)
    }
    
    func fontStyle() {
//        lblMenu.dynamicFont(fontSize: 22, weight: .semibold)
//        lblPage.dynamicFont(fontSize: 12, weight: .regular)
//
//        lblname.dynamicFont(fontSize: 12, weight: .regular)
//        lblEmail.dynamicFont(fontSize: 12, weight: .regular)
//        lblPassword.dynamicFont(fontSize: 12, weight: .regular)
//        lblRePassword.dynamicFont(fontSize: 12, weight: .regular)
//        lblEmailOverlap.dynamicFont(fontSize: 12, weight: .regular)
//        lblPasswordConfirmed.dynamicFont(fontSize: 12, weight: .regular)
//
//        txtName.dynamicText(fontSize: 16, weight: .regular)
//        txtUserEmail.dynamicText(fontSize: 16, weight: .regular)
//        txtPassword.dynamicText(fontSize: 16, weight: .regular)
//        txtPasswordConfirm.dynamicText(fontSize: 16, weight: .regular)
        
        viewName.viewBoard()
        viewEmail.viewBoarder()
        viewPassword.viewBoard()
        viewRePassword.viewBoarder()
        
        txtName.txtBoard()
        txtPassword.txtBoard()
        txtUserEmail.txtBoard()
        txtPasswordConfirm.txtBoard()
    }
    
    func textfildLayout() {
        txtName.text()
        txtUserEmail.text()
        txtPassword.text()
        txtPasswordConfirm.text()
    }
    
    func naviagation() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }

}

extension PrivacyViewController: UITextFieldDelegate {
    func setLabelPasswordConfirm(_ password: String, _ passwordConfirm: String)  {
        guard passwordConfirm != "" else {
            lblPasswordConfirmed.text = ""
            return
        }
        if password == passwordConfirm {
            lblPasswordConfirmed.textColor = .orange
            lblPasswordConfirmed.text = "패스워드가 일치합니다."
            self.nextBtn.isEnabled = true
            self.nextBtnItem.isEnabled = true
            self.nextBtn.layer.backgroundColor = CGColor(red: 0.94, green: 0.42, blue: 0.24, alpha: 1.0)
        } else if password != passwordConfirm {
            lblPasswordConfirmed.textColor = .red
            lblPasswordConfirmed.text = "패스워드가 일치하지 않습니다."
            self.nextBtn.isEnabled = false
            self.nextBtnItem.isEnabled = false
            self.nextBtn.layer.backgroundColor = CGColor(red: 0.76, green: 0.77, blue: 0.77, alpha: 1.0)
        } else {
            self.nextBtn.isEnabled = false
            self.nextBtnItem.isEnabled = false
            self.nextBtn.layer.backgroundColor = CGColor(red: 0.76, green: 0.77, blue: 0.77, alpha: 1.0)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case txtUserEmail:
            txtPassword.becomeFirstResponder()
        case txtPassword:
            txtPasswordConfirm.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return false
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPasswordConfirm {
            guard let password = txtPassword.text,
                  let passwordConfirmBefore = txtPasswordConfirm.text else {
                return true
            }
          
            let passwordConfirm = string.isEmpty ? passwordConfirmBefore[0..<(passwordConfirmBefore.count - 1)] : passwordConfirmBefore + string
                        setLabelPasswordConfirm(password, passwordConfirm)
        }
        return true
    }
}

extension UITextField {
    func text() {
        self.addLeftPadding()
        self.layer.cornerRadius = 8
        self.layer.borderColor = .init(red: 0.804, green: 0.804, blue: 0.804, alpha: 1)
        self.layer.borderWidth = 1
        self.textColor = .black
        self.borderStyle = .none
    }
}

extension UIButton {
    func btnRadius() {
        self.layer.cornerRadius = 12
    }
}

extension UIView {
    func viewBoard() {
        self.layer.borderColor = CGColor(red: 0.71, green: 0.7, blue: 0.7, alpha: 1.0)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
}

extension UITextField {
    func txtBoard() {
        self.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.borderWidth = 1
    }
}
