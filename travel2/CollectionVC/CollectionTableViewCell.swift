//
//  SecondTableViewCell.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/23.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionPlaceNameLbl: UILabel!
    @IBOutlet weak var collectionPlaceAddressLbl: UILabel!
    @IBOutlet weak var collectionPlaceImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
