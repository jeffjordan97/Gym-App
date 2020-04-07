//
//  HomeTableViewCell.swift
//  gym-app
//
//  Created by Jeff Jordan on 06/04/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    func setLabels(_ date: String, _ name:String, _ duration:String){
        
        self.dateLabel.text = date
        self.nameLabel.text = name
        self.durationLabel.text = duration
        
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
