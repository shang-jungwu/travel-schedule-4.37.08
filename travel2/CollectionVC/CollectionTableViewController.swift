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

    var myCollections = [userSchedule]()
    var userCollectionList = [Schedule]()
    
    var userSavedPlaces:[allData] = [allData(touristSpots: [TainanPlaces](), hotels: [TainanPlaces](), restaurants: [TainanPlaces](), customPlaces: [TainanPlaces]())]
    
    
   // var searchVC: SearchResultTableViewController!
    
    
    @IBAction func categorySeg(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dragInteractionEnabled = true
        //tableView.dragDelegate = self
        //tableView.dropDelegate = self
        

        print("testCollection")
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "我的收藏"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(reloadVC))
        navigationController?.navigationBar.backgroundColor = UIColor(red: 162/255, green: 123/255, blue: 92/255, alpha: 1)

        
//        let customSchedule = storyboard?.instantiateViewController(withIdentifier: "CustomSheetViewController") as! CustomSheetViewController
//        customSchedule.collectionVC = self
        
        if let data = UserDefaults.standard.data(forKey: "touristSpots") {
            userSavedPlaces[0].touristSpots = try! JSONDecoder().decode([TainanPlaces].self, from: data)
        }
        
        if let data = UserDefaults.standard.data(forKey: "hotels") {
            userSavedPlaces[0].hotels = try! JSONDecoder().decode([TainanPlaces].self, from: data)
        }
        if let data = UserDefaults.standard.data(forKey: "restaurants") {
            userSavedPlaces[0].restaurants = try! JSONDecoder().decode([TainanPlaces].self, from: data)
        }
        if let data = UserDefaults.standard.data(forKey: "customPlaces") {
            userSavedPlaces[0].customPlaces = try! JSONDecoder().decode([TainanPlaces].self, from: data)
        }
        tableView.reloadData()
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    @objc func reloadVC(){
        UserDefaults.standard.removeObject(forKey: "touristSpots")
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        refreshPage()
        self.tableView.reloadData()
        print("test3333")
    }

    func refreshPage() {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedController.selectedSegmentIndex {
            case 0:
                return userSavedPlaces[0].touristSpots.count
            case 1:
                return userSavedPlaces[0].hotels.count
            case 2:
                return userSavedPlaces[0].restaurants.count
            case 3:
                return userSavedPlaces[0].customPlaces.count
            default:
                return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
        switch segmentedController.selectedSegmentIndex {
        case 0:
            cell.collectionPlaceNameLbl.text = userSavedPlaces[0].touristSpots[indexPath.row].name
            cell.collectionPlaceImg.image = UIImage(systemName: "house.and.flag.circle")
        case 1:
            cell.collectionPlaceNameLbl.text = userSavedPlaces[0].hotels[indexPath.row].name
            cell.collectionPlaceImg.image = UIImage(systemName: "bed.double.circle")
        case 2:
            cell.collectionPlaceNameLbl.text = userSavedPlaces[0].restaurants[indexPath.row].name
            cell.collectionPlaceImg.image = UIImage(systemName: "fork.knife.circle")
        case 3:
            cell.collectionPlaceNameLbl.text = userSavedPlaces[0].customPlaces[indexPath.row].name
        default:
            cell.collectionPlaceNameLbl.text = ""
        }
        
        cell.backgroundColor = UIColor(red: 240/255, green: 235/255, blue: 227/255, alpha: 1)
        return cell
    }
    
    // 滑動刪除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            userSavedPlaces[0].touristSpots.remove(at: indexPath.row)
            let touristSpotData = try? JSONEncoder().encode(userSavedPlaces[0].touristSpots)
            if let touristSpotData {
                UserDefaults.standard.set(touristSpotData, forKey: "touristSpots")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case 1:
            userSavedPlaces[0].hotels.remove(at: indexPath.row)
            let hotelData = try? JSONEncoder().encode(userSavedPlaces[0].hotels)
            if let hotelData {
                UserDefaults.standard.set(hotelData, forKey: "hotels")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case 2:
            userSavedPlaces[0].restaurants.remove(at: indexPath.row)
            let restaurantData = try? JSONEncoder().encode(userSavedPlaces[0].restaurants)
            if let restaurantData {
                UserDefaults.standard.set(restaurantData, forKey: "restaurants")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case 3:
            userSavedPlaces[0].customPlaces.remove(at: indexPath.row)
            let customPlaceData = try? JSONEncoder().encode(userSavedPlaces[0].customPlaces)
            if let customPlaceData {
                UserDefaults.standard.set(customPlaceData, forKey: "customPlaces")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
        
        
  
        
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
//        let place = collPlace[indexPath.row]
//        let hotel = collHotel[indexPath.row]
//        let restaurant = collRestaurant[indexPath.row]
////
////        switch segmentedController.selectedSegmentIndex {
////        case 0:
////
////        case 1:
////
////        case 2:
////
////        default:
////
////        }
//
//
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
