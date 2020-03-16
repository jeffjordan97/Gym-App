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

class ExercisesController: UIViewController {
    
    
    
    //MARK: Outlets
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var exSegControl: UISegmentedControl!
    
    
    //MARK: Attributes
    
    struct exListJson: Decodable {
        var name: String?
        var info: String?
        var type: String?
        var image: String?
    }
    
    //stores all exercises from JSON file
    var exList = [exListJson]()
    
    
    
    
    
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
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        
        //pass selected exercises to AddWorkoutVC...
        
        
        print("...Exercises saved...")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
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
            table.rowHeight = 80
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
        
        return cell
    }
    
}
