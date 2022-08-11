//
//  CarMenuModalViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/10/25.
//

import UIKit
protocol CarMenuDataProtocol {
  func cmDataSend(cmData: String)
}

class CarMenuModalViewController: UIViewController {
    
    var tableViewItems  = ["경형", "소형", "준중형", "중형", "준대형",
        "대형", "스포츠카"]
    
    var delegate : CarMenuDataProtocol?
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
        
      
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnConfirm(_ sender: UIButton) {
        if let text = carData{
              delegate?.cmDataSend(cmData: text)
            }
            
            //4. delegate 처리가 끝난 뒤에, navigation pop처리
            self.dismiss(animated: true)
          }

}


extension CarMenuModalViewController : UITableViewDataSource {
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

extension CarMenuModalViewController : UITableViewDelegate {
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
