//
//  SearchTableViewCell.swift
//  travel2
//
//  Created by 吳宗祐 on 2023/5/31.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLbl: UILabel!
    @IBOutlet weak var placeAddressLbL: UILabel!
    @IBOutlet weak var heartBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
