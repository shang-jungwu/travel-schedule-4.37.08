//
//  CustomSheetViewController.swift
//  travel2
//
//  Created by 吳宗祐 on 2023/6/4.
//

import UIKit

class CustomSheetViewController: UIViewController {

    weak var scheduleVC: ScheduleTableViewController!
    weak var collectionVC: CollectionTableViewController!
    var buttonTag = 0
    
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .systemYellow
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissSelf))
    }

    override func viewWillAppear(_ animated: Bool) {
        print("Will Appear", buttonTag)
    }

    @objc func dismissSelf(){
        dismiss(animated: true)
    }

    @IBAction func addCustomSchedule(_ sender: Any) {
        if self.placeName.text! != "" {
            let alert = UIAlertController(title: nil, message: "是否同步新增至我的收藏？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "是", style: .default) { [self] alertAction in
                scheduleVC.schedules[buttonTag].schedule.append(userSchedule(name: placeName.text!))
//                let collectionController = storyboard?.instantiateViewController(withIdentifier: "CollectionSheetVC") as! CollectionTableViewController
//                collectionController.myCollections.append(Monster(name: placeName.text!))
                collectionVC.myCollections.append(userSchedule(name: placeName.text!))
                scheduleVC.tableView.reloadData()
                collectionVC.tableView.reloadData()
                print("collectionController.myCollections:", collectionVC.myCollections)
                self.dismiss(animated: true) // enter後收起頁面

            }
            let noAction = UIAlertAction(title: "否", style: .destructive) { [self] action in
                scheduleVC.schedules[buttonTag].schedule.append(userSchedule(name: placeName.text!))
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
