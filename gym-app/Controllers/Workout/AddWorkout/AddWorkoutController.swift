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

class AddWorkoutController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var woTypeView: UIView!
    
    @IBOutlet weak var woTypeLabel: UILabel!
    
    @IBOutlet weak var hoursField: UITextField!
    
    @IBOutlet weak var durationWarningLabel: UILabel!
    
    @IBOutlet weak var typeWarningLabel:UILabel!
    
    @IBOutlet weak var exercisesWarningLabel: UILabel!
    
    @IBOutlet weak var editTable: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: Attributes
    
    var durationPicker = UIPickerView()
    
    //constants for duration picker view
    let hoursPickList = ["0","1","2", "3", "4", "5"]
    let minsPickList = ["0","1","2", "3", "4", "5", "6", "7", "8", "9", "10", "11","12","13","14","15"]
    let titlePickList = ["hours", "mins"]
    
    //Stores all selectedExercises from ExercisesController, used in TableView
    var selectedExercises = [SelectedExercises]()
    var activeTextField = UITextField()
    
    
    
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
            self.typeWarningLabel.text = ""
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
    
    var finishClicked = false
    
    //MARK: Finish Button
    @IBAction func finishButton(_ sender: Any) {
    
        missingFields()
        //to highlight unedited cells when loaded into view via the cellForRowAt function
        finishClicked = true
        
    }
    
    
    
    func missingFields(){
        
        var missingFields = false
        var missingTextFields = false
        guard let visibleIndexes = self.editTable.indexPathsForVisibleRows else { return  }
        
        if hoursField.text == nil || hoursField.text == "" {
            durationWarningLabel.text = "* Missing Duration *"
            missingFields = true
        }
        if woTypeLabel.text == nil || woTypeLabel.text == "" || woTypeLabel.text == "Select" {
            typeWarningLabel.text = "* Missing Type *"
            missingFields = true
        }
        
        //loops through all visible indexPaths and adds background colour if textfield doesnt contain text
        for index in visibleIndexes {
            if index.row > 0 {
                let cell = self.tableView(self.editTable, cellForRowAt: index) as? AddExInfoTableCell
                
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
            if let workoutVC = self.presentingViewController as? WorkoutController {
                workoutVC.selectedExercises = self.selectedExercises
                
                //workoutVC.historyTable.isHidden = false
                //workoutVC.historyTable.reloadData()
            }
            self.dismiss(animated: true, completion: nil)
            print("Passed selectedExercises to WorkoutVC")
        }
        
    }
    
    
    //MARK: Cancel Button
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        
        if selectedExercises.isEmpty {
            self.editTable.isHidden = true
        }
        
        editTable.delegate = self
        editTable.rowHeight = 60
        
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
        durationWarningLabel.text = ""
        
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
        return (selectedExercises[section].exerciseSets?.count ?? 0) + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let thisExercise = selectedExercises[indexPath.section]
        
        //cell to display row headings -> Set Reps Weight
        if indexPath.row == 0  {
            let cell = Bundle.main.loadNibNamed("BelowExerciseHeaderCell", owner: self, options: nil)?.first as! BelowExerciseHeaderCell
            
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("AddExInfoTableCell", owner: self, options: nil)?.first as! AddExInfoTableCell
            
            cell.setLabels("\(indexPath.row)")
            
            
            //this class becomes the delegate, by extending the class with UITextFieldDelegate
            cell.inputReps.delegate = self
            cell.inputWeight.delegate = self
            
            //checks whether exerciseSet has already been assigned the current indexPath, if so, getSetCell will be an array with one element
            let getSetCell = thisExercise.exerciseSets?.filter( { $0.indexPath == indexPath } )
            
            //if array returned above is empty, indexPath is not in exerciseSets for the current selectedExercise
            if getSetCell?.count == 0 {
                //print("Index NOT in exerciseSets for exercise: \(selectedExercises[indexPath.section].exerciseName!)")
                
                let getSetForExercise = thisExercise.exerciseSets?.first(where: {$0.set == indexPath.row})
                
                getSetForExercise?.indexPath = indexPath
                //print("Index \(String(describing: getSetForExercise?.indexPath)) added to exerciseSets: \(String(describing: getSetForExercise?.set))")
                
            } else {
                //index in selectedExercises for the given exerciseSet
                let getSetForExercise = thisExercise.exerciseSets?.first(where: {$0.set == indexPath.row})
                //print("Index IN exerciseSets for exercise: \(thisExercise.exerciseName!) \(String(describing: getSetForExercise?.indexPath))")
                if getSetForExercise?.reps != nil {
                    cell.inputReps.text = String(describing: (getSetForExercise?.reps)!)
                    //cell.inputReps.backgroundColor = .lightGray
                } else {
                    if finishClicked {
                        cell.inputReps.backgroundColor = #colorLiteral(red: 1, green: 0.2366749612, blue: 0.1882926814, alpha: 0.6023877641)
                    }
                }
                if getSetForExercise?.weight != nil {
                    cell.inputWeight.text = String(describing: (getSetForExercise?.weight)!)
                    //cell.inputWeight.backgroundColor = .lightGray
                } else {
                    if finishClicked {
                        cell.inputWeight.backgroundColor = #colorLiteral(red: 1, green: 0.2366749612, blue: 0.1882926814, alpha: 0.6023877641)
                    }
                }
            }
            
            //check if reps and weight for exerciseSet in selectedExercises where indexpaht
            //if indexPathForTextField()
            
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
    
    //prevents colour change of cell when clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .white
        //print("clicked!")
        
    }
    
    //checks whether a string can be converted to an Int
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    
    //assigns the current textfield to activeTextField within this VC
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    //gets text in activeTextField and assigns it to either reps or weight for the correct set by retrieving the indexPath for the activeTextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Retrieves CGPoint of activeTextField within tableView, then uses the CGPoint to get indexPath within tableView
        let pointInTable = activeTextField.convert(activeTextField.bounds.origin, to: self.editTable)
        let textFieldIndexPath = self.editTable.indexPathForRow(at: pointInTable)
        
        //tag = 0 Reps textField | tag = 1 Weight textField
        if activeTextField.tag == 0 {
            
            if isStringAnInt(string: activeTextField.text!) {
                let textToInt = Int(activeTextField.text!)
                selectedExercises[textFieldIndexPath!.section].exerciseSets?[textFieldIndexPath!.row - 1].reps = textToInt!
                //print("Added Reps")
            }
        } else if activeTextField.tag == 1 {
            
            if isStringAnInt(string: activeTextField.text!) {
                let textToInt = Int(activeTextField.text!)
                selectedExercises[textFieldIndexPath!.section].exerciseSets?[textFieldIndexPath!.row - 1].weight = textToInt!
                //print("Added weight")
            }
        }
        
//        if let activeTextFieldtext = self.activeTextField.text {
//            print("Active Text Field: \(activeTextFieldtext)")
//            return
//        }
//        print("Active Text Field: Empty")
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
    
    
} //end of AddWorkoutClass extension


class SelectedExercises {
    var exerciseName: String?
    var exerciseType: String?
    var exerciseInfo: String?
    var exerciseSets: [SetRepsWeights]?
    
    init(exerciseName:String, exerciseType:String, exerciseInfo: String, exerciseSets:[SetRepsWeights]) {
        self.exerciseName = exerciseName
        self.exerciseType = exerciseType
        self.exerciseInfo = exerciseInfo
        self.exerciseSets = exerciseSets
    }
}


class SetRepsWeights {
    var set: Int?
    var reps: Int?
    var weight: Int?
    var indexPath: IndexPath?
    
    init(set:Int, reps:Int?, weight:Int?, indexpath:IndexPath){
        self.set = set
        self.reps = reps
        self.weight = weight
        self.indexPath = indexpath
    }
}

class SetTimeCardio {
    var set: Int?
    var time: Int
    
    init(set: Int, time: Int) {
        self.set = set
        self.time = time
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
