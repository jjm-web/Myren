//
//  SignupAccessViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/10/06.
//

import UIKit

class SignupAccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.5) {
            guard let nextVC = self.storyboard?.instantiateViewController(identifier:"LoginViewController") as?  LoginViewController else { return }
                    nextVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(nextVC, animated: true)
       
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true)
    }
    
}
