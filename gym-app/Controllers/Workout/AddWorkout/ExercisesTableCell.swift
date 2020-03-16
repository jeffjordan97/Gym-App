//
//  ExercisesTableCell.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 16/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit

class ExercisesTableCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var exTitle: UILabel?
    @IBOutlet weak var exType: UILabel?
    @IBOutlet weak var exInfo: UILabel?
    @IBOutlet weak var exImage: UIImageView?
    @IBOutlet weak var tickBox: UIImageView?
    
    
    //MARK: Set Text
    func setLabels(_ title:String, _ type:String, _ info:String){
        exTitle?.text = title
        exType?.text = type
        exInfo?.text = info
    }
    
    //MARK: Set Image
    func setImage(_ imageString:String){
        if imageString == "" {
            exImage?.image = UIImage(named: "icons8-no-image-50")!
        } else {
            exImage?.image = UIImage(named: imageString)!
        }
    }
    
    //MARK: Selected Exercises List
    func selectedExercises(){
        
    }
    
    
    //MARK: Cell Tapped
    @IBAction func cellTapped(_ sender: Any) {
        if outerView.backgroundColor == .none {
            
            outerView.backgroundColor = #colorLiteral(red: 0.751993654, green: 0.9365622094, blue: 1, alpha: 1)
            tickBox?.image = UIImage(named: "icons8-tick-box-50")
            
        } else if outerView.backgroundColor == #colorLiteral(red: 0.751993654, green: 0.9365622094, blue: 1, alpha: 1) {
            
            outerView.backgroundColor = .none
            tickBox?.image = UIImage(named: "icons8-unchecked-checkbox-50")
            
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
