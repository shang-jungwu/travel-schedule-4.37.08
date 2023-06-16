//
//  SearchTableViewController.swift
//  travel2
//
//  Created by WuShangJung on 2023/6/13.
//

import UIKit

class SearchResultTableViewController: UITableViewController {
    
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    var searchResultCulturalCenter = [CulturalCenterAndRestaurant]()
    var searchResultHotel = [Hotel]()
    var searchRestaurant = [CulturalCenterAndRestaurant]()
    var filterBtnTapped = false
    var savedPlace = [CulturalCenterAndRestaurant]()
    var savedRestaurant = [CulturalCenterAndRestaurant]()
    var savedHotel = [Hotel]()
    
    @IBOutlet weak var heart: UIButton!
    
    
    
    //MARK: - Target Action
    
    @IBAction func categorySeg(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if let indexPath {
            let place = searchResultCulturalCenter[indexPath.row]
            let hotel = searchResultHotel[indexPath.row]
            let restaurant = searchRestaurant[indexPath.row]
            
            if sender.isSelected {
                let index = savedPlace.firstIndex {
                    $0.name == place.name
                }
                if let index {
                    savedPlace.remove(at: index)
                }
            } else {
                savedPlace.append(place)
                
            }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        
        }
        print(savedPlace)
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
            searchResultCulturalCenter.sort { $0.address < $1.address }
            searchResultHotel.sort { $0.address < $1.address }
            searchRestaurant.sort { $0.address < $1.address }
            filterBtnTapped = true
        } else {
            searchResultCulturalCenter.sort { $0.address > $1.address }
            searchResultHotel.sort { $0.address > $1.address }
            searchRestaurant.sort { $0.address > $1.address }
            filterBtnTapped = false
        }
        self.tableView.reloadData()
    }
    
    
    @objc func itemShuffle() {
        searchResultCulturalCenter.shuffle()
        searchResultHotel.shuffle()
        searchRestaurant.shuffle()
        self.tableView.reloadData()
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
                return searchResultCulturalCenter.count
            case 1:
                return searchResultHotel.count
            case 2:
                return searchRestaurant.count
            default:
                return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
        
        
        switch segmentedController.selectedSegmentIndex {
            case 0:
            cell.placeNameLbl.text = searchResultCulturalCenter[indexPath.row].name
            cell.placeAddressLbL.text = searchResultCulturalCenter[indexPath.row].address
            cell.placeImageView.image = UIImage(systemName: "house.and.flag.circle")
            let place = searchResultCulturalCenter[indexPath.row]
            let contain = savedPlace.contains {
                $0.name == place.name
            }
            cell.heart.isSelected = contain
            
            case 1:
            cell.placeNameLbl.text = searchResultHotel[indexPath.row].name
            cell.placeAddressLbL.text = searchResultHotel[indexPath.row].address
            cell.placeImageView.image = UIImage(systemName: "bed.double.circle")
            let hotel = searchResultHotel[indexPath.row]
            let contain = searchResultHotel.contains {
                $0.name == hotel.name
            }
            cell.heart.isSelected = contain
            
            case 2:
            cell.placeNameLbl.text = searchRestaurant[indexPath.row].name
            cell.placeAddressLbL.text = searchRestaurant[indexPath.row].address
            cell.placeImageView.image = UIImage(systemName: "fork.knife.circle")
            let restaurant = searchRestaurant[indexPath.row]
            let contain = searchRestaurant.contains {
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
