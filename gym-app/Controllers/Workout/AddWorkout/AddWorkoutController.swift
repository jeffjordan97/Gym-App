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


protocol isAbleToReceiveData {
    func pass(thisWorkout: WorkoutSession)
}

class AddWorkoutController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var woTypeView: UIView!
    
    @IBOutlet weak var woTypeLabel: UILabel!
    
    @IBOutlet weak var durationField: UITextField!
    
    @IBOutlet weak var durationWarningLabel: UILabel!
    
    @IBOutlet weak var typeWarningLabel:UILabel!
    
    @IBOutlet weak var exercisesWarningLabel: UILabel!
    
    @IBOutlet weak var editTable: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //MARK: Attributes
    
    var durationPicker = UIPickerView()
    var durationAsSecondsInput: Int?
    var typeInput: String?
    var minsPickList = [String]()
    var secondsPickList = [String]()
    
    //constants for duration picker view
    let hoursPickList = ["0","1","2", "3", "4", "5"]
    let titlePickList = ["hours", "mins","seconds"]
    var pickerTimePicked = (0,0,0)
    
    //Stores all selectedExercises from ExercisesController, used in TableView
    var selectedExercises = [SelectedExercises]()
    var activeTextField = UITextField()
    var selectedExercisesSections = [Int]()
    
    var finishClicked = false
    
    var delegate: isAbleToReceiveData?
    var workoutToPass: WorkoutSession?
    var canPassData = false
    
    
    //generates numbers 0 to 59 to add to pickerview for duration
    func minsSecondsPickListGenerate(){
        for i in 0...59 {
            self.minsPickList.append("\(i)")
            self.secondsPickList.append("\(i)")
        }
    }
    
    
    //MARK: Type Input
    //To show dropdown for user to select workout type
    @IBAction func woTypeButton(_ sender: Any) {
        
        
        let typeDropDown = DropDown()
        
        // The list of items to display. Can be changed dynamically
        typeDropDown.dataSource = ["Weights", "Cardio", "Circuits"]
        
        // The view to which the drop down will appear on
        typeDropDown.anchorView = woTypeView // UIView or UIBarButtonItem
        
        // Action triggered on selection
        typeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          //print("Selected item: \(item) at index: \(index)")
            
            //checks if item has been selected from dropDown, as user may click off before selecting
            if item != "" {
                self.woTypeLabel.text = item
                self.typeInput = item
                self.woTypeLabel.textColor = .black
                self.woTypeLabel.textAlignment = .center
                self.woTypeLabel.font = self.woTypeLabel.font.withSize(22.0)
                self.typeWarningLabel.text = ""
            }
            
        }
        
        typeDropDown.show()
    }
    
    
    //MARK: Pass Info: AddWorkoutController
    //If Add button clicked, which opens segue to Exercises
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toExercises"){
            exercisesWarningLabel.text = ""
            let exercisesVC = segue.destination as! ExercisesController
            print("toExercises Segue...")
            
            //prevents 'slide to close' modal
            exercisesVC.isModalInPresentation = true
        }
    }
    
    
    
    
    //MARK: Finish Button
    @IBAction func finishButton(_ sender: Any) {
    
        validateBeforeFinish()
        //to highlight unedited cells when loaded into view via the cellForRowAt function
        finishClicked = true
        
    }
    
    
    
    func validateBeforeFinish(){
        
        var missingFields = false
        var missingTextFields = false
        guard let visibleIndexes = self.editTable.indexPathsForVisibleRows else { return  }
        
        //validation for duration input field
        if durationField.text == nil || durationField.text == "" {
            durationWarningLabel.text = "* Missing Duration *"
            missingFields = true
        }
        
        //validation for type input field
        if woTypeLabel.text == nil || woTypeLabel.text == "" || woTypeLabel.text == "Select" {
            typeWarningLabel.text = "* Missing Type *"
            missingFields = true
        }
        
        //returns true if missing text fields in selected exercise list
        missingTextFields = validateSelectedExercises(missingTextFields: missingTextFields, selectedExercises)
        
        //loops through all visible indexPaths and adds background colour if textfield doesnt contain text
        for index in visibleIndexes {
            if index.row > 0 {
                let cell = self.tableView(self.editTable, cellForRowAt: index) as? AddExInfoTableCell
                
                let thisExerciseInfo = selectedExercises[index.section].exerciseInfo
                
                if thisExerciseInfo == "Weights" {
                    
                    //missing text in Reps textfield at index (IndexPath)
                    if cell?.inputReps.text == nil || cell?.inputReps.text == "" {
                        cell?.inputReps.backgroundColor = #colorLiteral(red: 1, green: 0.2366749612, blue: 0.1882926814, alpha: 0.6023877641)
                        self.editTable.reloadData()
                        missingTextFields = true
                    }
                    //missing text in Weights textfield at index (IndexPath)
                    if cell?.inputWeight.text == nil || cell?.inputWeight.text == "" {
                        cell?.inputWeight.backgroundColor = #colorLiteral(red: 1, green: 0.2366749612, blue: 0.1882926814, alpha: 0.6023877641)
                        self.editTable.reloadData()
                        missingTextFields = true
                    }
                    
                } else if thisExerciseInfo == "Cardio" || thisExerciseInfo == "Circuits" {
                    
                    //missing text in time textfield at index (IndexPath)
                    if cell?.inputTime.text == nil || cell?.inputTime.text == "" {
                        cell?.inputTime.backgroundColor = #colorLiteral(red: 1, green: 0.2366749612, blue: 0.1882926814, alpha: 0.6023877641)
                        self.editTable.reloadData()
                        missingTextFields = true
                    }
                    
                } else {    //for Bodyweight
                    
                    //missing text in Reps textfield at index (IndexPath)
                    if cell?.inputReps.text == nil || cell?.inputReps.text == "" {
                        cell?.inputReps.backgroundColor = #colorLiteral(red: 1, green: 0.2366749612, blue: 0.1882926814, alpha: 0.6023877641)
                        self.editTable.reloadData()
                        missingTextFields = true
                    }
                    
                }
                
                
            }
            
        }
        print("missingTextFields = \(missingTextFields) missingFields = \(missingFields)")
        if missingTextFields {
            exercisesWarningLabel.text = "* Missing Fields *"
            missingFields = true
        } else if self.editTable.isHidden == true {
            exercisesWarningLabel.text = "* Add Exercises *"
            missingFields = true
        }
        
        if !missingFields {
            
            exercisesWarningLabel.text = ""
            
            //passes workout info to WorkoutVC //NEED TO ADD FOR HomeVC
            
            canPassData = true
            workoutToPass = WorkoutSession(duration: durationAsSecondsInput!, type: self.typeInput!, date: Date(), workoutExercises: self.selectedExercises)
            
            self.dismiss(animated: true, completion: nil)
            print("Passed selectedExercises to WorkoutVC")
        }
        
    }
    
    //validates selectedExercises
    func validateSelectedExercises(missingTextFields: Bool, _ selectedExercises: [SelectedExercises]) -> Bool {
        var missingTextFields = missingTextFields
        
        //validation for selectedExercises, loop through each exercise (given not all will be showing in tableView)
        for exercise in selectedExercises {
            
            //loop through each set for the exercise
            for set in exercise.exerciseSets! {
                
                if exercise.exerciseInfo == "Weights" {
                    
                    //checks if reps input missing
                    if set.reps == nil {
                        missingTextFields = true
                    }
                    
                    //checks if weight input missing
                    if set.weight == nil {
                        missingTextFields = true
                    }
                    
                } else if exercise.exerciseInfo == "Cardio" || exercise.exerciseInfo == "Circuits" {
                    
                    //checks if time input missing
                    if set.time == nil {
                        missingTextFields = true
                    }
                    
                } else {    //for Bodyweight
                    
                    //checks if reps input missing
                    if set.reps == nil {
                        missingTextFields = true
                    }
                    
                }
                
            }
        }
        
        return missingTextFields
    }
    
    
    //MARK: Cancel Button
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: ViewDisappear Confirm
    override func viewDidDisappear(_ animated: Bool) {
        
        if canPassData {
            
            delegate?.pass(thisWorkout: workoutToPass!)
            
            
            //ADD TO CORE DATA
            createCoreData(workoutToPass!)
            
        }
        
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("AddWorkout Loaded")
        
        minsSecondsPickListGenerate()
        durationPicker.delegate = self
        durationPicker.dataSource = self
        
        durationField.delegate = self
        durationField.inputView = durationPicker
        
        
        //Adds a toolbar to the pickerView, with a 'done' button that closes the pickerView
        self.durationField.inputAccessoryView = pickerViewToolBarStyles()
        
        
        if selectedExercises.isEmpty {
            self.editTable.isHidden = true
        }
        
        editTable.delegate = self
        editTable.dataSource = self
        editTable.rowHeight = 60
        
        
        editTable.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "ExerciseHeaderCell")
        editTable.register(UITableViewCell.self, forCellReuseIdentifier: "BelowExerciseHeaderCell")
        editTable.register(UITableViewCell.self, forCellReuseIdentifier: "AddExInfoTableCell")
        //editTable.register(UINib(nibName: "AddExInfoTableCell", bundle: nil), forCellReuseIdentifier: "AddExInfoTableCell")
        self.hideKeyboardWhenTappedAround()
        
        
        registerNotifications()
        
    }
    
}


//MARK: Duration Picker
extension AddWorkoutController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    //sets number of rows for each column in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return 6
        case 1,2:
            return 60
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) Hour"
        case 1:
            return "\(row) Minute"
        case 2:
            return "\(row) Second"
        default:
            return ""
        }
    }
    
    //changes label to Hours:Minutes:Seconds selected from picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            pickerTimePicked.0 = row
        case 1:
            pickerTimePicked.1 = row
        case 2:
            pickerTimePicked.2 = row
            
        default:
            print("pickerView - no component case")
        }
        
        if activeTextField.tag == 3 {
            print("active")
            activeTextField.textAlignment = .center
            activeTextField.font = UIFont(name: "HelveticaNeue", size: 22.0)
        }
        
        activeTextField.text = Helper.displayZeroInTime(pickerTimePicked)

    }
    
    
    //closes Duration picker view
    @objc private func doneButtonTapped(){
        self.activeTextField.resignFirstResponder()
    }
    
    //toolbar above picker view
    func pickerViewToolBarStyles() -> UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 50/255, green: 50/255, blue: 200/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneButtonTapped))
        toolBar.setItems([doneButton], animated: false)
        
        return toolBar
    }
    
}



//MARK: Exercise Table
extension AddWorkoutController: UITableViewDelegate, UITableViewDataSource, HeaderButtonDeletePressDelegate {
    
    
    func didPressDelete(_ section: Int) {
        //print("Section: \(section)")
        
        //print("Delete pressed: \(selectedExercisesSections)")
        
        let newSectionIndex = selectedExercisesSections.firstIndex(where: { $0 == section })
        //print("Index: \(newSectionIndex ?? 0)")
        selectedExercisesSections.remove(at: newSectionIndex ?? 0)
        
        
        //print("Section Removed: \(newSectionIndex ?? 0)")
        //print("Updated: \(selectedExercisesSections)")
        
        if newSectionIndex != nil {
            selectedExercises.remove(at: newSectionIndex!)
            
            let indexSet = IndexSet(integer: newSectionIndex!)
            editTable.deleteSections(indexSet, with: .fade)
        } else {
            selectedExercises.removeFirst()
            selectedExercisesSections.removeFirst()
            editTable.deleteSections(IndexSet(integer: 0), with: .fade)
        }
        
        
        if selectedExercises.count == 0 {
            editTable.isHidden = true
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let exHeaderCell = Bundle.main.loadNibNamed("ExerciseHeaderCell", owner: self, options: nil)?.first as! ExerciseHeaderCell
        exHeaderCell.delegate = self
        
        //print("Sections: \(selectedExercisesSections)")
        if !selectedExercisesSections.contains(section) {
            //inserts the section number to selectedExerciseSections at the index of value section
            if selectedExercisesSections.count > section {
                selectedExercisesSections.insert(section, at: section)
            } else {
                selectedExercisesSections.append(section)
            }
            
        } else if selectedExercisesSections.last == section {
            selectedExercisesSections.append(section)
        }
        
        exHeaderCell.deleteButton.setImage(UIImage(named: "icons8-close-window-100-dark"), for: .highlighted)
        exHeaderCell.deleteButton.setImage(UIImage(named: "icons8-close-window-100-dark"), for: .selected)
        exHeaderCell.setTitle(selectedExercises[section].exerciseName!)
        exHeaderCell.setType(selectedExercises[section].exerciseType!)
        exHeaderCell.getSelectedExercises(selectedExercises)
        
        exHeaderCell.getTable(editTable, section: section, rowsInSection: editTable.numberOfRows(inSection: section))
        
        return exHeaderCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.selectedExercises[section].exerciseSets?.count ?? 0) + 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.selectedExercises.count
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row > 1 {
            return true
        } else { return false }
    }
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        //avoids editing BelowHeaderCell
//        if indexPath.row > 0 {
//            if editingStyle == UITableViewCell.EditingStyle.delete {
//                print("delete row at: \(indexPath)")
//
//                //need to update indexPaths stored for selected exercise sets
//            }
//        }
//
//    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let thisExercise = self.selectedExercises[indexPath.section]
        
        //cell to display row headings -> Set Reps/Weight/Time
        if indexPath.row == 0  {
            let cell = Bundle.main.loadNibNamed("BelowExerciseHeaderCell", owner: self, options: nil)?.first as! BelowExerciseHeaderCell
            
            let thisExerciseInfo = thisExercise.exerciseInfo
            
            //changes labels for reps/weight/time
            cell.changeInputLabels(thisExerciseInfo!)
            
            return cell
            
        } else {
            let cell = Bundle.main.loadNibNamed("AddExInfoTableCell", owner: self, options: nil)?.first as! AddExInfoTableCell
            
            
            //changes label according to the current set
            cell.setLabels("\(indexPath.row)")
            
            
            //changes visible text fields given the current exercise type
            cell.changeTextFieldsForType(thisExercise.exerciseInfo!)
            
            //this class becomes the delegate, by extending the class with UITextFieldDelegate
            cell.inputReps.delegate = self
            cell.inputWeight.delegate = self
            cell.inputTime.delegate = self
            //cell.inputTime.inputAccessoryView = pickerViewToolBarStyles()
            
            //checks whether exerciseSet has already been assigned the current indexPath, if so, getSetCell will be an array with one element
            let getSetCell = thisExercise.exerciseSets?.filter( { $0.indexPath == indexPath } )
            let getSetForExercise = thisExercise.exerciseSets?.first(where: {$0.set == indexPath.row})
            
            //if array returned above is empty, indexPath is NOT in exerciseSets for the current selectedExercise
            if getSetCell?.count == 0 {
                
                //IndexPath ADDED to exerciseSets (for current set)
                getSetForExercise?.set = indexPath.row
                getSetForExercise?.indexPath = indexPath
                
            } else {
                
                if thisExercise.exerciseInfo == "Weights" {
                    //Weights - REPS, WEIGHT
                    
                    //checks whether REPS has been entered for the given set for an exercise, when cell loaded
                    if getSetForExercise?.reps != nil {
                        cell.inputReps.text = String(describing: (getSetForExercise?.reps)!)
                        
                    } else {
                        if finishClicked {
                            cell.inputReps.backgroundColor = #colorLiteral(red: 1, green: 0.2366749612, blue: 0.1882926814, alpha: 0.6023877641)
                        }
                    }
                    
                    //checks whether WEIGHT has been entered for the given set for an exercise, when cell loaded
                    if getSetForExercise?.weight != nil {
                        cell.inputWeight.text = String(describing: (getSetForExercise?.weight)!)
                        
                    } else {
                        if finishClicked {
                            cell.inputWeight.backgroundColor = #colorLiteral(red: 1, green: 0.2366749612, blue: 0.1882926814, alpha: 0.6023877641)
                        }
                    }
                    
                } else if thisExercise.exerciseInfo == "Cardio" || thisExercise.exerciseInfo == "Circuits" {
                    //Cardio/Circuits - TIME
                    
                    //checks whether weight has been entered for the given set for an exercise, when cell loaded
                    if getSetForExercise?.time != nil {
                        cell.inputTime.text = String(describing: (getSetForExercise?.time)!)
                        
                    } else {
                        if finishClicked {
                            cell.inputTime.backgroundColor = #colorLiteral(red: 1, green: 0.2366749612, blue: 0.1882926814, alpha: 0.6023877641)
                        }
                    }
                    
                } else {
                    //Bodyweight - REPS
                    
                    //checks whether REPS has been entered for the given set for an exercise, when cell loaded
                    if getSetForExercise?.reps != nil {
                        cell.inputReps.text = String(describing: (getSetForExercise?.reps)!)
                        
                    } else {
                        if finishClicked {
                            cell.inputReps.backgroundColor = #colorLiteral(red: 1, green: 0.2366749612, blue: 0.1882926814, alpha: 0.6023877641)
                        }
                    }
                }
            }
            
            return cell
        }
    }
    
    
    //prevents colour change of cell when clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .white
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .white
    }
    
    
} //end of AddWorkoutClass extension for tableView



//MARK: TextFields
extension AddWorkoutController {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 2:
            textField.inputView = durationPicker
            textField.inputAccessoryView = pickerViewToolBarStyles()
        default:
            print("")
            //print("activeTextField: \(activeTextField.tag)")
        }
        
        return true
    }
    
    //assigns the current textfield to activeTextField within this VC
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    //gets text in activeTextField and assigns it to either reps, weight, time for the correct set by retrieving the indexPath for the activeTextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.backgroundColor = .white
        
        //tag = 0 Reps textField | tag = 1 Weight textField | tag = 2 Time textField | tag = 3 Duration textField
        switch activeTextField.tag {
        case 0: //REPS
            //Retrieves CGPoint of activeTextField within tableView, then uses the CGPoint to get indexPath within tableView
            let pointInTable = activeTextField.convert(activeTextField.bounds.origin, to: self.editTable)
            let textFieldIndexPath = self.editTable.indexPathForRow(at: pointInTable)
            
            if Helper.isStringAnInt(string: activeTextField.text!) {
                let textToInt = Int(activeTextField.text!)
                selectedExercises[textFieldIndexPath!.section].exerciseSets?[textFieldIndexPath!.row - 1].reps = textToInt!
                //print("Added Reps")
            }
            
        case 1: //WEIGHT
            
            //Retrieves CGPoint of activeTextField within tableView, then uses the CGPoint to get indexPath within tableView
            let pointInTable = activeTextField.convert(activeTextField.bounds.origin, to: self.editTable)
            let textFieldIndexPath = self.editTable.indexPathForRow(at: pointInTable)
            
            if Helper.isStringAnInt(string: activeTextField.text!) {
                let textToInt = Int(activeTextField.text!)
                selectedExercises[textFieldIndexPath!.section].exerciseSets?[textFieldIndexPath!.row - 1].weight = textToInt!
                //print("Added weight")
            }
            
            
        case 2: //TIME
            //Retrieves CGPoint of activeTextField within tableView, then uses the CGPoint to get indexPath within tableView
            let pointInTable = activeTextField.convert(activeTextField.bounds.origin, to: self.editTable)
            let textFieldIndexPath = self.editTable.indexPathForRow(at: pointInTable)
            
            if activeTextField.text! != "" {
                let hoursMinsSecondsArr = activeTextField.text!.split{$0 == ":"}.map(String.init)
                
                //changes durationAsSecondsInput variable for when the workout is finished
                let hoursToSeconds = (Int(hoursMinsSecondsArr[0])! * 60) * 60
                let minsToSeconds = Int(hoursMinsSecondsArr[1])!  * 60
                let seconds = Int(hoursMinsSecondsArr[2])!
                
                selectedExercises[textFieldIndexPath!.section].exerciseSets?[textFieldIndexPath!.row - 1].time = hoursToSeconds + minsToSeconds + seconds
            }
            
        case 3: //DURATION
            
            if activeTextField.text! != "" {
                //[0] = hours | [1] = mins | [2] = seconds
                let hoursMinsSecondsArr = activeTextField.text!.split{$0 == ":"}.map(String.init)
                
                //changes durationAsSecondsInput variable for when the workout is finished
                let minsToSeconds = Int(hoursMinsSecondsArr[1])!  * 60
                let hoursToSeconds = (Int(hoursMinsSecondsArr[0])! * 60) * 60
                durationAsSecondsInput = hoursToSeconds + minsToSeconds + Int(hoursMinsSecondsArr[2])!
                
                durationWarningLabel.text = ""
            }
            
        default:
            print("TextfieldDidEndEditing - no activetextfield.tag case")
        }
        
        
    
    }
    
    
    //closes keyboard if return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //checks whether keyboard did show or did hide in the current view
    func registerNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    
    //changes position of scrollview when keyboard shown
    @objc func keyboardWillShow(notification: NSNotification){
        
        let userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        let activeTextFieldY = self.activeTextField.convert(activeTextField.bounds.origin, to: self.view)
        //print("textfield: \(activeTextFieldY.y + 100.0) keyboard: \(keyboardFrame.origin.y-keyboardFrame.size.height)")
        
        if activeTextFieldY.y + 100.0 > keyboardFrame.origin.y-keyboardFrame.size.height {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                //want scrollview to move all the way above the keyboard, so use contentOffset
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+keyboardFrame.size.height)
                self.scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrame.size.height)
            }, completion: nil)
        }
        
        
    }
    
    //changes position back to normal when keyboard not shown
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }, completion: nil)
    }
    
} //end of extension for TextFields





//MARK: Core Data
extension AddWorkoutController {
    
    func createCoreData(_ workoutSession: WorkoutSession){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "WorkoutList", in: managedContext)!
        
        let newWorkout = WorkoutList(entity: userEntity, insertInto: managedContext)
        newWorkout.workoutSession = workoutSession
        
        //NSManagedObject(entity: userEntity, insertInto: managedContext) as! WorkoutList
        //cmsg.setValue(workoutSession, forKey: "workoutSession")
        
        //objects added to context saved to persistent store
        do {
            try managedContext.save()
            print("Saved to persistent store")
        } catch {
            print("Failed to save to persistent store: \(error)")
        }
    }
    
}



extension UIViewController {
func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
}

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
