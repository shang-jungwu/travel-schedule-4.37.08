//
//  CustomSheetViewController.swift
//  travel2
//
//  Created by 吳宗祐 on 2023/6/4.
//

import UIKit

class CustomSheetViewController: UIViewController {

    var calledByID = ""
    var mapTapPlaceName = ""
    var mapTapPlaceAddress = ""

    var customPlace: TainanPlaces!
    var arrCustomPlace: [TainanPlaces]!

    weak var scheduleVC: ScheduleTableViewController!
        
    @IBOutlet weak var placeNameTxt: UITextField!
    @IBOutlet weak var placeAddressTxt: UITextField!
    @IBOutlet weak var placeTelphoneTxT: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor(red: 249/255, green: 197/255, blue: 85/255, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))

        self.placeNameTxt.text! = mapTapPlaceName
        self.placeAddressTxt.text! = mapTapPlaceAddress

        if let data = UserDefaults.standard.data(forKey: "customPlaces") {
            arrCustomPlace = try! JSONDecoder().decode([TainanPlaces].self, from: data)
        }

    }


    @objc func dismissVC() {
        dismiss(animated: true)
    }

    @IBAction func addCustomSchedule(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        if self.placeNameTxt.text! != "" && self.placeAddressTxt.text! != ""{
            // alert actions
            let okAction = UIAlertAction(title: "是", style: .default) { [self] alertAction in
                if calledByID == "scheduleVC" {
                    scheduleVC.schedules[scheduleVC.addButtonTag].schedule.append(userSchedule(placeName: TainanPlaces(name: placeNameTxt.text!, openTime: nil, district: nil, address: placeAddressTxt.text!, tel: placeTelphoneTxT.text!, lat: nil, long: nil)))
                    scheduleVC.tableView.reloadData()
                }
                customPlace = TainanPlaces(name: placeNameTxt.text!, openTime: nil, district: nil, address: placeAddressTxt.text!, tel: placeTelphoneTxT.text!, lat: nil, long: nil)
                arrCustomPlace.append(customPlace)
                let customPlaceData = try? JSONEncoder().encode(arrCustomPlace.self)
            if let data = customPlaceData {
                UserDefaults.standard.setValue(data, forKey: "customPlaces")
            }
                self.dismiss(animated: true) // 點擊後收起頁面
            }
            let noAction = UIAlertAction(title: "否", style: .destructive) { [self] action in
                scheduleVC.schedules[scheduleVC.addButtonTag].schedule.append(userSchedule(placeName: TainanPlaces(name: placeNameTxt.text!, openTime: nil, district: nil, address: placeAddressTxt.text!, tel: placeTelphoneTxT.text!, lat: nil, long: nil)))
                scheduleVC.tableView.reloadData()
                self.dismiss(animated: true) // 點擊後收起頁面
            }

            let cancelAction = UIAlertAction(title: "取消", style: .default)

            switch calledByID {
                case "TabMapViewController":
                    alert.message = "新增至我的收藏？"
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)

                case "scheduleVC":
                    alert.message = "同步新增至我的收藏？"
                    alert.addAction(noAction)
                    alert.addAction(okAction)

                default:
                    break
            }
            
        } else {
            alert.title = "狀態"
            alert.message = "新增失敗"
            let retypeAction = UIAlertAction(title: "重新輸入", style: .destructive)
            alert.addAction(retypeAction)
        }
        self.present(alert, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {

    }


    
}
