//
//  SectionHeaderTableViewCell.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/31.
//

import UIKit

class SectionHeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func pullDownMenu(){
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 50, width: 100, height: 50)
        button.setTitle("Add Schedule", for: .normal)
        button.backgroundColor = .cyan
        self.addSubview(button)
        button.showsMenuAsPrimaryAction = true
        button.menu = UIMenu(children: [
            UIAction(title: "Collection", handler: { action in
                print("Collection Print")
            }),
            UIAction(title: "Cutsom Print", handler: { action in
                print("Cutsom Print")
            }),
            UIAction(title: "Cutsom Print", handler: { action in
                print("Cutsom Print")
            })
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
