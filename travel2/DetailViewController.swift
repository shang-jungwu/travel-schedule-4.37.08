//
//  DetailViewController.swift
//  travel2
//
//  Created by WuShangJung on 2023/6/19.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var placeNameLbl: UILabel!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var openTimeTV: UITextView!
    
    
    @IBOutlet weak var buttonToMap: UIButton!
    
    
    @IBOutlet weak var buttonToStreetView: UIButton!
    
    
    
    var segueID =  ""
    
    weak var searchResultVC: SearchResultTableViewController!
    weak var collectionVC: CollectionTableViewController!
    weak var scheduleVC: ScheduleTableViewController!

    var currentIndex = 0
    var currentIndexSection = 0
    var currentData =  [allData]()
    var scheduleData =  [Schedule]()
    
    @IBAction func toMap(_ sender: UIButton) {
        
        let detailMapVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailMapViewController") as! DetailMapViewController
        
        detailMapVC.detailController = self

        self.show(detailMapVC, sender: nil)
 
    }
    
    
    @IBAction func toStreetView(_ sender: UIButton) {
        
        let streetVC = self.storyboard?.instantiateViewController(withIdentifier: "StreetViewController") as! StreetViewController
        
        streetVC.detailController = self
        
//        streetVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(streetVC, animated: true)

        self.show(streetVC, sender: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "詳細資訊"
        navigationController?.navigationBar.tintColor = UIColor.white

        switch segueID {
        case "searchShowDetail":
            switch searchResultVC.segmentedController.selectedSegmentIndex {
            case 0:
                placeNameLbl.text = currentData[0].touristSpots[currentIndex].name
                addressTxt.text = currentData[0].touristSpots[currentIndex].address
                phoneTxt.text = currentData[0].touristSpots[currentIndex].tel!
                openTimeTV.text = currentData[0].touristSpots[currentIndex].openTime!
            case 1:
                placeNameLbl.text = currentData[0].hotels[currentIndex].name
                addressTxt.text = currentData[0].hotels[currentIndex].address
                phoneTxt.text = currentData[0].hotels[currentIndex].tel!
                if let openTime = currentData[0].hotels[currentIndex].openTime {
                    openTimeTV.text = openTime
                } else {
                    openTimeTV.text = "無相關資訊"
                }

            case 2:
                placeNameLbl.text = currentData[0].restaurants[currentIndex].name
                addressTxt.text = currentData[0].restaurants[currentIndex].address
                phoneTxt.text = currentData[0].restaurants[currentIndex].tel!
                openTimeTV.text = currentData[0].restaurants[currentIndex].openTime!
            default:
                break
            }
        case "collectionShowDetail":
            switch collectionVC.segmentedController.selectedSegmentIndex {
            case 0:
                placeNameLbl.text = currentData[0].touristSpots[currentIndex].name
                addressTxt.text = currentData[0].touristSpots[currentIndex].address
                phoneTxt.text = currentData[0].touristSpots[currentIndex].tel!
                openTimeTV.text = currentData[0].touristSpots[currentIndex].openTime!
            case 1:
                placeNameLbl.text = currentData[0].hotels[currentIndex].name
                addressTxt.text = currentData[0].hotels[currentIndex].address
                phoneTxt.text = currentData[0].hotels[currentIndex].tel!
                if let openTime = currentData[0].hotels[currentIndex].openTime {
                    openTimeTV.text = openTime
                } else {
                    openTimeTV.text = "無相關資訊"
                }

            case 2:
                placeNameLbl.text = currentData[0].restaurants[currentIndex].name
                addressTxt.text = currentData[0].restaurants[currentIndex].address
                phoneTxt.text = currentData[0].restaurants[currentIndex].tel!
                openTimeTV.text = currentData[0].restaurants[currentIndex].openTime!
            case 3:
                //addressTxt.isUserInteractionEnabled = true
                placeNameLbl.text = currentData[0].customPlaces[currentIndex].name
                addressTxt.text = currentData[0].customPlaces[currentIndex].address
            default:
                break
            }
        case "scheduleShowDetail":
            placeNameLbl.text = scheduleData[currentIndexSection].schedule[currentIndex].placeName.name
            addressTxt.text = scheduleData[currentIndexSection].schedule[currentIndex].placeName.address
            if let tel = scheduleData[currentIndexSection].schedule[currentIndex].placeName.tel {
                phoneTxt.text = tel
            } else {
                phoneTxt.text = "未提供電話"
            }
            
            openTimeTV.text = "使用者自訂時間"
        default:
            break
        }
        
        

        
    }
    
    
    
    
    
    




}
