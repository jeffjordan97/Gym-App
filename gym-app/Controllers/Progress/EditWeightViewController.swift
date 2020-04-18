//
//  EditWeightViewController.swift
//  gym-app
//
//  Created by Jeff Jordan on 16/04/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol EditedGoalToProgress {
    func updatedGoalPassed(_ goal:GoalProgress)
}

class EditWeightViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var startWeightLabel: UILabel!
    @IBOutlet weak var currentWeightTextField: UITextField!
    @IBOutlet weak var goalWeightLabel: UILabel!
    
    
    
    //MARK: Attributes
    var goalPassed: GoalProgress?
    
    var activeTextField = UITextField()
    
    var delegate: EditedGoalToProgress?
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text! != "" {
            textField.text = textField.text! + "kg"
        }
    }
    
    
    func validateCurrentWeight() -> Bool {
        var canReturn = true
        
        var currentWeight = currentWeightTextField.text
        
        //removes kg from weight entered
        if (currentWeight?.contains("kg"))! {
            currentWeight?.removeLast(2)
        }
        
        if currentWeight == "" || currentWeight == nil {
            canReturn = false
            warningLabel.text = "Please Enter Current Weight"
        }
        
        if !Helper.isStringAnInt(string: currentWeight!) {
            canReturn = false
            warningLabel.text = "Invalid Weight"
        }
        
        return canReturn
    }
    
    
    
    @IBAction func confirmButton(_ sender: Any) {
        
        //validation for entered text field
        if validateCurrentWeight() {
            
            //passes updated goal to
            delegate?.updatedGoalPassed(goalPassed!)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        outerView.layer.cornerRadius = 40
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Edit Weight Loaded")
        
        currentWeightTextField.delegate = self
        
        
        if goalPassed != nil {
            let startWeight = goalPassed?.startWeight!
            let goalWeight = goalPassed?.goalWeight!
            
            titleLabel.text = goalPassed?.type!
            startWeightLabel.text = "\(startWeight!)kg"
            goalWeightLabel.text = "\(goalWeight!)kg"
            
        }
        
        currentWeightTextField.inputAccessoryView = textFieldToolBar()
        
    }
}

extension EditWeightViewController {
    
    func textFieldToolBar() -> UIToolbar {
        
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
    
}
