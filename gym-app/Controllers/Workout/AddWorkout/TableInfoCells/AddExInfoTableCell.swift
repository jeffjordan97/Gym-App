//
//  AddExInfoTableCell.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 18/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit

class AddExInfoTableCell: UITableViewCell {
    //add delegate UITextFieldDelegate
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var inputReps: UITextField!
    @IBOutlet weak var inputWeight: UITextField!
    
    var storedIndexPath = IndexPath()
    
    func setLabels(_ title: String){
        self.titleLabel?.text = title
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

//extension AddExInfoTableCell: UITextFieldDelegate {
//    func text
//}
