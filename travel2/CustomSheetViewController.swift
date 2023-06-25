//
//  CustomSheetViewController.swift
//  travel2
//
//  Created by 吳宗祐 on 2023/6/4.
//

import UIKit


var arrCustomPlace = [TainanPlaces]()

class CustomSheetViewController: UIViewController {
    var customPlace: TainanPlaces!
    weak var scheduleVC: ScheduleTableViewController!
    weak var tabMapVC: TabMapViewController!
        
    @IBOutlet weak var placeNameTxt: UITextField!
    @IBOutlet weak var placeAddressTxt: UITextField!
    @IBOutlet weak var placeTelphoneTxT: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor(red: 249/255, green: 197/255, blue: 85/255, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
    }


    @objc func dismissVC() {
        dismiss(animated: true)
    }

    @IBAction func addCustomSchedule(_ sender: Any) {
        if self.placeNameTxt.text! != "" && self.placeAddressTxt.text! != ""{
            let alert = UIAlertController(title: nil, message: "是否同步新增至我的收藏？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "是", style: .default) { [self] alertAction in
                
                customPlace = TainanPlaces(name: placeNameTxt.text!, openTime: nil, district: nil, address: placeAddressTxt.text!, tel: placeTelphoneTxT.text!, lat: nil, long: nil)
                
                scheduleVC.schedules[scheduleVC.addButtonTag].schedule.append(userSchedule(placeName: customPlace))
                scheduleVC.tableView.reloadData()

                arrCustomPlace.append(customPlace)
                     
                let customPlaceData = try? JSONEncoder().encode(arrCustomPlace.self)
            if let data = customPlaceData{
                UserDefaults.standard.setValue(data, forKey: "customPlaces")
            }

                self.dismiss(animated: true) // enter後收起頁面

            }
            let noAction = UIAlertAction(title: "否", style: .destructive) { [self] action in
                scheduleVC.schedules[scheduleVC.addButtonTag].schedule.append(userSchedule(placeName: TainanPlaces(name: placeNameTxt.text!, openTime: nil, district: nil, address: placeAddressTxt.text!, tel: placeTelphoneTxT.text!, lat: nil, long: nil)))
                scheduleVC.tableView.reloadData()
                self.dismiss(animated: true) // enter後收起頁面

            }
            alert.addAction(noAction)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            
        } else {
            let alert = UIAlertController(title: "狀態", message: "新增失敗", preferredStyle: .alert)
            let action = UIAlertAction(title: "重新輸入", style: .destructive)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear 的 arrcustomplace", arrCustomPlace)
    }

    /*

     let alert = UIAlertController(title: nil, message: "是否同步新增至我的收藏？", preferredStyle: .alert)
     let okAction = UIAlertAction(title: "是", style: .default) { [self] action in
         let collectionController = storyboard?.instantiateViewController(withIdentifier: "CollectionSheetVC") as! CollectionTableViewController
         collectionController.myCollections.append(<#T##newElement: Monster##Monster#>)
         // to do 收藏
     }
     let noAction = UIAlertAction(title: "否", style: .default) { [self] action in
         schedules.append(Schedule())

     }
     alert.addAction(okAction)
     alert.addAction(noAction)

     **/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
