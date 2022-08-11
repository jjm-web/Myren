//
//  ThirdNavigation.swift
//  Myren
//
//  Created by 장준명 on 2022/11/15.
//

import UIKit

class ThirdNavigation: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.addCustomBottomLine(color: UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), height: 1.0)
        self.navigationBar.bottomLine(color: UIColor.lightGray, height: 1.0)
        //self.navigationBar.bottomLine(color: UIColor.lightGray, height: 1.0)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
