//
//  FirstTableViewController.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/23.
//

import UIKit
import UniformTypeIdentifiers

class ScheduleTableViewController: UITableViewController {
    
    lazy var names = [String]()
    lazy var monsters = [userSchedule]()
    lazy var schedules = [Schedule]()
    var addScheduleButton: UIButton!
    var addButtonTag = 0
    let datePicker = UIDatePicker()
    var sectionDatePickerTag = 0
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 代理人
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        // 資料
        fetchCharacter()
        // Nav
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0/255, green: 49/255, blue: 83/255, alpha: 1)
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
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        let alert = UIAlertController(title: "Choose a Date", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 0).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -100).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        
        let okAction = UIAlertAction(title: "Add", style: .default) { _ in
            self.selectDate()
            self.tableView.reloadData()
            print(self.schedules)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 220)
        alert.view.addConstraint(height)
        // https://stackoverflow.com/questions/25780599/add-datepicker-in-uiactionsheet-using-swift
        
        self.present(alert, animated: true)
    }

    
    func selectDate() {
        let selectedDate = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.string(from: selectedDate)
        schedules.append(Schedule(date: date))
        self.tableView.reloadData()
    }
    
    func fetchCharacter() {
        let urlString =  "https://raw.githubusercontent.com/shang-jungwu/json/main/pokemon.json"
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    let decoder = JSONDecoder()
                    do {

                        self.names = try decoder.decode([String].self, from: data)
                        self.names.shuffle()

                        for i in 0...9{
                            self.monsters.append(userSchedule(name:self.names[i]))
                        }
                        self.schedules.append(Schedule(schedule: self.monsters))

                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            print(self.schedules)
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
   

    @IBSegueAction func showCollectionSheet(_ coder: NSCoder) -> UINavigationController? {
        let controller = UINavigationController(coder: coder)
        controller!.navigationBar.backgroundColor = .systemTeal
        if let sheetPresentationController = controller?.sheetPresentationController{
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.largestUndimmedDetentIdentifier = .medium
            sheetPresentationController .preferredCornerRadius = 25
            sheetPresentationController.detents = [.medium()]
        }
        return controller
    }

    @IBAction func timeChange(_ sender: UIDatePicker) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)!
        print(sender.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        schedules[indexPath.section].schedule[indexPath.row].time = formatter.string(from: sender.date)
        print(schedules[indexPath.section].schedule[indexPath.row])
        self.tableView.reloadRows(at: [indexPath], with: .automatic)

    }

    @IBAction func dateChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        schedules[sender.tag].date = formatter.string(from: sender.date)
        print(schedules[sender.tag].date)
        self.tableView.reloadData()
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
        cell.scheduleLabel.text =  schedules[indexPath.section].schedule[indexPath.row].name
        cell.timePicker.datePickerMode = .time
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        cell.timePicker.date = formatter.date(from: schedules[indexPath.section].schedule[indexPath.row].time)!
        cell.backgroundColor = UIColor(red: 214/255, green: 231/255, blue: 242/255, alpha: 1)
        cell.layer.cornerRadius = 5

        return cell
    }
    
    // section header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 50
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderTableViewCell") as! SectionHeaderTableViewCell
        cell.contentView.backgroundColor = UIColor(red: 232/255, green: 150/255, blue: 182/255, alpha: 1)
        cell.datePicker.backgroundColor = UIColor(red: 232/255, green: 150/255, blue: 182/255, alpha: 1)
        cell.datePicker.tag = section
        cell.datePicker.becomeFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        cell.datePicker.date = formatter.date(from: schedules[section].date)!
        cell.contentView.layer.cornerRadius = 10
        addScheduleButton = UIButton(type: .system)
        addScheduleButton.tag = section
        addScheduleButton.frame = CGRect(x: cell.contentView.frame.maxX - 80, y: 0, width: 50, height: 50)
        addScheduleButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        addScheduleButton.tintColor = .gray
        addScheduleButton.showsMenuAsPrimaryAction = true
        addScheduleButton.menu = UIMenu(children: [
            UIAction(title: "Collection", handler: { [self] action in
                let collectionController = storyboard?.instantiateViewController(withIdentifier: "CollectionSheetVC") as! CollectionTableViewController
                collectionController.tableView.reloadData()
                
                self.performSegue(withIdentifier: "showCollectionSheet", sender: nil)
            }),
            UIAction(title: "Cutsom Destination", handler: { action in
                self.addButtonTag = section
                if let customController = self.storyboard?.instantiateViewController(withIdentifier: "addCustomScheduleVC") as? CustomSheetViewController {
                    customController.scheduleVC = self
                    customController.buttonTag = self.addButtonTag
                    let navigationController = UINavigationController(rootViewController: customController)
                    let sheetPresentationController = navigationController.sheetPresentationController
                    sheetPresentationController?.detents = [.medium()]
                    sheetPresentationController?.largestUndimmedDetentIdentifier = .medium
                    sheetPresentationController?.prefersGrabberVisible = true
                    sheetPresentationController?.preferredCornerRadius = 25
                    self.present(navigationController, animated: true)
                }
            }),
            UIAction(title: "Delete Date", handler: { [self] action in
                let alert = UIAlertController(title: "確定刪除所選日期？", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .cancel))
                alert.addAction(UIAlertAction(title: "確定", style: .destructive, handler: { [self] action in
                    schedules.remove(at: section)
                    tableView.reloadData()
                }))
                self.present(alert, animated: true)
                print("刪除date to do")
            })
        ])
        cell.contentView.addSubview(addScheduleButton)
        return cell.contentView
    }

    
    // footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 232/255, green: 150/255, blue: 182/255, alpha: 0.5)
        footerView.layer.cornerRadius = 5
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


} // class ending

extension ScheduleTableViewController: UITableViewDragDelegate, UITableViewDropDelegate{

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let scheduleItem = schedules[indexPath.section].schedule[indexPath.row]
        let data = scheduleItem.name.data(using: .utf8)
        let itemProvider = NSItemProvider(item: NSData(data: data!), typeIdentifier: UTType.plainText.identifier)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        session.localContext = (scheduleItem, indexPath, tableView)
        return [dragItem]

    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [UTType.plainText.identifier as String]){
            coordinator.session.loadObjects(ofClass: NSString.self) { (items) in
                guard let string = items.first as? String else{ return }

                switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
                //－－－－－－讓 cell 在 Schedule Table View 的任意 section 移動－－－－－－
                case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
                    if sourceIndexPath.section == destinationIndexPath.section {
                        let tmp = self.schedules[sourceIndexPath.section].schedule.remove(at: sourceIndexPath.row)
                        self.schedules[sourceIndexPath.section].schedule.insert(tmp, at: destinationIndexPath.row)
                        print(tmp)
                        //print(string)
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
                    self.schedules[destinationIndexPath.section].schedule.insert(userSchedule(name: string), at: destinationIndexPath.row)
                    self.tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                    self.tableView.performBatchUpdates(nil)
                    print("case2",self.schedules)
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
