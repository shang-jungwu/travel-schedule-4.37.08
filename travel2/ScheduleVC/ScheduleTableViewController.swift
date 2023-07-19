//
//  FirstTableViewController.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/23.
//

import UIKit
import UniformTypeIdentifiers

class ScheduleTableViewController: UITableViewController, FloatingButtonViewDelegate {

    func btnViewAciton() {

        print("測試浮動按鈕")
    }


    lazy var schedules = [Schedule]() // 包含Date的
    lazy var userSchedules = [userSchedule]() // 每日細項

    var id = "scheduleVC"

    var addScheduleButton: UIButton!
    var addButtonTag = 0
    var collectionButtonTag = 0
    let datePickerInAlertSheet = UIDatePicker()
    var sectionDatePickerTag = 0
    let formatter = DateFormatter()


    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // 代理人
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self

        // Nav
//        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.backgroundColor = UIColor(red: 44/255, green: 54/255, blue: 57/255, alpha: 1)

//        // 設定 Navigation Bar
//        navigationItem.title = "我的行程"
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//
//        // Nav rightBarButton
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar.badge.plus"), style: .plain, target: self, action: #selector(addDate))
//        navigationItem.rightBarButtonItem?.tintColor = .white
//
//        // Nav lefttBarButton
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSchedule))
//        navigationItem.leftBarButtonItem?.tintColor = .white

        if let data = UserDefaults.standard.data(forKey: "userSchedule") {
            schedules = try! JSONDecoder().decode([Schedule].self, from: data)
        }

        // 長按刪除
        let longPress = UILongPressGestureRecognizer(
          target: self,
          action: #selector(longPress))

        // 加入監聽手勢
        self.view.addGestureRecognizer(longPress)

        let floatingButton = FloatingButtonView()
        floatingButton.delegate = self
        floatingButton.addFloatingButton(target: self.view)
        floatingButton.addSubview(floatingButton.topButton)
        floatingButton.addSubview(floatingButton.downButton)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBottomSheetCalled),
            name: .bottomSheetCalled,
            object: nil)

       

    }

    @objc func handleBottomSheetCalled() {
        // 在這裡處理底部彈出窗口的呼叫
        print("Bottom sheet called")
//        let footerFrameY = tableView.rectForFooter(inSection:  collectionButtonTag).maxY
//
//
//        if footerFrameY >= self.view.frame.height * 0.4 {
//            let diff = footerFrameY - self.view.frame.height * 0.4
//            //self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -(diff + 50))
//
//            self.view.frame.origin.y = -(diff + 50)
//            print("完成上移")
//        }

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }



    @objc func longPress(recognizer: UILongPressGestureRecognizer) {
        recognizer.minimumPressDuration = 2.5
        if recognizer.state == .began {
            let alert = UIAlertController(title: "是否刪除所有行程？", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "全部刪除", style: .destructive, handler: { [self]_ in
                schedules.removeAll()
                UserDefaults.standard.removeObject(forKey: "userSchedule")
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .default))
            present(alert, animated: true)
        } else if recognizer.state == .ended {
            print("長按結束")
        }

    }

//    @objc func saveSchedule(){
//        let data = try? JSONEncoder().encode(schedules)
//        if let data = data {
//            UserDefaults.standard.setValue(data, forKey: "userSchedule")
//        }
//        let alert = UIAlertController(title: "行程已儲存", message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//
//    }
//
//    @objc func addDate() {
//        datePickerInAlertSheet.preferredDatePickerStyle = .inline
//        datePickerInAlertSheet.datePickerMode = .date
//        let alert = UIAlertController(title: "Choose a Date", message: nil, preferredStyle: .actionSheet)
//        alert.view.addSubview(datePickerInAlertSheet)
//
//        // date picker 定位
//        datePickerInAlertSheet.translatesAutoresizingMaskIntoConstraints = false
//        datePickerInAlertSheet.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: alert.view.frame.height * 0.05).isActive = true
//        datePickerInAlertSheet.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
//        datePickerInAlertSheet.widthAnchor.constraint(equalToConstant: alert.view.frame.width * 0.85).isActive = true
//
//        let okAction = UIAlertAction(title: "新增", style: .default) { _ in
//            self.selectDate()
//            self.tableView.reloadData()
//        }
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
//        alert.addAction(okAction)
//        alert.addAction(cancelAction)
//
//        let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.57)
//        alert.view.addConstraint(height)
//        // https://stackoverflow.com/questions/25780599/add-datepicker-in-uiactionsheet-using-swift
//        // for ipad only (crash without it)，同時必須註解掉 date picker 定位
////        let popOverController = alert.popoverPresentationController
////        popOverController!.barButtonItem = navigationItem.rightBarButtonItem
//
//            self.present(alert, animated: true)
//
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scheduleShowDetail" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.scheduleVC = self
            detailVC.currentIndex = self.tableView.indexPathForSelectedRow!.row
            detailVC.currentIndexSection = self.tableView.indexPathForSelectedRow!.section
            detailVC.scheduleData = self.schedules
            detailVC.segueID = segue.identifier!
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        // 切換分頁時自動儲存行程
        let data = try? JSONEncoder().encode(schedules)
        if let data = data {
            UserDefaults.standard.setValue(data, forKey: "userSchedule")
        }

    }

    //MARK: - 自訂函式
    // 選擇日期
//    func selectDate() {
//        let selectedDate = datePickerInAlertSheet.date
//        formatter.dateFormat = "yyyyMMdd"
//        let date = formatter.string(from: selectedDate)
//        schedules.append(Schedule(date: date))
//        self.tableView.reloadData()
//    }

    // 更改日期 value change
    @IBAction func dateChange(_ sender: UIDatePicker) {
        formatter.dateFormat = "yyyyMMdd"
        schedules[sender.tag].date = formatter.string(from: sender.date)
        schedules.sort { date1, date2 in
            date1.date < date2.date
        }
        self.tableView.reloadData()
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


    // 呼叫 bottom sheets
    func presentCollectionSheet() {
        let collectionController = storyboard?.instantiateViewController(identifier: "CollectionSheetVC") as! CollectionTableViewController
        collectionController.parentVC = self
        collectionController.calledByID = "aaaa"
        let navController = UINavigationController(rootViewController: collectionController)
        if let sheetPresentationController = navController.sheetPresentationController {
            sheetPresentationController.prefersGrabberVisible = true

            sheetPresentationController.largestUndimmedDetentIdentifier = .medium
            sheetPresentationController.detents = [.medium(), .large()]
            // 有 .large() 時，以下語法可防止滑動表格的動作觸發 sheet 展開到.large()
            sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = false
            sheetPresentationController.preferredCornerRadius = 10
        }

        self.present(navController, animated: true, completion: nil)
        NotificationCenter.default.post(name: .bottomSheetCalled, object: nil)
        
        let footerFrameY = tableView.rectForFooter(inSection:  collectionButtonTag).maxY
        print("footerFrameY:\(footerFrameY)")

//        if  footerFrameY >= 306 && footerFrameY < 896 {
//            collectionController.parentVC_offsetY = -(footerFrameY - 276)
//            print("1")
//        } else
        if footerFrameY > 500 {
            collectionController.parentVC_offsetY = -(UIScreen.main.bounds.height * 0.5 - 80)
            if collectionButtonTag == schedules.count - 1 {
                // 获取最后一个section的索引
                let lastSection = tableView.numberOfSections - 1
                // 获取最后一个row的索引
                let lastRow = tableView.numberOfRows(inSection: lastSection) - 1

                if lastSection >= 0 && lastRow >= 0 {
                    // 构建要滚动的IndexPath
                    let indexPath = IndexPath(row: lastRow, section: lastSection)
                    // 滚动tableView
                    print("滾動")
                    tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }

            }
            print("2")
        } else {
            collectionController.parentVC_offsetY = 0
            print("3")
        }

    }


    func presentCustomScheduleSheet() {
        let customScheduleController = storyboard?.instantiateViewController(withIdentifier: "CustomSheetViewController") as! CustomSheetViewController
        customScheduleController.scheduleVC = self
        customScheduleController.calledByID = self.id
        let navigationController = UINavigationController(rootViewController: customScheduleController)
        let sheetPresentationController = navigationController.sheetPresentationController
        sheetPresentationController?.detents = [.medium()]
        sheetPresentationController?.largestUndimmedDetentIdentifier = .medium
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.preferredCornerRadius = 10
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
        addScheduleButton.frame = CGRect(x: self.view.frame.maxX - 50, y: 0, width: 50, height: 50)
        addScheduleButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        addScheduleButton.tintColor = .white
        addScheduleButton.showsMenuAsPrimaryAction = true
        addScheduleButton.menu = UIMenu(children: [
            UIAction(title: "我的收藏", handler: { [self] action in
                collectionButtonTag = section
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
                    let data = try? JSONEncoder().encode(schedules)
                    if let data = data {
                        UserDefaults.standard.setValue(data, forKey: "userSchedule")
                    }
                    tableView.reloadData()
                }))
                self.present(alert, animated: true)
            })
        ])
        cell.contentView.addSubview(addScheduleButton)
        return cell.contentView
    }


    // section footer
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
        let data = try? JSONEncoder().encode(schedules)
        if let data = data {
            UserDefaults.standard.setValue(data, forKey: "userSchedule")
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "刪除"
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

                //guard let string = items.first as? String else { return }
                switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
                //－－－－－－讓 cell 在 Schedule Table View 的任意 section 移動－－－－－－
                case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
                    if sourceIndexPath.section == destinationIndexPath.section {
                        let tmp = self.schedules[sourceIndexPath.section].schedule.remove(at: sourceIndexPath.row)

                        self.schedules[sourceIndexPath.section].schedule.insert(tmp, at: destinationIndexPath.row)
                        self.tableView.reloadData()
                    } else {
                        let tmp = self.schedules[sourceIndexPath.section].schedule.remove(at: sourceIndexPath.row)
                        self.schedules[destinationIndexPath.section].schedule.insert(tmp, at: destinationIndexPath.row)
                        // print(tmp)
                        self.tableView.reloadData()
                    }
                    self.tableView.performBatchUpdates(nil)
                    break

                //－－－－－－從sheet移動項目到底面表格－－－－－－
                case (nil, .some(let destinationIndexPath)):

                    self.schedules[destinationIndexPath.section].schedule.insert(userSchedule(placeName: collectionItem), at: destinationIndexPath.row)
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

extension Notification.Name {
    static let bottomSheetCalled = Notification.Name("BottomSheetCalled")

}
