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
                print(addEx)
                
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
    
    
    
    
    
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Exercises Loaded")
        
        getJSON()
        
        table.rowHeight = 80
    }
}





//MARK: Table View
extension ExercisesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let exercise = exList[indexPath.row]
        
        let cell = table.dequeueReusableCell(withIdentifier: "exCell") as! ExerciseCell
        cell.setLabels(exercise.name!, exercise.type!, exercise.info!)
        cell.handleExerciseImage(exercise.image!)
        return cell
    }
    
}

class ExerciseCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var exImage: UIImageView!
    @IBOutlet weak var tickImage: UIImageView!
    
    //function for add button tapped
    
    
    
    func setLabels(_ title: String, _ type: String, _ info: String){
        nameLabel.text = title
        typeLabel.text = type
        infoLabel.text = info
    }
    
    
    func handleExerciseImage(_ imageString: String){
        if imageString == "" {
            exImage.image = UIImage(named: "icons8-no-image-50")!
        }else {
            exImage.image = UIImage(named: imageString)!
        }
        
    }
    
    
    @IBAction func cellButton(_ sender: Any) {
        if cellView.backgroundColor == .none {
            cellView.backgroundColor = #colorLiteral(red: 0.751993654, green: 0.9365622094, blue: 1, alpha: 1)
            tickImage.image = UIImage(named: "icons8-tick-box-50")
        } else if cellView.backgroundColor == #colorLiteral(red: 0.751993654, green: 0.9365622094, blue: 1, alpha: 1) {
            cellView.backgroundColor = .none
            tickImage.image = UIImage(named: "icons8-unchecked-checkbox-50")
        }
    }
    
    
}
