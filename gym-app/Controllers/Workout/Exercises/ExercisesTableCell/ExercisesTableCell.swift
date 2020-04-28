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
    @IBOutlet weak var exTitle: UILabel?
    @IBOutlet weak var exType: UILabel?
    @IBOutlet weak var exInfo: UILabel?
    @IBOutlet weak var exImage: UIImageView?
    @IBOutlet weak var tickBox: UIImageView?
    
    
    //Attributes
    var checked = false
    let startLetterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    
    //MARK: Set Text
    func setLabels(_ title:String, _ type:String, _ info:String){
        exTitle?.text = title
        exType?.text = type
        exInfo?.text = info
    }
    
    
    //MARK: Set Image
    func setImage(_ imageString:String, exName:String){
        if imageString == "" {
            //exImage?.image = UIImage(named: "icons8-no-image-50")!
            
            startLetterLabel.textAlignment = .center
            startLetterLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
            
            startLetterLabel.text = String(exName.prefix(1))
            
            exImage?.addSubview(startLetterLabel)
        } else {
            exImage?.image = UIImage(named: imageString)!
        }
    }
    
    
    //MARK: Tick Box Image
    func boxTicked(){
        
        if checked {
            tickBox!.image = UIImage(named: "icons8-unchecked-checkbox-50")
            checked = false
        } else {
            tickBox!.image = UIImage(named: "icons8-tick-box-50")
            checked = true
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
