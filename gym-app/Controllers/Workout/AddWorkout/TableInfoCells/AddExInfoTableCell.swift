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
    @IBOutlet weak var inputTime: UITextField!
    
    
    func setLabels(_ title: String){
        self.titleLabel?.text = title
    }
    
    
    func changeTextFieldsForType(_ exerciseType: String){
        
        if exerciseType == "Weights" {
            
            //for weights (ONLY REPS, WEIGHT)
            inputTime.isHidden = true
            
        } else if exerciseType == "Cardio" || exerciseType == "Circuits"{
            
            //for cardio/circuits (ONLY TIME)
            inputReps.isHidden = true
            inputWeight.isHidden = true
            
            
        } else {
            
            //for bodyweight (ONLY REPS)
            inputTime.isHidden = true
            inputWeight.isHidden = true
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

//extension AddExInfoTableCell: UITextFieldDelegate {
//    func text
//}
