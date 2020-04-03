//
//  WorkoutTableHeaderCell.swift
//  gym-app
//
//  Created by Jeff Jordan on 01/04/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit

class WorkoutTableHeaderCell: UITableViewCell {

    //MARK: Outlets
    
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    func setImage(type:String){
        if type == "Cardio" {
            typeImage.image = UIImage(named: "icons8-running-100")
        } else if type == "Circuits" {
            typeImage.image = UIImage(named: "icons8-jump-100")
        } else {
            typeImage.image = UIImage(named: "icons8-barbell-100")
        }
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
