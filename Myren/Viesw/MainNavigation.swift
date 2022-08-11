//
//  MainNavigation.swift
//  Myren
//
//  Created by 장준명 on 2022/11/15.
//

import UIKit

class MainNavigation: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.addCustomBottomLine(color: UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), height: 1.0)
    }
    



}
