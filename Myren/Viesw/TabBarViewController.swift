//
//  TabBarViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/11/01.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabbar()
        self.navigationController?.addCustomBottomLine(color: UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), height: 1.0)
    }
    
   
    
}

extension UINavigationController {
    func naviagation() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

extension UITabBarController {
    func tabbar() {
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = CGColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        tabBar.clipsToBounds = true
    }
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
    var sizeThatFits = super.sizeThatFits(size)
    sizeThatFits.height = 90 // 원하는 길이
    return sizeThatFits
   }
}
