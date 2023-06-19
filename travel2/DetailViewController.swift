//
//  DetailViewController.swift
//  travel2
//
//  Created by WuShangJung on 2023/6/19.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var placeNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var openTimeLbl: UILabel!

    weak var searchResultVC: SearchResultTableViewController!
    weak var collectionVC: CollectionTableViewController!
    weak var scheduleVC: ScheduleTableViewController!

    var currentIndex = 0
    var currentData =  [allData]()
    
    @IBAction func navigateButton(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "詳細資訊"
        

        currentData = searchResultVC.userSearchResults

        switch searchResultVC.segmentedController.selectedSegmentIndex {
        case 0:
            placeNameLbl.text = currentData[0].touristSpots[currentIndex].name
            addressLbl.text = currentData[0].touristSpots[currentIndex].address
            phoneLbl.text = currentData[0].touristSpots[currentIndex].tel!
            openTimeLbl.text = currentData[0].touristSpots[currentIndex].openTime!
        case 1:
            placeNameLbl.text = currentData[0].hotels[currentIndex].name
            addressLbl.text = currentData[0].hotels[currentIndex].address
            phoneLbl.text = currentData[0].hotels[currentIndex].tel!
            if let openTime = currentData[0].hotels[currentIndex].openTime {
                openTimeLbl.text = openTime
            } else {
                openTimeLbl.text = "無相關資訊"
            }

        case 2:
            placeNameLbl.text = currentData[0].restaurants[currentIndex].name
            addressLbl.text = currentData[0].restaurants[currentIndex].address
            phoneLbl.text = currentData[0].restaurants[currentIndex].tel!
            openTimeLbl.text = currentData[0].restaurants[currentIndex].openTime!
        default:
            break
        }
    }
}
