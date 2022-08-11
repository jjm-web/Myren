//
//  LoginViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/08/12.
//

import UIKit
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtErrorMessage: UILabel!
    @IBOutlet var emailView: UIView!
    @IBOutlet var passwordView: UIView!
    
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBOutlet var lblIntroduce: UILabel!
    @IBOutlet var lblSubIntroduce: UILabel!
    
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet var lblAutoLogin: UILabel!
    
    @IBOutlet var loginSwitch: UISwitch!
    
    @IBAction func autoLogin(_ sender: UISwitch) {
//        if sender.isOn {
//            if Auth.auth().currentUser != nil {
//            } else {
//            }
//        } else {
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBtn()
        lbltxt()
        //fontStyle()
        
        self.navigationController?.addCustomBottomLine(color: UIColor.init(red: 0.83, green: 0.82, blue: 0.82, alpha: 1.0), height: 1.0)
    
        
        buttonLogin.addTarget(self, action: #selector(login), for: .touchUpInside)
        txtErrorMessage.isHidden = true
        
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.firebaseAuth()
        
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    self.txtErrorMessage.text = ""

    }
    
    @objc func login(_ sender: UIButton) {
      
        let userEmail = txtUserEmail.text ?? ""
        let userPassword = txtPassword.text ?? ""

        Auth.auth().signIn(withEmail: userEmail , password: userPassword ) { [weak self] _, error in
            guard let self = self else { return }

            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: // 이미 가입한 계정일 때 로그인하기
                    Auth.auth().signIn(withEmail: userEmail , password: userPassword )
                    
                default: // 그 외 에러는 화면에 표시하기
                    self.txtErrorMessage.text = error.localizedDescription
                    return
                }
            }
            //self.firebaseAuth()
            self.rootView()
            //self.next()
        }
    }
    
    func firebaseAuth() {
        
        if Auth.auth().currentUser != nil {
            self.rootView()
        } else {
          // No user is signed in.
          // ...
        }
    }
 
    func fontStyle() {
        lblIntroduce.font = UIFont(name: "", size: 12.0)
        lblIntroduce.dynamicFont(fontSize: 26, weight: .semibold)
        lblSubIntroduce.dynamicFont(fontSize: 12, weight: .medium)
        
        lblEmail.dynamicFont(fontSize: 14, weight: .regular)
        lblPassword.dynamicFont(fontSize: 14, weight: .regular)
        lblAutoLogin.dynamicFont(fontSize: 12, weight: .regular)
        
        txtUserEmail.dynamicText(fontSize: 16, weight: .regular)
        txtPassword.dynamicText(fontSize: 16, weight: .regular)
    }
    
    
    func rootView() {
        let tabbar = UIStoryboard.init(name: "Main", bundle: nil)
            guard let mainView = tabbar.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else {return}
              (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(mainView, animated: false)
    }
    
    func next() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier:"TabBarViewController") as?  TabBarViewController else { return }
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    func viewBtn() {
        emailView.layer.cornerRadius = 8
        emailView.layer.borderWidth = 1
        emailView.layer.borderColor = UIColor(red: 0.804, green: 0.804, blue: 0.804, alpha: 1).cgColor
   
        passwordView.layer.cornerRadius = 8
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor(red: 0.804, green: 0.804, blue: 0.804, alpha: 1).cgColor
        
        buttonLogin.layer.cornerRadius = 8
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
            backBarButtonItem.tintColor = .black
            self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func lbltxt() {
        
        txtUserEmail.layer.borderColor = UIColor.white.cgColor
        
        txtUserEmail.textColor = .black
        txtUserEmail.delegate = self
        txtUserEmail.borderStyle = .none
        txtUserEmail.attributedPlaceholder = NSAttributedString(string: "이메일 주소를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        txtPassword.layer.borderColor = UIColor.white.cgColor
        
        txtPassword.textColor = .black
        txtPassword.delegate = self
        txtPassword.borderStyle = .none
        txtPassword.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

    }
}

extension UIColor {

    /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    ///
    /// - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UILabel {
  func dynamicFont(fontSize size: CGFloat, weight: UIFont.Weight) {
    //let currentFontName = self.font.fontName
    var calculatedFont: UIFont?
    let bounds = UIScreen.main.bounds
    let height = bounds.size.height

    switch height {
    case 480.0: //Iphone 3,4S => 3.5 inch
      calculatedFont = UIFont(name: "Pretendard", size: size * 0.7)
      resizeFont(calculatedFont: calculatedFont, weight: weight)
      break
    case 568.0: //iphone 5, SE => 4 inch
      calculatedFont = UIFont(name: "Pretendard", size: size * 0.8)
      resizeFont(calculatedFont: calculatedFont, weight: weight)
      break
    case 667.0: //iphone 6, 6s, 7, 8 => 4.7 inch
      calculatedFont = UIFont(name: "Pretendard", size: size * 0.92)
      resizeFont(calculatedFont: calculatedFont, weight: weight)
      break
    case 736.0: //iphone 6s+ 6+, 7+, 8+ => 5.5 inch
      calculatedFont = UIFont(name: "Pretendard", size: size * 0.95)
     resizeFont(calculatedFont: calculatedFont, weight: weight)
      break
    case 812.0: //iphone X, XS => 5.8 inch
      calculatedFont = UIFont(name: "Pretendard", size: size)
      resizeFont(calculatedFont: calculatedFont, weight: weight)
      break
    case 896.0: //iphone XR => 6.1 inch  // iphone XS MAX => 6.5 inch
      calculatedFont = UIFont(name: "Pretendard", size: size * 1.15)
      resizeFont(calculatedFont: calculatedFont, weight: weight)
      break
    default:
      print("not an iPhone")
      break
    }
  }
  private func resizeFont(calculatedFont: UIFont?, weight: UIFont.Weight) {
    self.font = calculatedFont
    self.font = UIFont.systemFont(ofSize: calculatedFont!.pointSize, weight: weight)
  }
}

extension UITextField {
  func dynamicText(fontSize size: CGFloat, weight: UIFont.Weight) {
      let currentFontName = self.font!.fontName
    var calculatedFont: UIFont?
    let bounds = UIScreen.main.bounds
    let height = bounds.size.height
    
    switch height {
    case 480.0: //Iphone 3,4S => 3.5 inch
      calculatedFont = UIFont(name: currentFontName, size: size * 0.7)
      resizeFont(calculatedFont: calculatedFont, weight: weight)
      break
    case 568.0: //iphone 5, SE => 4 inch
      calculatedFont = UIFont(name: currentFontName, size: size * 0.8)
      resizeFont(calculatedFont: calculatedFont, weight: weight)
      break
    case 667.0: //iphone 6, 6s, 7, 8 => 4.7 inch
      calculatedFont = UIFont(name: currentFontName, size: size * 0.92)
      resizeFont(calculatedFont: calculatedFont, weight: weight)
      break
    case 736.0: //iphone 6s+ 6+, 7+, 8+ => 5.5 inch
      calculatedFont = UIFont(name: currentFontName, size: size * 0.95)
     resizeFont(calculatedFont: calculatedFont, weight: weight)
      break
    case 812.0: //iphone X, XS => 5.8 inch
      calculatedFont = UIFont(name: currentFontName, size: size)
      resizeFont(calculatedFont: calculatedFont, weight: weight)
      break
    case 896.0: //iphone XR => 6.1 inch  // iphone XS MAX => 6.5 inch
      calculatedFont = UIFont(name: currentFontName, size: size * 1.15)
      resizeFont(calculatedFont: calculatedFont, weight: weight)
      break
    default:
      print("not an iPhone")
      break
    }
  }
  private func resizeFont(calculatedFont: UIFont?, weight: UIFont.Weight) {
    self.font = calculatedFont
    self.font = UIFont.systemFont(ofSize: calculatedFont!.pointSize, weight: weight)
  }
}


extension UILabel {
    func lblAddCharacterSpacing(kernValue:Double = -0.7) {
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
}

extension UITextField {
    func txtAddCharacterSpacing(kernValue:Double = -0.7) {
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
}


extension UILabel {
    func pretendard() {
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.adjustsFontForContentSizeCategory = true
    }
}

extension UILabel {
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }

            attributedString.addAttribute(NSAttributedString.Key.kern,
                                           value: newValue,
                                           range: NSRange(location: 0, length: attributedString.length))

            attributedText = attributedString
        }

        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
}

extension UITextField {
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }

            attributedString.addAttribute(NSAttributedString.Key.kern,
                                           value: newValue,
                                           range: NSRange(location: 0, length: attributedString.length))

            attributedText = attributedString
        }

        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
}
