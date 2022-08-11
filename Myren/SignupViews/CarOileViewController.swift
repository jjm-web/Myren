//
//  CarOileViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/12/20.
//

import UIKit

protocol CarOileDataProtocol {
  func coDataSend(coData: String)
}
class CarOileViewController: UIViewController {
    
    var tableViewItems  = ["휘발유(가솔린)", "경유(디젤)", "액화석유가스(LPG)", "압축천연가스(CNG)", "하이브리드",
        "전기", "수소"]
    
    var delegate : CarOileDataProtocol?
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
              delegate?.coDataSend(coData: text)
            }
            
            self.dismiss(animated: true)
          }

}

extension CarOileViewController : UITableViewDataSource {
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

extension CarOileViewController : UITableViewDelegate {
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
