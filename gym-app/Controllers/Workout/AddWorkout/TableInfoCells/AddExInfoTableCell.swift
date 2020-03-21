//
//  AddExInfoTableCell.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 18/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit

class AddExInfoTableCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var typeLabel: UILabel?
    
    
    func setLabels(_ title: String, _ info: String){
        self.titleLabel?.text = title
        self.typeLabel?.text = info
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
