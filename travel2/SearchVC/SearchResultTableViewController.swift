//
//  SearchTableViewController.swift
//  travel2
//
//  Created by WuShangJung on 2023/6/13.
//

import UIKit

class SearchResultTableViewController: UITableViewController {
    
    @IBOutlet weak var segmentedController: UISegmentedControl!

    var filterBtnTapped = false
   
    var userSearchResults:[allData] = [allData(touristSpots: [TainanPlaces](), hotels: [TainanPlaces](), restaurants: [TainanPlaces](), customPlaces: [TainanPlaces]())]
    
    var userSavedPlaces:[allData] = [allData(touristSpots: [TainanPlaces](), hotels: [TainanPlaces](), restaurants: [TainanPlaces](), customPlaces: [TainanPlaces]())]
    
    @IBOutlet weak var heart: UIButton!
       
    
    //MARK: - Target Action
    
    @IBAction func categorySeg(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        switch segmentedController.selectedSegmentIndex {
        case 0:
            if let indexPath {
                let place = userSearchResults[0].touristSpots[indexPath.row]
                if sender.isSelected {
                    let index = userSavedPlaces[0].touristSpots.firstIndex {
                        $0.name == place.name
                    }
                    if let index {
                        userSavedPlaces[0].touristSpots.remove(at: index)
                    }
                } else {
                    userSavedPlaces[0].touristSpots.append(place)
                }
                let data = try? JSONEncoder().encode(userSavedPlaces[0].touristSpots)
                if let data {
                    UserDefaults.standard.setValue(data, forKey: "touristSpots")
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            

        case 1:
            if let indexPath {
                let hotel = userSearchResults[0].hotels[indexPath.row]
                if sender.isSelected {
                    let index = userSavedPlaces[0].hotels.firstIndex {
                        $0.name == hotel.name
                    }
                    if let index {
                        userSavedPlaces[0].hotels.remove(at: index)
                    }
                } else {
                    userSavedPlaces[0].hotels.append(hotel)
                }
                let data = try? JSONEncoder().encode(userSavedPlaces[0].hotels)
                if let data {
                    UserDefaults.standard.setValue(data, forKey: "hotels")
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            

        case 2:
            if let indexPath {
                let restaurant = userSearchResults[0].restaurants[indexPath.row]
                if sender.isSelected {
                    let index = userSavedPlaces[0].restaurants.firstIndex {
                        $0.name == restaurant.name
                    }
                    if let index {
                        userSavedPlaces[0].restaurants.remove(at: index)
                    }
                } else {
                    userSavedPlaces[0].restaurants.append(restaurant)
                }
                let data = try? JSONEncoder().encode(userSavedPlaces[0].restaurants)
                if let data {
                    UserDefaults.standard.setValue(data, forKey: "restaurants")
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
        default:
            break
        }
        
        //print(userSavedPlaces[0].touristSpots.map({ $0.name }),userSavedPlaces[0].hotels.map({ $0.name }),userSavedPlaces[0].restaurants.map({ $0.name }) )
    }
    

    
    
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "搜尋結果"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease"), style: .plain, target: self, action: #selector(filterIncrease)),UIBarButtonItem(image: UIImage(systemName: "shuffle"), style: .plain, target: self, action: #selector(itemShuffle))]
        
        self.tableView.reloadData()
    }
    

    @objc func filterIncrease() {
        if filterBtnTapped == false {
            switch segmentedController.selectedSegmentIndex {
            case 0:
                userSearchResults[0].touristSpots.sort { $0.address < $1.address }
            case 1:
                userSearchResults[0].hotels.sort { $0.address < $1.address }
            case 2:
                userSearchResults[0].restaurants.sort { $0.address < $1.address }
            default:
                break
            }
            filterBtnTapped = true
        } else {
            switch segmentedController.selectedSegmentIndex {
            case 0:
                userSearchResults[0].touristSpots.sort { $0.address > $1.address }
            case 1:
                userSearchResults[0].hotels.sort { $0.address > $1.address }
            case 2:
                userSearchResults[0].restaurants.sort { $0.address > $1.address }
            default:
                break
            }
            filterBtnTapped = false
        }
        self.tableView.reloadData()
    }
    
    
    @objc func itemShuffle() {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            userSearchResults[0].touristSpots.shuffle()
        case 1:
            userSearchResults[0].hotels.shuffle()
        case 2:
            userSearchResults[0].restaurants.shuffle()
        default:
            break
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    
    //MARK: - Tab Bar
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        switch segmentedController.selectedSegmentIndex {
            case 0:
                return userSearchResults[0].touristSpots.count
            case 1:
                return userSearchResults[0].hotels.count
            case 2:
                return userSearchResults[0].restaurants.count
            default:
                return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
        
        switch segmentedController.selectedSegmentIndex {
            case 0:
            cell.placeNameLbl.text = userSearchResults[0].touristSpots[indexPath.row].name
            cell.placeAddressLbL.text = userSearchResults[0].touristSpots[indexPath.row].address
            cell.placeImageView.image = UIImage(systemName: "house.and.flag.circle")
            let place = userSearchResults[0].touristSpots[indexPath.row]
            let contain = userSavedPlaces[0].touristSpots.contains {
                $0.name == place.name
            }
            cell.heart.isSelected = contain
            
            case 1:
            cell.placeNameLbl.text = userSearchResults[0].hotels[indexPath.row].name
            cell.placeAddressLbL.text = userSearchResults[0].hotels[indexPath.row].address
            cell.placeImageView.image = UIImage(systemName: "bed.double.circle")
            let hotel = userSearchResults[0].hotels[indexPath.row]
            let contain = userSavedPlaces[0].hotels.contains {
                $0.name == hotel.name
            }
            cell.heart.isSelected = contain
            
            case 2:
            cell.placeNameLbl.text = userSearchResults[0].restaurants[indexPath.row].name
            cell.placeAddressLbL.text = userSearchResults[0].restaurants[indexPath.row].address
            cell.placeImageView.image = UIImage(systemName: "fork.knife.circle")
            let restaurant = userSearchResults[0].restaurants[indexPath.row]
            let contain = userSavedPlaces[0].restaurants.contains {
                $0.name == restaurant.name
            }
            cell.heart.isSelected = contain
            
            default:
            cell.placeNameLbl.text = ""
        }
        
        return cell
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
