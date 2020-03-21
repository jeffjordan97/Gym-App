//
//  ExerciseHeaderCell.swift
//  gym-app
//
//  Created by Jeff Jordan on 21/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit

class ExerciseHeaderCell: UITableViewCell {

    var tableSection: Int = 0
    var rowsInSection: Int = 0
    var table: UITableView = UITableView()
    var selectedExercises = [SelectedExercises]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var setButton: UIButton!
    
    
    func setTitle(_ title: String){
        self.titleLabel.text = title
    }
    
    
    func getTable(_ table: UITableView, section: Int, rowsInSection: Int){
        self.table = table
        self.tableSection = section
        self.rowsInSection = rowsInSection
    }
    
    
    func getSelectedExercises(_ selectedExercises: [SelectedExercises]){
        self.selectedExercises = selectedExercises
    }
    
    
    
    @IBAction func addSetButton(_ sender: Any) {
        self.titleLabel.text = "clicked"
        
        
        selectedExercises[tableSection].exerciseSets![rowsInSection+1] = 55
        
        table.reloadData()
        
        
        //add exercise set
        
        //let indexPath = IndexPath(row: tableRow, section: tableSection)
        //table.insertRows(at: [indexPath], with: .fade)
        //table.reloadData()
        
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
