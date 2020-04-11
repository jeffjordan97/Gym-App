//
//  ExerciseHeaderCell.swift
//  gym-app
//
//  Created by Jeff Jordan on 21/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit

protocol HeaderButtonDeletePressDelegate {
    func didPressDelete(_ section: Int)
}

class ExerciseHeaderCell: UITableViewHeaderFooterView {

    var tableSection: Int = 0
    var rowsInSection: Int = 0
    var table: UITableView = UITableView()
    var selectedExercises = [SelectedExercises]()
    var delegate: HeaderButtonDeletePressDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    func setTitle(_ title: String){
        self.titleLabel.text = title
    }
    
    func setType(_ type: String){
        self.typeLabel.text = type
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
        //self.titleLabel.text = "clicked"
        
        let rows = table.numberOfRows(inSection: tableSection)
        
        selectedExercises[tableSection].exerciseSets?.append(SetRepsWeights(set: rows, reps: nil, weight: nil, time: nil, indexpath: IndexPath()))
        
        table.insertRows(at: [IndexPath(row: rows, section: tableSection)], with: .bottom)
        
    }
    
    
    @IBAction func deleteSection(_ sender: Any) {
        delegate?.didPressDelete(tableSection)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
