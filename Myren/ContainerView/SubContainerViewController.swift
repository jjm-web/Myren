//
//  SubContainerViewController.swift
//  Myren
//
//  Created by 장준명 on 2022/10/31.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase


class SubContainerViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet var subViewDR: UIView!
    @IBOutlet var miniYesterday: UIView!
    @IBOutlet var miniToday: UIView!
    
    @IBOutlet var subViewUniqueness: UIView!
    @IBOutlet var miniTable: UITableView!
    
    @IBOutlet var lblYesterday: UILabel!
    @IBOutlet var lblToday: UILabel!
    
    @IBOutlet var lbl_1: UILabel!
    @IBOutlet var lbl_2: UILabel!
    @IBOutlet var lbl_3: UILabel!
    @IBOutlet var lbl_4: UILabel!
    @IBOutlet var lbl_5: UILabel!
    @IBOutlet var lbl_6: UILabel!
    
    
    @IBOutlet var btnDetails: UIButton!
    
    var timeArray : [String] = []
    var accidentArray : [String] = []
    
    //let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDisign()

        ref = Database.database().reference()
        miniTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        miniTable.delegate = self
        miniTable.dataSource = self
   
//        labelFont()
//        let carinformation =  realm.objects(SubData.self)
//        let key = carinformation.filter("randomKey")
//        let timeDate = carinformation.filter("realmDate")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accidenTime()
        accidentType() 
    }
    
    func labelFont() {
        lbl_1.dynamicFont(fontSize: 20, weight: .semibold)
        lbl_2.dynamicFont(fontSize: 14, weight: .regular)
        lbl_3.dynamicFont(fontSize: 12, weight: .regular)
        lbl_4.dynamicFont(fontSize: 12, weight: .regular)
        lbl_5.dynamicFont(fontSize: 20, weight: .semibold)
        lbl_6.dynamicFont(fontSize: 14, weight: .regular)
        lblYesterday.dynamicFont(fontSize: 25, weight: .bold)
        lblToday.dynamicFont(fontSize: 36, weight: .bold)
        
    }
    
    
    func accidenTime() {
         var orderedQuery:DatabaseQuery?
         orderedQuery = ref?.child("MyRen").child("DrivingRecord").queryOrdered(byChild: "date")
         orderedQuery?.observeSingleEvent(of: .value, with: { snapshot in
         let value = snapshot.value as? String ?? ""
         DispatchQueue.main.async {
             self.timeArray.append(value)
             }
                 }) { error in
             print(error.localizedDescription)
         }
     }
    
    
   func accidentType() {
        var orderedQuery:DatabaseQuery?
        orderedQuery = ref?.child("MyRen").child("DrivingRecord").queryOrdered(byChild: "accidentType")
        orderedQuery?.observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? String ?? ""
        DispatchQueue.main.async {
            self.accidentArray.append(value)
            }
                }) { error in
            print(error.localizedDescription)
        }
    }

    func viewDisign() {
        
        // 주행거리를 확인... view
        subViewDR.viewShadow()
        subViewDR.viewBoarder()
        //주행 중 특이사항... view
        subViewUniqueness.viewShadow()
        subViewUniqueness.viewBoarder()
        //subviewDR 안 view
        miniYesterday.viewBoarder()
        miniToday.viewBoarder()
        //subViewUniqueness 안 table
        miniTable.viewBoarder()
    }

}

extension SubContainerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell else {
             return UITableViewCell()
        }
        
//        var orderedQuery:DatabaseQuery?
//        orderedQuery = ref?.child("MyRen").child("DrivingRecord").queryOrdered(byChild: "date")
//        orderedQuery?.observeSingleEvent(of: .value, with: { snapshot in
//        let value = snapshot.value as? String ?? ""
//        DispatchQueue.main.async {
//            self.timeArray.append(value)
//            }
//                }) { error in
//            print(error.localizedDescription)
//        }
//
//        //var orderedQuery:DatabaseQuery?
//        orderedQuery = ref?.child("MyRen").child("DrivingRecord").queryOrdered(byChild: "accidentType")
//        orderedQuery?.observeSingleEvent(of: .value, with: { snapshot in
//        let value = snapshot.value as? String ?? ""
//        DispatchQueue.main.async {
//            self.accidentArray.append(value)
//            }
//                }) { error in
//            print(error.localizedDescription)
//        }
//
//
//        Cell.lblTime.text = timeArray[indexPath.row]
//        Cell.lblAccidentType.text = accidentArray[indexPath.row]
//        Cell.IMGAccident.image = UIImage(named: "danger")
//
        return Cell
    }
}

class Cell : UITableViewCell {
    @IBOutlet var IMGAccident: UIImageView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblAccidentType: UILabel!
}
