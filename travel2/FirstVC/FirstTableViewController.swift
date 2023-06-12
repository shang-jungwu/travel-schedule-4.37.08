//
//  FirstTableViewController.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/23.
//

import UIKit
import UniformTypeIdentifiers

class FirstTableViewController: UITableViewController {
    
    lazy var names = [String]()
    lazy var board = [Board]()
    lazy var monsters = [Monster]()
    lazy var schedules = [Schedule]()
    lazy var customSchedule = [Monster]()
    var addScheduleButton: UIButton!
    var addButtonTag = 0
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        fetchCharacter()
       // self.tableView.isEditing = true

    }


    func fetchCharacter(){
        let urlString =  "https://raw.githubusercontent.com/shang-jungwu/json/main/pokemon.json"
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    let decoder = JSONDecoder()
                    do {

                        self.names = try decoder.decode([String].self, from: data)
                        self.names.shuffle()

                        for i in 0...9{
                            self.monsters.append(Monster(name:self.names[i]))
                        }
                        //假資料：測試兩個section
                        self.schedules.append(Schedule(schedule: self.monsters))
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


    @IBSegueAction func showCustomSheet(_ coder: NSCoder) -> UINavigationController? {
        let controller = UINavigationController(coder: coder)
        controller!.navigationBar.backgroundColor = .systemYellow
        if let sheetPresentationController = controller?.sheetPresentationController{
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.largestUndimmedDetentIdentifier = .medium
            sheetPresentationController .preferredCornerRadius = 25
            sheetPresentationController.detents = [.medium()]
        }
        return controller
    }


    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return schedules.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  schedules[section].schedule.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstTableViewCell", for: indexPath) as! FirstTableViewCell
        cell.scheduleLabel.text =  schedules[indexPath.section].schedule[indexPath.row].name
        //let formatter = DateFormatter()

        cell.timePicker.datePickerMode = .time
        //cell.timePicker.date = formatter.date(from: schedules[indexPath.section].schedule[indexPath.row].time)!
            return cell
    }
    
    // section header

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 50
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderTableViewCell") as! SectionHeaderTableViewCell
        addScheduleButton = UIButton(type: .system)
        addScheduleButton.tag = section
        addScheduleButton.frame = CGRect(x: 333, y: 0, width: 50, height: 50)
        addScheduleButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addScheduleButton.backgroundColor = .systemCyan
        addScheduleButton.tintColor = .white
        addScheduleButton.layer.cornerRadius = 25
        addScheduleButton.showsMenuAsPrimaryAction = true
        addScheduleButton.menu = UIMenu(children: [
            UIAction(title: "Collection", handler: { action in
                self.performSegue(withIdentifier: "showCollectionSheet", sender: nil)
            }),
            UIAction(title: "Cutsom Destination", handler: { action in
                self.addButtonTag = section
                if let customController = self.storyboard?.instantiateViewController(withIdentifier: "addCustomScheduleVC") as? CustomSheetViewController {
                    customController.scheduleVC = self
                    customController.buttonTag = self.addButtonTag
                    //print("customController.buttonTag:", customController.buttonTag)
                    self.present(customController, animated: true)
                }
               // print("section",section)
               // self.addButtonTag = section
                
            })
        ])
        cell.contentView.addSubview(addScheduleButton)
        //let formatter = DateFormatter()
        //cell.datePicker.date = formatter.date(from: schedules[section].date)!

        return cell.contentView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let customController = storyboard?.instantiateViewController(withIdentifier: "addCustomScheduleVC") as? CustomSheetViewController {
//            customController.scheduleVC = self
//            customController.buttonTag = self.addButtonTag
//            print("customController.buttonTag:", customController.buttonTag)
//        }
    }

    
    // 滑動刪除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        schedules[indexPath.section].schedule.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "刪除"
    }


    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true // 所有儲存格都能移動
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // step1: 依照表格順序對調離線資料集
        let tmp = schedules[sourceIndexPath.section].schedule.remove(at: sourceIndexPath.row)
        //("tmp:",tmp)
        schedules[sourceIndexPath.section].schedule.insert(tmp, at: destinationIndexPath.row)
        //print("來源:\(sourceIndexPath.row)，目的地:\(destinationIndexPath.row)")
        // step2: 將目前順序回寫到資料庫（必須有對應紀錄順序的欄位）
        // to do
    }

} // class ending

extension FirstTableViewController: UITableViewDragDelegate, UITableViewDropDelegate{
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let aaa = schedules[indexPath.section].schedule[indexPath.row]
        let data = aaa.name.data(using: .utf8)

        


        let itemProvider = NSItemProvider(item: NSData(data: data!), typeIdentifier: UTType.plainText.identifier)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        session.localContext = (aaa, indexPath, tableView)
        return [dragItem]

        
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [UTType.plainText.identifier as String]){
            coordinator.session.loadObjects(ofClass: NSString.self) { (items) in
                guard let string = items.first as? String else{ return }

                var updatedIndexPaths = [IndexPath]()
                switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
                //－－－－－－在底面的同一個表格內移動項目－－－－－－
                case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
                    // Same Table View
                    // 在底面的同一個表格內移動項目
                if sourceIndexPath.row < destinationIndexPath.row {
                    updatedIndexPaths = (sourceIndexPath.row...destinationIndexPath.row).map { IndexPath(row: $0, section: sourceIndexPath.section) }
                } else if sourceIndexPath.row > destinationIndexPath.row {
                    updatedIndexPaths = (destinationIndexPath.row...sourceIndexPath.row).map { IndexPath(row: $0, section: sourceIndexPath.section) }
                }

                    self.schedules[sourceIndexPath.section].schedule.remove(at: sourceIndexPath.row)
var sourceSchedule = self.schedules[sourceIndexPath.section]
                    let item = sourceSchedule.schedule.remove(at: sourceIndexPath.row)
                    print(item, string)
                    self.schedules[sourceIndexPath.section].schedule.insert(item, at: destinationIndexPath.row)
                self.tableView.reloadRows(at: updatedIndexPaths, with: .automatic)
                self.tableView.performBatchUpdates(nil)
                break
                    
                //－－－－－－從sheet移動項目到底面表格(非最尾端)－－－－－－
                case (nil, .some(let destinationIndexPath)):
                    // Move data from a table to another table
                
                    //self.schedules[destinationIndexPath.section].schedule.insert(string, at: destinationIndexPath.row)
                    // self.random10Names.insert(string, at: destinationIndexPath.row)
                    self.tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                    self.tableView.performBatchUpdates(nil)
                    print("case2",self.schedules)
                    break
                    
                //－－－－－－從sheet移動項目到底面表格(最尾端)－－－－－－
                case (nil, nil):
                    // Insert data from a table to another table

                    self.board[0].names.append(string)
                    self.tableView.insertRows(at: [IndexPath(row:  self.board[0].names.count - 1 , section: 0)], with: .automatic)
                    self.tableView.performBatchUpdates(nil)
                    print("case3",self.board)
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
