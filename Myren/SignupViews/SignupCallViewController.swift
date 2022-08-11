//
//  SignupCallViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/10/05.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseAuth
class SignupCallViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var txtCall: UITextField!
    @IBOutlet var txtCtc: UITextField!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var certification: UILabel!
    @IBOutlet var ctcTimer: UILabel!
    @IBOutlet var reCtcBtn: UIButton!
    
    var limitTime: Int = 180
    var verificationID: String = ""
    var bottomConstraint: NSLayoutConstraint?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Call()
        Btn()
        keyboarde()
        txtCall.addTarget(self,action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc func textFieldDidChange(sender: UITextField) {
            if sender.text?.isEmpty == true {
                self.nextBtn.isEnabled = false
            } else {
                self.nextBtn.isEnabled = true
            }
    }
    
    @objc func firstHidden() {
        certification.isHidden = true
        ctcTimer.isHidden = true
        reCtcBtn.isHidden = true
        txtCtc.isHidden = true
        nextBtn.isEnabled = true
        nextBtn.setTitle("확인", for: .normal)
        txtCall.addTarget(self,action: #selector(textFieldDidChange), for: .editingChanged)
        Btn()
    }
    
    func Call() {
        txtCall.addLeftPadding()
        txtCall.layer.cornerRadius = 8
        txtCall.layer.borderWidth = 1
        txtCall.borderStyle = .none
        txtCall.layer.borderColor = .init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        txtCtc.addLeftPadding()
        txtCtc.layer.cornerRadius = 8
        txtCtc.layer.borderWidth = 1
        txtCtc.borderStyle = .none
        txtCtc.layer.borderColor = .init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
    }
    
    func Btn() {
        nextBtn.layer.cornerRadius = 8
        nextBtn.addTarget(self, action: #selector(accessBtn), for: .touchUpInside)
    }
   
    func keyboarde() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.bottomConstraint = NSLayoutConstraint(item: self.nextBtn as Any, attribute: .bottom, relatedBy: .equal, toItem: safeArea, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.bottomConstraint?.isActive = true
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
  
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            self.bottomConstraint?.constant = -1.05 * keyboardHeight
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        debugPrint("keyboardWillHide")
        self.bottomConstraint?.constant = 0
        self.view.layoutIfNeeded()
    }

    @objc func accessBtn() {
        //txtCall.text = "01028023657"
        
        Auth.auth().languageCode = "kor"
        PhoneAuthProvider.provider().verifyPhoneNumber(txtCall.text ?? "", uiDelegate: nil) { (verificationID, error) in
            if verificationID != nil {
                        UserDefaults.standard.set(verificationID, forKey: "verificationID")
                    }
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
        }
        
        
        certification.isHidden = false
        ctcTimer.isHidden = false
        reCtcBtn.isHidden = false
        txtCtc.isHidden = false
        
        reCtcBtn.setUnderline()
        nextBtn.setTitle("다음", for: .normal)
       // nextBtn.addTarget(self, action: #selector(ctcBtn), for: .touchUpInside)
        getSetTime()
        
    }
    
    @objc func getSetTime() {
        seconToTime(sec: limitTime)
        limitTime -= 1
    }
    
    func seconToTime(sec : Int) {
        let minute = (sec % 3600) / 60
        let second = (sec % 3600) % 60
        
        if second < 10 {
            ctcTimer.text = String(minute) + ":" + "0"+String(second)
        } else {
            ctcTimer.text = String(minute) + ":" + String(second)
        }
        
        if limitTime != 0 {
            perform(#selector(getSetTime), with: nil, afterDelay: 1.0)
        }
        else if limitTime == 0 {
            firstHidden()
            
        }
    }

    @objc func ctcBtn() {
                
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID"), let verificationCode = txtCtc.text else {
                    return
        }
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID,
                    verificationCode: verificationCode
                )
    }
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
  }
}

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}

