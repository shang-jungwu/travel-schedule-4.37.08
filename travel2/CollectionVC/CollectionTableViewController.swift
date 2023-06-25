//
//  SecondTableViewController.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/23.
//

import UIKit
import UniformTypeIdentifiers

var collectionItem: TainanPlaces!

class CollectionTableViewController: UITableViewController {
    
    @IBOutlet weak var segmentedController: UISegmentedControl!

    var myCollections = [userSchedule]()
    var userCollectionList = [Schedule]()
    
    var userSavedPlaces:[allData] = [allData(touristSpots: [TainanPlaces](), hotels: [TainanPlaces](), restaurants: [TainanPlaces](), customPlaces: [TainanPlaces]())]
    
    var test: [TainanPlaces]!
       
    
    @IBAction func categorySeg(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "我的收藏"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(moveToTrash))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor(red: 162/255, green: 123/255, blue: 92/255, alpha: 1)

                
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

    @objc func moveToTrash(){
        switch segmentedController.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.removeObject(forKey: "touristSpots")
        case 1:
            UserDefaults.standard.removeObject(forKey: "hotels")
        case 2:
            UserDefaults.standard.removeObject(forKey: "restaurants")
        case 3:
            UserDefaults.standard.removeObject(forKey: "customPlaces")
        default:
            break
        }
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
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
                cell.collectionPlaceAddressLbl.text = userSavedPlaces[0].touristSpots[indexPath.row].address
                cell.collectionPlaceImg.image = UIImage(systemName: "house.and.flag.circle")
            case 1:
                cell.collectionPlaceNameLbl.text = userSavedPlaces[0].hotels[indexPath.row].name
                cell.collectionPlaceAddressLbl.text = userSavedPlaces[0].hotels[indexPath.row].address
                cell.collectionPlaceImg.image = UIImage(systemName: "bed.double.circle")
            case 2:
                cell.collectionPlaceNameLbl.text = userSavedPlaces[0].restaurants[indexPath.row].name
                cell.collectionPlaceAddressLbl.text = userSavedPlaces[0].restaurants[indexPath.row].address
                cell.collectionPlaceImg.image = UIImage(systemName: "fork.knife.circle")
            case 3:
                cell.collectionPlaceNameLbl.text = userSavedPlaces[0].customPlaces[indexPath.row].name
                cell.collectionPlaceAddressLbl.text = userSavedPlaces[0].customPlaces[indexPath.row].address
                cell.collectionPlaceImg.image = UIImage(systemName: "moon.haze.circle")
            default:
                break
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
            if let data = touristSpotData {
                UserDefaults.standard.set(data, forKey: "touristSpots")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case 1:
            userSavedPlaces[0].hotels.remove(at: indexPath.row)
            let hotelData = try? JSONEncoder().encode(userSavedPlaces[0].hotels)
            if let data = hotelData {
                UserDefaults.standard.set(data, forKey: "hotels")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case 2:
            userSavedPlaces[0].restaurants.remove(at: indexPath.row)
            let restaurantData = try? JSONEncoder().encode(userSavedPlaces[0].restaurants)
            if let data = restaurantData {
                UserDefaults.standard.set(data, forKey: "restaurants")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case 3:
            userSavedPlaces[0].customPlaces.remove(at: indexPath.row)
            let customPlaceData = try? JSONEncoder().encode(userSavedPlaces[0].customPlaces)
            if let data = customPlaceData {
                UserDefaults.standard.set(data, forKey: "customPlaces")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "刪除"
    }

}

extension CollectionTableViewController: UITableViewDragDelegate, UITableViewDropDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        //var collectionItem: TainanPlaces!
        var data: Data?
        switch segmentedController.selectedSegmentIndex {
        case 0:
            collectionItem = userSavedPlaces[0].touristSpots[indexPath.row]
            data = collectionItem.name.data(using: .utf8)
        case 1:
            collectionItem = userSavedPlaces[0].hotels[indexPath.row]
            data = collectionItem.name.data(using: .utf8)
        case 2:
            collectionItem = userSavedPlaces[0].restaurants[indexPath.row]
            data = collectionItem.name.data(using: .utf8)
        case 3:
            collectionItem = userSavedPlaces[0].customPlaces[indexPath.row]
            data = collectionItem.name.data(using: .utf8)
        default:
            break
        }
        let itemProvider = NSItemProvider(item: NSData(data: data!), typeIdentifier: UTType.plainText.identifier)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        session.localContext = (collectionItem, indexPath, tableView)
        print(collectionItem as Any)
        return [dragItem]

    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [UTType.plainText.identifier as String]){
            coordinator.session.loadObjects(ofClass: NSString.self) { [self] items in
                guard items.first is String else{ return } // as?
                switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
                case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
                    if sourceIndexPath.section == destinationIndexPath.section {
                        
                        var tmp: TainanPlaces!
                        switch segmentedController.selectedSegmentIndex {
                        case 0:
                            tmp = userSavedPlaces[0].touristSpots.remove(at: sourceIndexPath.row)
                            self.userSavedPlaces[0].touristSpots.insert(tmp, at: destinationIndexPath.row)
                            
                        case 1:
                            tmp = userSavedPlaces[0].hotels.remove(at: sourceIndexPath.row)
                            self.userSavedPlaces[0].hotels.insert(tmp, at: destinationIndexPath.row)
                        case 2:
                            tmp = userSavedPlaces[0].restaurants.remove(at: sourceIndexPath.row)
                            self.userSavedPlaces[0].restaurants.insert(tmp, at: destinationIndexPath.row)
                        case 3:
                            tmp = userSavedPlaces[0].customPlaces.remove(at: sourceIndexPath.row)
                            self.userSavedPlaces[0].customPlaces.insert(tmp, at: destinationIndexPath.row)
                        default:
                            
                            break
                        }

                        print(tmp as Any)
                        self.tableView.reloadData()
                    }
                    self.tableView.performBatchUpdates(nil)
                    break

                default: break

                }

            }
        }
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionShowDetail" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.collectionVC = self
            detailVC.currentIndex = self.tableView.indexPathForSelectedRow!.row
            detailVC.currentData = self.userSavedPlaces
            detailVC.segueID = segue.identifier!
        }
    }


}


