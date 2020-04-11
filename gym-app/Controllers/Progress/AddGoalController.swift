//
//  AddGoalController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 12/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import DropDown

protocol passBackToProgress: class {
    //add allGoalProgress: [goalProgress] as param
    func dataToPass(_ goalProgress: GoalProgress)
}

class AddGoalController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var goalTypeView: UIView!
    @IBOutlet weak var goalTypeLabel: UILabel!
    @IBOutlet weak var goalTypeWarningLabel: UILabel!
    
    @IBOutlet weak var goalTimeTextField: UITextField!
    @IBOutlet weak var goalTimeWarningLabel: UILabel!
    
    
    @IBOutlet weak var goalNotesTextView: UITextView!
    @IBOutlet weak var goalNotesPlaceholderLabel: UILabel!
    
    @IBOutlet weak var customTypeView: UIView!
    @IBOutlet weak var customTypeWarningLabel: UILabel!
    
    
    @IBOutlet weak var currentWeightTextField: UITextField!
    @IBOutlet weak var goalWeightTextField: UITextField!
    
    @IBOutlet weak var primaryGoalButton: UIButton!
    
    @IBOutlet weak var starOneButton: UIButton!
    @IBOutlet weak var starTwoButton: UIButton!
    @IBOutlet weak var starThreeButton: UIButton!
    @IBOutlet weak var starFourButton: UIButton!
    @IBOutlet weak var starFiveButton: UIButton!
    
    
    //MARK: Attributes
    //related to Type
    var goalType:String = ""
    
    //related to Date (to Complete)
    var goalTimePicker = UIDatePicker()
    var goalTimeAsDays: Int?
    let dateFormatter = DateFormatter()
    var goalEndDate:Date = Date()
    
    //related to current weight and goal weight inputs
    var activeTextField = UITextField()
    
    //related to Primary Goal and Importance
    var primaryGoal:Bool = false
    var starRating:Int = 0
    
    //delegate assigned in Progress Controller
    weak var delegate: passBackToProgress? = nil
    
    
    //MARK: Type - Dropdown
    //creates a dropdown menu for the user to select the goal type
    @IBAction func progressTypeButton(_ sender: Any) {
        
        let goalTypeDropDown = DropDown()
        
        goalTypeDropDown.dataSource = ["Improve Fitness","Improve Strength" ,"Build Muscle","Lose Weight"]
        
        // The view to which the drop down will appear on
        goalTypeDropDown.anchorView = goalTypeView // UIView or UIBarButtonItem
        
        // Action triggered on selection
        goalTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          //print("Selected item: \(item) at index: \(index)")
            
            //checks if item has been selected from dropDown, as user may click off before selecting
            if item != "" {
                self.goalTypeLabel.text = item
                self.goalType = item
                self.goalTypeLabel.textColor = .black
                self.goalTypeLabel.textAlignment = .center
                self.goalTypeLabel.font = self.goalTypeLabel.font.withSize(22.0)
                self.goalTypeWarningLabel.text = ""
                
                
                if item == "Build Muscle" || item == "Lose Weight" {
                    self.customTypeView.isHidden = false
                } else {
                    self.customTypeView.isHidden = true
                }
            }
        }
        goalTypeDropDown.show()
    }
    
    
    //MARK: Date (To Complete) - Picker View
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
    
    
    //closes Duration picker view
    @objc private func doneButtonTapped(){
        self.activeTextField.resignFirstResponder()
    }
    
    
    //assigns activeTextField to the textField that began editing, so keyboard can be closed on doneButtonTapped()
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    //Target when goalTimePicker value has been selected
    @objc func goalTimePickerValueChanged(_ sender: UIDatePicker){
        
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        let selectedDate:String = dateFormatter.string(from: sender.date)
        
        //print("SelectedDate: \(selectedDate)")
        
        activeTextField.textAlignment = .center
        activeTextField.font = UIFont(name: "HelveticaNeue", size: 22.0)
        activeTextField.text = selectedDate + "         " + Helper.returnDatesDifference(Date(), sender.date)
        
        goalTimeWarningLabel.text = ""
        
        //assigns the date selected to the goalEndDate
        goalEndDate = sender.date
    }
    
    
    //MARK: Notes - Text View
    func textViewDidChange(_ textView: UITextView) {
        
        //if text view is not empty, returns !true, isHidden becomes false, showing placeholder label
        goalNotesPlaceholderLabel.isHidden = !goalNotesTextView.text.isEmpty
    }
    
    
    //MARK: Importance
    //primary goal button action
    @IBAction func primaryGoalButtonAction(_ sender: Any) {
        if !primaryGoalButton.isSelected {
            primaryGoal = true
            primaryGoalButton.isSelected = true
            
            starRating = 5
            starOneButton.isSelected = true
            starTwoButton.isSelected = true
            starThreeButton.isSelected = true
            starFourButton.isSelected = true
            starFiveButton.isSelected = true
            
        } else {
            primaryGoal = false
            primaryGoalButton.isSelected = false
            
            starRating = 0
            starOneButton.isSelected = false
            starTwoButton.isSelected = false
            starThreeButton.isSelected = false
            starFourButton.isSelected = false
            starFiveButton.isSelected = false
        }
    }
    
    //Assigns value of star rating for each button
    @IBAction func starOneButtonAction(_ sender: Any) {
        
        if !starOneButton.isSelected {
            starOneButton.isSelected = true
            starRating = 1
        } else {
            starOneButton.isSelected = false
            starRating = 0
        }
        
        starTwoButton.isSelected = false
        starThreeButton.isSelected = false
        starFourButton.isSelected = false
        starFiveButton.isSelected = false
    }
    
    @IBAction func starTwoButtonAction(_ sender: Any) {
        starRating = 2
        starOneButton.isSelected = true
        starTwoButton.isSelected = true
        starThreeButton.isSelected = false
        starFourButton.isSelected = false
        starFiveButton.isSelected = false
    }
    
    @IBAction func starThreeButtonAction(_ sender: Any) {
        starRating = 3
        starOneButton.isSelected = true
        starTwoButton.isSelected = true
        starThreeButton.isSelected = true
        starFourButton.isSelected = false
        starFiveButton.isSelected = false
    }
    
    @IBAction func starFourButtonAction(_ sender: Any) {
        starRating = 4
        starOneButton.isSelected = true
        starTwoButton.isSelected = true
        starThreeButton.isSelected = true
        starFourButton.isSelected = true
        starFiveButton.isSelected = false
    }
    
    @IBAction func starFiveButtonAction(_ sender: Any) {
        starRating = 5
        starOneButton.isSelected = true
        starTwoButton.isSelected = true
        starThreeButton.isSelected = true
        starFourButton.isSelected = true
        starFiveButton.isSelected = true
    }
    
    
    
    //validation for type input
    func validateType() -> Bool {
        if goalType != "" {
            goalTypeWarningLabel.text = ""
            return true
        } else {
            goalTypeWarningLabel.text = "* Missing Type *"
            return false
        }
    }
    
    //validation for date input
    func validateDate() -> Bool {
        if goalEndDate != nil {
            goalTimeWarningLabel.text = ""
            return true
        } else {
            goalTimeWarningLabel.text = "* Missing Date *"
            return false
        }
    }
    
    //validate current weight and goal weight text fields  (if type is 'Build Muscle' or 'Lose Weight')
    func validateWeight() -> Bool {
        var canReturnCurrent = true
        var canReturnGoal = true
        
        // if current text field is empty, or if current text field cannot be converted to an Int, change warning label
        if currentWeightTextField.text == nil || currentWeightTextField.text == "" || !Helper.isStringAnInt(string: currentWeightTextField.text!) {
            customTypeWarningLabel.text = "* Invalid Current Weight *"
            canReturnCurrent = false
        }
        
        if goalWeightTextField.text == nil || goalWeightTextField.text == "" || !Helper.isStringAnInt(string: goalWeightTextField.text!) {
            customTypeWarningLabel.text = "* Invalid Goal Weight *"
            canReturnGoal = false
        }
        
        //if both text fields are empty
        if !canReturnCurrent && !canReturnGoal {
            customTypeWarningLabel.text = "* Invalid Current Weight * Invalid Goal Weight *"
        }
        
        if canReturnCurrent && canReturnGoal {
            return true
        } else { return false }
    }
    
    
    //MARK: Finish Button
    @IBAction func finishButton(_ sender: Any) {
        print("....Clicked....")
        print("Type: \(goalType)")
        print("Date: \(goalEndDate)")
        print("Notes: \(goalNotesTextView.text!)")
        print("As Primary Goal?: \(primaryGoal)")
        print("Importance: \(starRating)")
        
        
        //var goalProgressAdded:GoalProgress = GoalProgress(type: "", startDate: date, endDate: date, notes: goalNotesTextView.text, startWeight: nil, currentWeight: nil, goalWeight: nil, primaryGoal: primaryGoal, rating: starRating)
        
        //validates all fields, and if the goal type is either of the two regarding weight,
        
        let typeValidated:Bool = validateType()
        let dateValidated:Bool = validateDate()
        
        if typeValidated && dateValidated {
                if goalType == "Build Muscle" || goalType == "Lose Weight" {
                    if validateWeight() {
                        
                        let goalProgressAdded: GoalProgress = GoalProgress(type: goalType, startDate: Date(), endDate: goalEndDate, notes: goalNotesTextView.text, startWeight: Int(currentWeightTextField.text!), currentWeight: nil, goalWeight: Int(goalWeightTextField.text!), primaryGoal: primaryGoal, rating: starRating, isComplete: false)
                        
                        //passes added goal back to ProgressVC
                        delegate?.dataToPass(goalProgressAdded)
                        
                        //updates Core Data
                        createCoreData(goalProgressAdded)
                        
                        //dismisses the current VC
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    
                    let goalProgressAdded: GoalProgress = GoalProgress(type: goalType, startDate: Date(), endDate: goalEndDate, notes: goalNotesTextView.text, startWeight: nil, currentWeight: nil, goalWeight: nil, primaryGoal: primaryGoal, rating: starRating, isComplete: false)
                    
                    
                    delegate?.dataToPass(goalProgressAdded)
                    
                    createCoreData(goalProgressAdded)
                    
                    self.dismiss(animated: true, completion: nil)
                }
        }
        
    }
    
    
    //MARK: Cancel Button
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("AddGoal Loaded")
        
        goalTimePicker.datePickerMode = .date

        goalTimeTextField.delegate = self
        
        goalTimePicker.addTarget(self, action: #selector(AddGoalController.goalTimePickerValueChanged(_:)), for: .valueChanged)
        goalTimePicker.timeZone = NSTimeZone.local
        goalTimePicker.minimumDate = Date()
        goalTimeTextField.inputView = goalTimePicker
        goalTimeTextField.inputAccessoryView = pickerViewToolBarStyles()
        
        
        goalNotesTextView.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        
        let checkedBoxImage = UIImage(named: "icons8-tick-box-50")
        primaryGoalButton.setImage(checkedBoxImage, for: .selected)
        
        let starSelectedImage = UIImage(named: "icons8-star-100-filled")
        starOneButton.setImage(starSelectedImage, for: .selected)
        starOneButton.setImage(starSelectedImage, for: .highlighted)
        starTwoButton.setImage(starSelectedImage, for: .selected)
        starTwoButton.setImage(starSelectedImage, for: .highlighted)
        starThreeButton.setImage(starSelectedImage, for: .selected)
        starThreeButton.setImage(starSelectedImage, for: .highlighted)
        starFourButton.setImage(starSelectedImage, for: .selected)
        starFourButton.setImage(starSelectedImage, for: .highlighted)
        starFiveButton.setImage(starSelectedImage, for: .selected)
        starFiveButton.setImage(starSelectedImage, for: .highlighted)
        
        customTypeView.isHidden = true
    }
}

extension AddGoalController {
    
    func createCoreData(_ goalProgress: GoalProgress){
        
        //refer to container set up in AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "ProgressList", in: managedContext)!

        let newProgress = NSManagedObject(entity: userEntity, insertInto: managedContext)
        newProgress.setValue(goalProgress, forKey: "goalProgress")

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
