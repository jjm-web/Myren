//InsuranceModalViewController
//  InsuranceModalViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/10/12.
//

import UIKit

protocol SampleProtocol {
  func dataSend(insurData: String)
}
class InsuranceModalViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnSelect: UIButton!
    
    var tableViewItems  = ["현대해상", "메리츠화재", "흥국화재", "삼성화재", "동부화재", "AXA손해보험",
        "캐롯손해보험", "DB손해보험", "하나손해보험","KB손해보험", "한화손해보험", "MG손해보험", "롯데손해보험"]
    
    var delegate : SampleProtocol?
    var carData : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        if let sheetPresentationController = sheetPresentationController {
                sheetPresentationController.detents = [.medium()]
            
            btnSelect.layer.cornerRadius = 16
        }
        
      
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnConfirm(_ sender: UIButton) {
        if let text = carData{
              delegate?.dataSend(insurData: text)
            }
            
            //4. delegate 처리가 끝난 뒤에, navigation pop처리
            self.dismiss(animated: true)
          }
}


extension InsuranceModalViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return tableViewItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        let cellLabel = cell.textLabel
        cellLabel?.text = tableViewItems[indexPath.row]
        cellLabel?.font = UIFont(name: "Pretendard-Regular", size: 16.0)
        
       
       
        carData = cellLabel?.text
        return cell
    }
    
  
    
}

extension InsuranceModalViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        let cellLabel = cell.textLabel
        cellLabel?.text = tableViewItems[indexPath.row]
        
        
        carData = cellLabel?.text
        
        btnSelect.isEnabled = true
        btnSelect.backgroundColor = .init(red: 0.898, green: 0.337, blue: 0.133, alpha: 1)
        btnSelect.setTitleColor(.white, for: .normal)
        btnSelect.layer.cornerRadius = 16
    }
}

@IBDesignable extension UITableViewCell {
    @IBInspectable var selectedColor: UIColor? {
        set {
            if let color = newValue {
                selectedBackgroundView = UIView()
                selectedBackgroundView!.backgroundColor = color
            } else {
                selectedBackgroundView = nil
            }
        }
        get {
            return selectedBackgroundView?.backgroundColor
        }
    }
}

