//
//  AddWorkoutController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 05/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import DropDown

class AddWorkoutController: UIViewController {
    
    
    
    //MARK: Outlets
    @IBOutlet weak var woTypeView: UIView!
    
    @IBOutlet weak var woTypeLabel: UILabel!
    
    @IBOutlet weak var hoursField: UITextField!
    
    @IBOutlet weak var editTable: UITableView!
    
    
    //MARK: Attributes
    
    //stores all exercises from JSON file
    var exList = [exListJson]()
    
    var durationPicker = UIPickerView()
    
    //constants for duration picker view
    let hoursPickList = ["0","1","2", "3", "4", "5"]
    let minsPickList = ["0","1","2", "3", "4", "5", "6", "7", "8", "9", "10", "11","12","13","14","15"]
    let titlePickList = ["hours", "mins"]
    
    var selectedExercises = [SelectedExercises]()
    
    //MARK: Type Input
    //To show dropdown for user to select workout type
    @IBAction func woTypeButton(_ sender: Any) {
        
        woTypeLabel.isHidden = true
        
        let typeDropDown = DropDown()
        
        // The list of items to display. Can be changed dynamically
        typeDropDown.dataSource = ["Weights", "Cardio", "Circuits"]
        
        // The view to which the drop down will appear on
        typeDropDown.anchorView = woTypeView // UIView or UIBarButtonItem
        
        // Action triggered on selection
        typeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.woTypeLabel.isHidden = false
            self.woTypeLabel.text = item
            self.woTypeLabel.textColor = .black
            self.woTypeLabel.textAlignment = .center
            self.woTypeLabel.font = self.woTypeLabel.font.withSize(22.0)
        }
        
        typeDropDown.show()
    }
    
    //MARK: Cancel Button
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: Pass Info: AddWorkoutController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toExercises"){
            let exercisesVC = segue.destination as! ExercisesController
            print("toExercises Segue...")
            exercisesVC.isModalInPresentation = true
        }
    }
    
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("AddWorkout Loaded")
        
        
        
        durationPicker.delegate = self
        durationPicker.dataSource = self
        
        hoursField.inputView = durationPicker
        //hoursField.textAlignment = .center
        //hoursField.placeholder = "Select"
        
        //Adds a toolbar to the pickerView, with a 'done' button that closes the pickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 50/255, green: 50/255, blue: 200/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneButtonTapped))
        toolBar.setItems([doneButton], animated: false)
        self.hoursField.inputAccessoryView = toolBar
        
        
        
        
        
        selectedExercises.append(SelectedExercises.init(exerciseName: "name1", exerciseType: "type1", exerciseInfo: "info1", exerciseSets: [1:10,2:15]))
        selectedExercises.append(SelectedExercises.init(exerciseName: "name2", exerciseType: "type2", exerciseInfo: "info2", exerciseSets: [1:5,2:7, 3: 9]))
        
        
        editTable.delegate = self
        editTable.rowHeight = 60
        
        editTable.register(UITableViewCell.self, forCellReuseIdentifier: "BelowExerciseHeaderCell")
        editTable.register(UITableViewCell.self, forCellReuseIdentifier: "AddExInfoTableCell")
        //editTable.register(UINib(nibName: "AddExInfoTableCell", bundle: nil), forCellReuseIdentifier: "AddExInfoTableCell")
        
        
    }
}



//MARK: Duration Picker
extension AddWorkoutController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    //sets number of rows for each column in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hoursPickList.count
        }else {
            if component == 1 {
                return 1
            }else {
                if component == 2 {
                    return minsPickList.count
                }else {
                    if component == 3 {
                        return 1
                    }
                }
            }
        }
        return 1
    }
    
    //changes label to number of hours and minutes selected from picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var selectedHours = hoursPickList[pickerView.selectedRow(inComponent: 0)]
        var selectedMins = minsPickList[pickerView.selectedRow(inComponent: 2)]
        
        hoursField.textAlignment = .center
        hoursField.font!.withSize(22.0)
        hoursField.text = "\(selectedHours) hours   \(selectedMins) mins"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            let str = hoursPickList[row]
            pickerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        }else {
            if component == 1 {
                let str = titlePickList[0]
                pickerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
            }else {
                if component == 2 {
                    let str = minsPickList[row]
                    pickerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
                }else {
                    let str = titlePickList[1]
                    pickerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
                }
            }
        }
    }
    
    //closes Duration picker view
    @objc private func doneButtonTapped(){
        self.hoursField.resignFirstResponder()
    }
    
}


//MARK: Exercise Table
extension AddWorkoutController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedExercises.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedExercises[section].exerciseSets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let exercise = exList[indexPath.row]
        
        let thisExercise = selectedExercises[indexPath.section]
        print(thisExercise)
        
        if indexPath.row == 0  {
            let cell = Bundle.main.loadNibNamed("BelowExerciseHeaderCell", owner: self, options: nil)?.first as! BelowExerciseHeaderCell
            
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("AddExInfoTableCell", owner: self, options: nil)?.first as! AddExInfoTableCell
            
            
            cell.setLabels("Sets: \(indexPath.row) Reps: \(String(describing: thisExercise.exerciseSets![indexPath.row]!))", "Section: \(indexPath.section) Row: \(indexPath.row)")
            
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let exHeaderCell = Bundle.main.loadNibNamed("ExerciseHeaderCell", owner: self, options: nil)?.first as! ExerciseHeaderCell
        
        exHeaderCell.setButton.setTitleColor(.gray, for: .highlighted)
        exHeaderCell.setTitle(selectedExercises[section].exerciseName!)
        
        exHeaderCell.getTable(editTable, section: section, rowsInSection: editTable.numberOfRows(inSection: section))
        
        exHeaderCell.getSelectedExercises(selectedExercises)
        
        return exHeaderCell
    }
    
    
}

class SelectedExercises {
    var exerciseName: String?
    var exerciseType: String?
    var exerciseInfo: String?
    var exerciseSets: [Int:Int]?
    
    init(exerciseName:String, exerciseType:String, exerciseInfo: String, exerciseSets:[Int:Int]) {
        self.exerciseName = exerciseName
        self.exerciseType = exerciseType
        self.exerciseInfo = exerciseInfo
        self.exerciseSets = exerciseSets
    }
}


class SetRepsWeights {
    var set: Int?
    var reps: Int?
    var weight: Float?
    
    init(set:Int, reps:Int, weight:Float){
        self.set = set
        self.reps = reps
        self.weight = weight
    }
}


