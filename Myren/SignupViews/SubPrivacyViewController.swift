//
//  SubPrivacyViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/10/06.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseAuth

class SubPrivacyViewController: UIViewController, SampleProtocol, CarMenuDataProtocol, CarModelDataProtocol, CarOileDataProtocol {
   
    func modelDataSend(modelData: String) {
        txtCarModel.text = modelData
    }
    
    
    func cmDataSend(cmData: String) {
        txtCarType.text = cmData
    }
    
    func coDataSend(coData: String) {
        txtCarOile.text = coData
    }
    
    func dataSend(insurData: String) {
        txtInsurance.text = insurData
    }

    @IBOutlet var viewCarNum: UIView!
    @IBOutlet var viewCarModel: UIView!
    @IBOutlet var viewCarType: UIView!
    @IBOutlet var viewCarOile: UIView!
    @IBOutlet var viewInsurance: UIView!
    @IBOutlet var viewGuardianTell: UIView!
    
    @IBOutlet var lblMenu: UILabel!
    @IBOutlet var lblPage: UILabel!
    
    @IBOutlet var lblCarNum: UILabel!
    @IBOutlet var lblCarModel: UILabel!
    @IBOutlet var lblCarType: UILabel!
    @IBOutlet var lblCarOile: UILabel!
    @IBOutlet var lblInsurance: UILabel!
    @IBOutlet var lblGuardianTell: UILabel!
    
    @IBOutlet var txtCarNum: UITextField!
    @IBOutlet var txtCarModel: UITextField!
    @IBOutlet var txtCarType: UITextField!
    @IBOutlet var txtCarOile: UITextField!
    @IBOutlet var txtInsurance: UITextField!
    @IBOutlet var txtGuardianTell: UITextField!
    
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet var btnCarModel: UIButton!
    @IBOutlet var btnCarMenu: UIButton!
    @IBOutlet var btnCarOile: UIButton!
    @IBOutlet var btnInsurance: UIButton!
    
    @IBOutlet var backBtnItem: UIBarButtonItem!
    @IBOutlet var btnItemSubmit: UIBarButtonItem!
    
    var nameData: String!
    var emailData: String!
    var passwordData: String!
    
    var ref: DatabaseReference!
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    
    @IBAction func btnNext(_ sender: Any) {
        creatUser()
        nextNavigation()
//        self.navigationController?.popToRootViewController(animated: true)
//        self.dismiss(animated: true)
    }
    
    
    @IBAction func btnNextItem(_ sender: Any) {
        creatUser()
        nextNavigation()
//        self.navigationController?.popToRootViewController(animated: true)
//        self.dismiss(animated: true)
    }
    
    func nextNavigation() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier:"FinalViewController") as? FinalViewController else { return }
           
        nextVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nextVC, animated: true)
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        btnSubmit.btnRadius()
        
        txtCarNum.delegate = self
        txtCarModel.delegate = self
        txtCarType.delegate = self
        txtCarOile.delegate = self
        txtInsurance.delegate = self
        txtGuardianTell.delegate = self
        
        //textfildLayout()
        layOut()
        
        btnCarModel.addTarget(self, action: #selector(didTapModelButton), for: .touchUpInside)
        btnCarMenu.addTarget(self, action: #selector(didTapMeuButton), for: .touchUpInside)
        btnCarOile.addTarget(self, action: #selector(didTapOileButton), for: .touchUpInside)
        btnInsurance.addTarget(self, action: #selector(didTapInsButton), for: .touchUpInside)
        
        
    }
    
    @objc private func didTapModelButton(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier:"CarModelViewController") as? CarModelViewController else { return }
        nextVC.delegate = self
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc private func didTapMeuButton(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier:"CarMenuModalViewController") as? CarMenuModalViewController else { return }
        nextVC.delegate = self
        self.present(nextVC, animated: true, completion: nil)
    }
    

    @objc private func didTapOileButton(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier:"CarOileViewController") as? CarOileViewController else { return }
        nextVC.delegate = self
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc private func didTapInsButton(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier:"InsuranceModalViewController") as? InsuranceModalViewController else { return }
        nextVC.delegate = self
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func layOut() {
//        lblMenu.dynamicFont(fontSize: 22, weight: .semibold)
//        lblPage.dynamicFont(fontSize: 12, weight: .regular)
//
//        lblCarNum.dynamicFont(fontSize: 12, weight: .regular)
//        lblCarModel.dynamicFont(fontSize: 12, weight: .regular)
//        lblCarType.dynamicFont(fontSize: 12, weight: .regular)
//        lblCarOile.dynamicFont(fontSize: 12, weight: .regular)
//        lblInsurance.dynamicFont(fontSize: 12, weight: .regular)
//        lblGuardianTell.dynamicFont(fontSize: 12, weight: .regular)
//
//        txtCarNum.dynamicText(fontSize: 16, weight: .regular)
//        txtCarOile.dynamicText(fontSize: 16, weight: .regular)
//        txtInsurance.dynamicText(fontSize: 16, weight: .regular)
//        txtCarType.dynamicText(fontSize: 16, weight: .regular)
//        txtCarModel.dynamicText(fontSize: 16, weight: .regular)
//        txtGuardianTell.dynamicText(fontSize: 16, weight: .regular)
        
        viewCarNum.viewBoard()
        viewCarModel.viewBoarder()
        viewCarType.viewBoard()
        viewCarOile.viewBoarder()
        viewInsurance.viewBoard()
        viewGuardianTell.viewBoarder()
        
        txtCarNum.txtBoard()
        txtCarModel.txtBoard()
        txtCarType.txtBoard()
        txtCarOile.txtBoard()
        txtInsurance.txtBoard()
        txtGuardianTell.txtBoard()
    }
    
    func creatUser() {
        
        guard let userCarName = txtCarModel.text,
              let userCarNumber = txtCarNum.text,
              let userCarType = txtCarType.text,
              let userCarOile = txtCarOile.text,
              let userGuardianTell = txtGuardianTell.text,
              let usertxtInsurance = txtInsurance.text,
              let userEmail = emailData,
              let userPassword = passwordData,
              let userName = nameData else {
            return
        }
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [self] authResult, error in
            // 이메일, 비밀번호 전송
        guard let user = authResult?.user, error == nil else {
            return
        }
                   
        // 추가 정보 입력
            ref.child("MyRen").child("UserAccount").child(user.uid).setValue(["idToken": user.uid,
                                                                              "emailId": userEmail,
                                                                              "password": userPassword,
                                                                              "name": userName,
                                                                              "carNumber":  userCarNumber,
                                                                              "carType" : userCarType,
                                                                              "displacement" : userCarName,
                                                                              "fuel" : userCarOile,
                                                                              "insuranceCompany": usertxtInsurance,
                                                                              "parentPhoneNumber": userGuardianTell,
                                                                             ])
        }
    }
}

extension SubPrivacyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if !text.isEmpty {
            btnSubmit.isEnabled = true
            btnItemSubmit.isEnabled = true
            
        } else {
            btnSubmit.isEnabled = false
            btnItemSubmit.isEnabled = false
        }
        return true
    }
}

