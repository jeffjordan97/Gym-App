//
//  BelowExerciseHeaderCell.swift
//  gym-app
//
//  Created by Jeff Jordan on 21/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit

class BelowExerciseHeaderCell: UITableViewCell {

    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var repsLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    func changeInputLabels(_ exerciseType: String){
        
        if exerciseType == "Weights" {
            
            //for weights (ONLY REPS, WEIGHT)
            timeLabel.isHidden = true
            
        } else if exerciseType == "Cardio" || exerciseType == "Circuits" {
            
            //for cardio/circuits (ONLY TIME)
            repsLabel.isHidden = true
            weightLabel.isHidden = true
            
        } else {
            
            //for bodyweight (ONLY REPS)
            timeLabel.isHidden = true
            weightLabel.isHidden = true
            
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
