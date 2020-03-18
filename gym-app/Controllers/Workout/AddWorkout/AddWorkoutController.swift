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

class AddWorkoutController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    //MARK: Outlets
    @IBOutlet weak var woTypeView: UIView!
    
    @IBOutlet weak var woTypeLabel: UILabel!
    
    @IBOutlet weak var hoursField: UITextField!
    
    @IBOutlet weak var editTable: UITableView!
    
    
    //MARK: Attributes
    
    private var durationPicker = UIPickerView()
    
    
    
    //stores all exercises from JSON file
    var exList = [exListJson]()
    
    private var list = ["0","1","2","3","4","5","6","7","8","9"]
    
    
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
            self.woTypeLabel.font = self.woTypeLabel.font.withSize(22.0)
        }
        
        typeDropDown.show()
    }
    
    
    
    var hoursPickList = ["0","1","2", "3", "4", "5"]
    var minsPickList = ["0","1","2", "3", "4", "5", "6", "7", "8", "9", "10", "11","12","13","14","15"]
    var titlePickList = ["hours", "mins"]
    
    
    //MARK: Duration Input
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
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
    
    //closes Duration pickerView
    @objc private func doneButtonTapped(){
        self.hoursField.resignFirstResponder()
    }
    
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //function to pass info to AddWorkoutController
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
        
    }
}

extension AddWorkoutController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exercise = exList[indexPath.row]
        
        let cell = editTable.dequeueReusableCell(withIdentifier: "EditTableCell", for: indexPath)
        
        return cell
    }
    
    
    
    
}
