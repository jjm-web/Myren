//
//  ManufacturingViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/10/13.
//

import UIKit
protocol CarModelDataProtocol {
  func modelDataSend(modelData: String)
}

class CarModelViewController: UIViewController {
    
    var tableViewItems  = ["기아", "르노코리아", "쉐보레", "쌍용", "제네시스",
        "현대", "BMW", "닛산", "토요타", "람보르기니"]
    
    var delegate : CarModelDataProtocol?
    var carData : String!
    
    @IBOutlet var btnSelect: UIButton!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let sheetPresentationController = sheetPresentationController {
                sheetPresentationController.detents = [.medium()]
            
            btnSelect.layer.cornerRadius = 16
        }
    }
    
    @IBAction func btnConfirm(_ sender: UIButton) {
        if let text = carData{
              delegate?.modelDataSend(modelData: text)
            }
            
            //4. delegate 처리가 끝난 뒤에, navigation pop처리
            self.dismiss(animated: true)
          }

}


extension CarModelViewController : UITableViewDataSource {
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

extension CarModelViewController : UITableViewDelegate {
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
