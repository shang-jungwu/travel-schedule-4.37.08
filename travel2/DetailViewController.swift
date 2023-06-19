//
//  DetailViewController.swift
//  travel2
//
//  Created by WuShangJung on 2023/6/19.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var PlaceNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var openTimeLbl: UILabel!
    
    @IBAction func navigateButton(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "詳細資訊"
        
    }
    

   

}
