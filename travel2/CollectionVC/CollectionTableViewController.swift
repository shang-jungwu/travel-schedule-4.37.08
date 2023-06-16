//
//  SecondTableViewController.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/23.
//

import UIKit
import UniformTypeIdentifiers

class CollectionTableViewController: UITableViewController {

    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    //var cities = [String]()
    var myCollections = [userSchedule]()
    var userCollectionList = [Schedule]()

    var collPlace = [CulturalCenterAndRestaurant]()
    var collHotel = [Hotel]()
    var collRestaurant = [CulturalCenterAndRestaurant]()
    var customPlace = [CulturalCenterAndRestaurant]()
    
    
    @IBAction func categorySeg(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
               tableView.dragInteractionEnabled = true
//        tableView.dragDelegate = self
//        tableView.dropDelegate = self
        // fetchCharacter()
        navigationItem.title = "我的收藏 (\(myCollections.count))"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        navigationController?.navigationBar.backgroundColor = UIColor(red: 162/255, green: 123/255, blue: 92/255, alpha: 1)
        navigationItem.rightBarButtonItem?.isHidden = true

        let customSchedule = storyboard?.instantiateViewController(withIdentifier: "CustomSheetViewController") as! CustomSheetViewController
        customSchedule.collectionVC = self
        

    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        print("myCollections:", myCollections)

        self.tableView.reloadData()
    }

//    func fetchCharacter() {
//        let urlString =  "https://raw.githubusercontent.com/shang-jungwu/json/main/pokemon.json"
//        if let url = URL(string: urlString){
//            URLSession.shared.dataTask(with: url) { [self] data, response, error in
//                if let data = data{
//                    let decoder = JSONDecoder()
//                    do {
//                        self.cities = try decoder.decode([String].self, from: data)
//                        self.cities.shuffle()
//
//                        for i in 0...(cities.count - 1) {
//                            myCollections.append(userSchedule(name: cities[i]))
//                        }
//                        userCollectionList.append(Schedule(schedule: myCollections))
//
//                        DispatchQueue.main.async { [self] in
//                            self.navigationItem.title = "我的收藏 (\(myCollections.count))"
//                            self.tableView.reloadData()
//                        }
//                    } catch  {
//                        print(error)
//                    }
//                }
//            }.resume()
//        }
//    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedController.selectedSegmentIndex {
            case 0:
                return collPlace.count
            case 1:
                return collHotel.count
            case 2:
                return collRestaurant.count
            case 3:
                return customPlace.count
            default:
                return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
        cell.collectionLbl.text = collPlace[indexPath.row].name
        cell.backgroundColor = .white
        return cell
    }
    
    // 滑動刪除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        myCollections.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "刪除"
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension CollectionTableViewController: UITableViewDragDelegate, UITableViewDropDelegate{
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let city = cities[indexPath.row]
//        let data = city.data(using: .utf8)
//        let itemProvider = NSItemProvider(item: NSData(data: data!), typeIdentifier: UTType.plainText.identifier)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        session.localContext = (city, indexPath, tableView)
//
//        return [dragItem]
//
//    }
//
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [UTType.plainText.identifier as String]){
//            coordinator.session.loadObjects(ofClass: NSString.self) { (items) in
//                guard let string = items.first as? String else{ return }
//                var updatedIndexPaths = [IndexPath]()
//                switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
//                case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
//                    // Same Table View
//                    if sourceIndexPath.row < destinationIndexPath.row {
//                        updatedIndexPaths =  (sourceIndexPath.row...destinationIndexPath.row).map { IndexPath(row: $0, section: 0) }
//                    } else if sourceIndexPath.row > destinationIndexPath.row {
//                        updatedIndexPaths =  (destinationIndexPath.row...sourceIndexPath.row).map { IndexPath(row: $0, section: 0) }
//                    }
//                    self.tableView.beginUpdates()
//                    self.cities.remove(at: sourceIndexPath.row)
//                    self.cities.insert(string, at: destinationIndexPath.row)
//                    self.tableView.reloadRows(at: updatedIndexPaths, with: .automatic)
//                    self.tableView.endUpdates()
//                    break
//
//                case (nil, .some(let destinationIndexPath)):
//                    // Move data from a table to another table
//                   // self.removeSourceTableData(localContext: coordinator.session.localDragSession?.localContext)
//                    self.tableView.beginUpdates()
//                    self.cities.insert(string, at: destinationIndexPath.row)
//                    self.tableView.insertRows(at: [destinationIndexPath], with: .automatic)
//                    self.tableView.endUpdates()
//                    break
//
//
//                case (nil, nil):
//                    // Insert data from a table to another table
//                    //self.removeSourceTableData(localContext: coordinator.session.localDragSession?.localContext)
//                    self.tableView.beginUpdates()
//                    self.cities.append(string)
//                    self.tableView.insertRows(at: [IndexPath(row: self.cities.count - 1 , section: 0)], with: .automatic)
//                    self.tableView.endUpdates()
//                    break
//
//                default: break
//
//                }
//
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
//        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//    }
//
//}
