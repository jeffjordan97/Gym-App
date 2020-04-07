//
//  WorkoutTableInfoCell.swift
//  gym-app
//
//  Created by Jeff Jordan on 01/04/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit

class WorkoutTableInfoCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseSummaryLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
