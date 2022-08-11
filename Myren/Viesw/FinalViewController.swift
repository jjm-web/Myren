//
//  FinalViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/12/19.
//

import UIKit

class FinalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnNext(_ sender: Any) {
     
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    
    @IBAction func btnNextItem(_ sender: Any) {
     
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true)
    }

}
