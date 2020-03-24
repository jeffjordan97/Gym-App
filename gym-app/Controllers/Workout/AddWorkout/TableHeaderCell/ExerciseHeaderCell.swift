//
//  ExerciseHeaderCell.swift
//  gym-app
//
//  Created by Jeff Jordan on 21/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit

class ExerciseHeaderCell: UITableViewHeaderFooterView {

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
        
        
       //add exercise set
        
        
        
        let rows = table.numberOfRows(inSection: tableSection)
        
        selectedExercises[tableSection].exerciseSets?.append(SetRepsWeights(set: rows, reps: nil, weight: nil, indexpath: IndexPath()))
        
        #warning("Fix inserting Row to Section, reloadData clears each textfield")
        table.insertRows(at: [IndexPath(row: rows, section: tableSection)], with: .bottom)
        
        //table.reloadData()
        
        
        
        
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
