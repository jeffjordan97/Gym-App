//
//  ExercisesController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 06/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct exListJson: Decodable {
    var name: String?
    var info: String?
    var type: String?
    var image: String?
}

class ExercisesController: UIViewController {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var exSegControl: UISegmentedControl!
    @IBOutlet weak var warningLabel: UILabel!
    
    
    //MARK: Attributes
    
    //stores all exercises from JSON file
    var exList = [exListJson]()
    
    var selectedExList = [exListJson]()
    
    
    
    //MARK: Decode JSON
    //decodes JSON data and adds the data to the exList array
    func getJSON(){
        guard let filePath = Bundle.main.path(forResource: "testJSON", ofType: "json") else {return}
        let url = URL(fileURLWithPath: filePath)
        
        do {
            let data = try Data.init(contentsOf: url)
            let jsonData = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //print(jsonData)
            
            guard let jsonArray = jsonData as? [Any] else {return}
            
            for exercise in jsonArray {
                guard let exerciseDict = exercise as? [String: Any] else {return}
                guard let exerciseName = exerciseDict["name"] as? String else {return}
                guard let exerciseInfo = exerciseDict["info"] as? String else {return}
                guard let exerciseType = exerciseDict["type"] as? String else {return}
                guard let exerciseImage = exerciseDict["image"] as? String else {return}
                
                //print(exerciseName, " : ", exerciseInfo)
                
                let addEx = exListJson(name: exerciseName, info: exerciseInfo, type: exerciseType, image: exerciseImage)
                exList.append(addEx)
                //print(addEx)
                
            }
            
        } catch {
            print("Error getting JSON: ", error)
        }
    }
    
    
    //MARK: Cancel button
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: Add Button
    @IBAction func addButton(_ sender: Any) {
        
        
        //pass selected exercises to AddWorkoutVC...
        if selectedExList.count > 0 {
            
            print("...Exercises saved...")
            
            if let addVC = self.presentingViewController as? AddWorkoutController {
               
                //adds exercises from selectedExList to selectedExercises within the AddWorkoutVC
                for exercise in self.selectedExList {
                    addVC.selectedExercises.append(SelectedExercises.init(exerciseName: exercise.name!, exerciseType: exercise.type!, exerciseInfo: exercise.info!, exerciseSets: [SetRepsWeights(set: 1, reps: nil, weight: nil, time: nil, indexpath: IndexPath())]))
                }
                
                addVC.editTable.isHidden = false
                addVC.editTable.reloadData()
                
            }
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            warningLabel.text = "* No Exercises Selected *"
        }
        
        
    }
    
    
    //MARK: Segment Control Tapped
    @IBAction func exSegControlTapped(_ sender: Any) {
        
        var segIndex = exSegControl.selectedSegmentIndex
        
        if segIndex == 0 {
            table.isHidden = false
            table.reloadData()
        } else {
            table.isHidden = true
            
            table.reloadData()
        }
    }
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Exercises Loaded")
        
        getJSON()
        
        table.dataSource = self
        
        if exSegControl.selectedSegmentIndex == 0 {
            table.register(UINib(nibName: "ExercisesTableCell", bundle: nil), forCellReuseIdentifier: "ExercisesTableCell")
        } else {
            print("Routines table")
        }
        
    }
}





//MARK: Table View
extension ExercisesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let exercise = exList[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "ExercisesTableCell", for: indexPath) as! ExercisesTableCell
        
        cell.setLabels(exercise.name!, exercise.type!, exercise.info!)
        cell.setImage(exercise.image!)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.734172568, green: 0.997696025, blue: 1, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        //didSelectRow for Exercises
        if exSegControl.selectedSegmentIndex == 0 {
            let exercise = exList[indexPath.row]
            
            //print(exercise.name)
            
            let cell = table.cellForRow(at: indexPath) as! ExercisesTableCell
            
            cell.boxTicked()
            
            //If box ticked, add exercise to selectedExList
            if cell.checked {
                selectedExList.append(exercise)
                
            } else {
                //check if exercise in selectedExList, remove
                if selectedExList.contains(where: {$0.name == exercise.name}) {
                    let getIndex = selectedExList.firstIndex(where: {$0.name == exercise.name})
                    selectedExList.remove(at: getIndex!)
                    
                }
            }
        } else {
            //didSelectRow for Routines
            
            //let routine = routineList[indexPath.row]
            //let cell = table.cellForRow(at: indexPath) as! RoutinesTableCell
            //cell.boxTicked()
        }
        
        
        
    }
    
}
