//
//  SignUpViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/08/22.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import IQKeyboardManagerSwift
class SignUpViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!    
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirm: UITextField!
    @IBOutlet weak var lblPasswordConfirmed: UILabel!
    @IBOutlet weak var txtCarNumber: UITextField!
    @IBOutlet weak var pkvInsurance: UIPickerView!
    @IBOutlet weak var txtCarName: UITextField!
    @IBOutlet weak var txtProtector: UITextField!
    
    @IBOutlet weak var buttonSignup: UIButton!
    @IBOutlet var buttonBack: UIButton!
    var ref: DatabaseReference!
    var InsuranceList = ["삼성화재", "한화손해보험", "DB손해보험", "롯데손해보험", "메리츠화재", "하나손해보험", "현대해상", "KB손해보험", "AXA손해보험", "흥국화재", "MG손해보험"]
    var selectedInteresting: String!
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 피커뷰 딜리게이트, 데이터소스 연결
        pkvInsurance.delegate = self
        pkvInsurance.dataSource = self
        // 텍스트 필드에 대한 딜리게이트, 데이터소스 연결 - 유효성 검사에서 필요함
        txtName.delegate = self
        txtUserEmail.delegate = self
        txtPassword.delegate = self
        txtPasswordConfirm.delegate = self
        txtCarNumber.delegate = self
        txtCarName.delegate = self
        txtProtector.delegate = self

        // firebase reference 초기화
        ref = Database.database().reference()
        // 멤버 변수 초기화
        selectedInteresting = InsuranceList[0]
        // 패스워드 일치 여부를 표시하는 레이블을 빈 텍스트로
        lblPasswordConfirmed.text = ""
        buttonSignup.layer.cornerRadius = 8
        
}

    func simpleAlert(_ controller: UIViewController, message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "닫기", style: .default, handler: {
            (action) in
            let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            LoginViewController?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            LoginViewController?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(LoginViewController!, animated: true, completion: nil)
            })
            alertController.addAction(alertAction)
            controller.present(alertController, animated: true, completion: nil)
    }
    
    func errorAlert(_ controller: UIViewController, message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let alertErrorAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
        alertController.addAction(alertErrorAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnActSubmit(_ sender: UIButton) {
        
        guard let userEmail = txtUserEmail.text,
              let userPassword = txtPassword.text,
              let userName = txtName.text,
              let userCarName = txtCarName.text,
              let userCarNumber = txtCarNumber.text,
              let userProtector = txtProtector.text,              
              let userPasswordConfirm = txtPasswordConfirm.text else {
            return
        }
 	           
        guard userPassword != ""
                && userPasswordConfirm != ""
                && userPassword == userPasswordConfirm else {
            errorAlert(self, message: "형식이 맞지않습니다...")
            return
        }
               
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [self] authResult, error in
            // 이메일, 비밀번호 전송
        guard let user = authResult?.user, error == nil else {
            errorAlert(self, message: error!.localizedDescription)
            return
        }
                   
        // 추가 정보 입력
        ref.child("users").child(user.uid).setValue(["userName":  txtName.text,"userPassword" : txtPassword.text, "InsuranceList": selectedInteresting, "userCarName": txtCarName.text, "userCarNumber": txtCarNumber.text, "userProtector": txtProtector.text])
                   
            simpleAlert(self, message: "\(user.email!) 님의 회원가입이 완료되었습니다.")

        }
    }
}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // 컴포넌트(열) 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 리스트(행) 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return InsuranceList.count
    }
    
    // 피커뷰 목록 표시
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return InsuranceList[row]
    }
    
    // 특정 피커뷰 선택시 selectedInteresting에 할당
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedInteresting = InsuranceList[row]

    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func setLabelPasswordConfirm(_ password: String, _ passwordConfirm: String)  {
        
        guard passwordConfirm != "" else {
            lblPasswordConfirmed.text = ""
            return
        }
        
        if password == passwordConfirm {
            lblPasswordConfirmed.textColor = .orange
            lblPasswordConfirmed.text = "패스워드가 일치합니다."
        } else {
            lblPasswordConfirmed.textColor = .red
            lblPasswordConfirmed.text = "패스워드가 일치하지 않습니다."
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
extension String {

    // MARK: - An expert's solution to weird string manupulations.
    // https://stackoverflow.com/questions/39677330/how-does-string-substring-work-in-swift
    
    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}


