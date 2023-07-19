//
//  ContentViewController.swift
//  travel2
//
//  Created by 吳宗祐 on 2023/7/17.
//

import UIKit

class ContentViewController: UIViewController {
    
    let datePickerInAlertSheet = UIDatePicker()
    let formatter = DateFormatter()
    var childViewController: ScheduleTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Nav
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor(red: 44/255, green: 54/255, blue: 57/255, alpha: 1)

        // 設定 Navigation Bar
        navigationItem.title = "我的行程"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

//        // Nav rightBarButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar.badge.plus"), style: .plain, target: self, action: #selector(addDate))
        navigationItem.rightBarButtonItem?.tintColor = .white

        // Nav lefttBarButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSchedule))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(testRoll))
        navigationItem.leftBarButtonItem?.tintColor = .white

        childViewController = self.children.first as? ScheduleTableViewController


        view.backgroundColor = .systemMint

    }

    @objc func testRoll(){
        // 获取最后一个section的索引
        let lastSection = childViewController.tableView.numberOfSections - 1
        // 获取最后一个row的索引
        let lastRow = childViewController.tableView.numberOfRows(inSection: lastSection) - 1

        if lastSection >= 0 && lastRow >= 0 {
            // 构建要滚动的IndexPath
            let indexPath = IndexPath(row: lastRow, section: lastSection)
            // 滚动tableView
            childViewController.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }


    }


    @objc func saveSchedule(){
        let data = try? JSONEncoder().encode(childViewController.schedules)
        if let data = data {
            UserDefaults.standard.setValue(data, forKey: "userSchedule")
        }
        let alert = UIAlertController(title: "行程已儲存", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)

    }

    @objc func addDate() {
            datePickerInAlertSheet.preferredDatePickerStyle = .inline
            datePickerInAlertSheet.datePickerMode = .date
            let alert = UIAlertController(title: "Choose a Date", message: nil, preferredStyle: .actionSheet)
            alert.view.addSubview(datePickerInAlertSheet)
    
            // date picker 定位
            datePickerInAlertSheet.translatesAutoresizingMaskIntoConstraints = false
            datePickerInAlertSheet.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: alert.view.frame.height * 0.05).isActive = true
            datePickerInAlertSheet.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
            datePickerInAlertSheet.widthAnchor.constraint(equalToConstant: alert.view.frame.width * 0.85).isActive = true
    
        let okAction = UIAlertAction(title: "新增", style: .default) { [self] _ in
                self.selectDate()
                childViewController.tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
    
            let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.57)
            alert.view.addConstraint(height)
            // https://stackoverflow.com/questions/25780599/add-datepicker-in-uiactionsheet-using-swift
            // for ipad only (crash without it)，同時必須註解掉 date picker 定位
    //        let popOverController = alert.popoverPresentationController
    //        popOverController!.barButtonItem = navigationItem.rightBarButtonItem
    
                self.present(alert, animated: true)
    
        }

    // 選擇日期
    func selectDate() {
        let selectedDate = datePickerInAlertSheet.date
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.string(from: selectedDate)
        childViewController.schedules.append(Schedule(date: date))
        childViewController.schedules.sort { date1, date2 in
            date1.date < date2.date
        }
        childViewController.tableView.reloadData()
    }

} // class ending
