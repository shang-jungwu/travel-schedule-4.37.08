//
//  FirstTableViewController.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/23.
//

import UIKit
import UniformTypeIdentifiers

class ScheduleTableViewController: UITableViewController {
    
    lazy var schedules = [Schedule]() // 大ㄉ
    lazy var userSchedules = [userSchedule]() // 小ㄉ
    
    
    var addScheduleButton: UIButton!
    var addButtonTag = 0
    let datePickerInAlertSheet = UIDatePicker()
    var sectionDatePickerTag = 0
    let formatter = DateFormatter()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 代理人
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
      
        // Nav
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor(red: 44/255, green: 54/255, blue: 57/255, alpha: 1)

        // Nav title
        let titleLabel = UILabel()
        titleLabel.text = "我的行程"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        // Nav rightBarButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar.badge.plus"), style: .plain, target: self, action: #selector(addDate))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
       
    }

    @objc func addDate() {
        datePickerInAlertSheet.preferredDatePickerStyle = .inline
        datePickerInAlertSheet.datePickerMode = .date
        let alert = UIAlertController(title: "Choose a Date", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePickerInAlertSheet)
        
        // 定位
        datePickerInAlertSheet.translatesAutoresizingMaskIntoConstraints = false
        datePickerInAlertSheet.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: alert.view.frame.height * 0.05).isActive = true
        datePickerInAlertSheet.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        datePickerInAlertSheet.widthAnchor.constraint(equalToConstant: alert.view.frame.width * 0.85).isActive = true

        let okAction = UIAlertAction(title: "Add", style: .default) { _ in
            self.selectDate()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.57)
        alert.view.addConstraint(height)
        // https://stackoverflow.com/questions/25780599/add-datepicker-in-uiactionsheet-using-swift

            self.present(alert, animated: true)
   
    }

    //MARK: - 自訂函式
    // 選擇日期
    func selectDate() {
        let selectedDate = datePickerInAlertSheet.date
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.string(from: selectedDate)
        schedules.append(Schedule(date: date))
        self.tableView.reloadData()
    }
    
    // 更改日期 value change
    @IBAction func dateChange(_ sender: UIDatePicker) {
        formatter.dateFormat = "yyyyMMdd"
        schedules[sender.tag].date = formatter.string(from: sender.date)
        print(schedules[sender.tag])
        self.tableView.reloadData()
    }
    
    @IBAction func datePickerTapped(_ sender: UIDatePicker) {

            print("press date picker")
    }
    
    
    // 更改時間 value change
    @IBAction func timeChange(_ sender: UIDatePicker) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)!
        print(sender.date)
        formatter.dateFormat = "HH:mm"
        schedules[indexPath.section].schedule[indexPath.row].time = formatter.string(from: sender.date)
        print(schedules[indexPath.section].schedule[indexPath.row])
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }



    // 呼叫 bottom sheet
    func presentCollectionSheet() {
        let collectionController = storyboard?.instantiateViewController(identifier: "CollectionSheetVC") as! CollectionTableViewController
        let navController = UINavigationController(rootViewController: collectionController)
        if let sheetPresentationController = navController.sheetPresentationController {
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.largestUndimmedDetentIdentifier = .medium
            sheetPresentationController.detents = [.medium(), .large()]
            sheetPresentationController .preferredCornerRadius = 25
            }
        self.present(navController, animated: true, completion: nil)
        
    }
    

    func presentCustomScheduleSheet() {
        let customScheduleController = storyboard?.instantiateViewController(withIdentifier: "CustomSheetViewController") as! CustomSheetViewController
        customScheduleController.scheduleVC = self
        let navigationController = UINavigationController(rootViewController: customScheduleController)
        let sheetPresentationController = navigationController.sheetPresentationController
        sheetPresentationController?.detents = [.medium()]
        sheetPresentationController?.largestUndimmedDetentIdentifier = .medium
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.preferredCornerRadius = 25
        self.present(navigationController, animated: true)
    }
    
   
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return schedules.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  schedules[section].schedule.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        cell.scheduleLabel.text = schedules[indexPath.section].schedule[indexPath.row].placeName.name
        cell.timePicker.datePickerMode = .time

        formatter.dateFormat = "HH:mm"
        cell.timePicker.date = formatter.date(from: schedules[indexPath.section].schedule[indexPath.row].time)!
        cell.backgroundColor = UIColor(red: 240/255, green: 235/255, blue: 227/255, alpha: 1)
        return cell
    }
    
    // section header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 50
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderTableViewCell") as! SectionHeaderTableViewCell
        cell.contentView.backgroundColor = UIColor(red: 63/255, green: 78/255, blue: 79/255, alpha: 1)
        cell.datePicker.translatesAutoresizingMaskIntoConstraints = false
        cell.datePicker.centerYAnchor.constraint(equalToSystemSpacingBelow: cell.contentView.centerYAnchor, multiplier: 1).isActive = true
        cell.datePicker.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10).isActive = true
        cell.datePicker.overrideUserInterfaceStyle = .dark
        cell.datePicker.tag = section

        formatter.dateFormat = "yyyyMMdd"
        cell.datePicker.date = formatter.date(from: schedules[section].date)!

        addScheduleButton = UIButton(type: .system)
        addScheduleButton.tag = section
        addScheduleButton.frame = CGRect(x: cell.contentView.frame.maxX - 50 - cell.contentView.frame.width * 0.1, y: 0, width: 50, height: 50)
       
        addScheduleButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        addScheduleButton.tintColor = .white
        addScheduleButton.showsMenuAsPrimaryAction = true
        addScheduleButton.menu = UIMenu(children: [
            UIAction(title: "我的收藏", handler: { [self] action in
                presentCollectionSheet()
            }),
            UIAction(title: "新增自訂目的地", handler: { [self] action in
                self.addButtonTag = section
                presentCustomScheduleSheet()

            }),
            UIAction(title: "刪除所選日期", handler: { [self] action in
                let alert = UIAlertController(title: "確定刪除所選日期？", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .cancel))
                alert.addAction(UIAlertAction(title: "確定", style: .destructive, handler: { [self] action in
                    schedules.remove(at: section)
                    tableView.reloadData()
                }))
                self.present(alert, animated: true)
            })
        ])
        cell.contentView.addSubview(addScheduleButton)
        return cell.contentView
    }

    
    // footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 240/255, green: 235/255, blue: 227/255, alpha: 1)
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }
    
    // 滑動刪除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        schedules[indexPath.section].schedule.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "刪除"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailViewController
        detailVC.scheduleVC = self
        detailVC.placeNameLbl.text = ""
    }


} // class ending

extension ScheduleTableViewController: UITableViewDragDelegate, UITableViewDropDelegate{

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let scheduleItem = schedules[indexPath.section].schedule[indexPath.row].placeName
        let data = scheduleItem.name.data(using: .utf8)
        let itemProvider = NSItemProvider(item: NSData(data: data!), typeIdentifier: UTType.plainText.identifier)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        session.localContext = (scheduleItem, indexPath, tableView)
        print(scheduleItem)
        return [dragItem]

    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [UTType.plainText.identifier as String]){
            coordinator.session.loadObjects(ofClass: NSString.self) { items in
                
                guard let string = items.first as? String else { return }
                print("string:", string)
                switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
                //－－－－－－讓 cell 在 Schedule Table View 的任意 section 移動－－－－－－
                case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
                    if sourceIndexPath.section == destinationIndexPath.section {
                        let tmp = self.schedules[sourceIndexPath.section].schedule.remove(at: sourceIndexPath.row)
                        
                        self.schedules[sourceIndexPath.section].schedule.insert(tmp, at: destinationIndexPath.row)
                        print(tmp)
                        self.tableView.reloadData()
                    } else {
                        let tmp = self.schedules[sourceIndexPath.section].schedule.remove(at: sourceIndexPath.row)
                        self.schedules[destinationIndexPath.section].schedule.insert(tmp, at: destinationIndexPath.row)
                        print(tmp)
                        self.tableView.reloadData()
                    }
                    self.tableView.performBatchUpdates(nil)
                    break
                    
                //－－－－－－從sheet移動項目到底面表格－－－－－－
                case (nil, .some(let destinationIndexPath)):

                    self.schedules[destinationIndexPath.section].schedule.insert(userSchedule(placeName: collectionItem), at: destinationIndexPath.row)
                    
//                    self.schedules[destinationIndexPath.section].schedule.insert(userSchedule(placeName: TainanPlaces(name: string, openTime: "", district: "", address: string, tel: "", lat: nil, long: nil)), at: destinationIndexPath.row)

                    self.tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                    self.tableView.performBatchUpdates(nil)
                    print("從sheet移動:",self.schedules)
                    break
                    
                default: break
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
}
