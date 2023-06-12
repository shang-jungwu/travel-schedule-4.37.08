//
//  FirstTableViewCell.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/23.
//

import UIKit

class FirstTableViewCell: UITableViewCell {

    @IBOutlet weak var scheduleLabel: UILabel!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
