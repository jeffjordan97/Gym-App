//
//  SettingsController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 11/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MaterialComponents.MDCFloatingButton

class SettingsController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var settingsTable: UITableView!
    @IBOutlet weak var exercisesSelectButton: MDCFloatingButton!
    @IBOutlet weak var removeDataButton: UIButton!
    
    
    
    //MARK: Attributes
    var preferredActivites = [String]()
    
    
    
    @IBAction func removeDataButtonAction(_ sender: Any) {
        print("Clicked Remove All Data")
        clearCoreData()
    }
    
    
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func clearCoreData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProgressList")
        
        let fetchRequestTwo = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutList")
        
        do {
            let results = try managedContext.fetch(fetchRequestTwo)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    managedContext.delete(result)
                }
                do {
                    try managedContext.save()
                    print("Removed ALL core data")
                } catch {
                    print("Error saving context from delete: ", error)
                }
            }
        } catch {
            print("Error fetching results: ",error)
        }
        
        do {
            let results = try managedContext.fetch(fetchRequest)

            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    managedContext.delete(result)
                }
                do {
                    try managedContext.save()
                    print("Removed ALL core data")

                } catch {
                    print("Error saving context from delete: ", error)
                }
            }
        } catch {
            print("Error fetching results: ",error)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        settingsView.layer.cornerRadius = 20
        settingsView.layer.shadowOpacity = 1
        settingsView.layer.shadowColor = UIColor.opaqueSeparator.cgColor
        settingsView.layer.shadowRadius = 10
        settingsTable.layer.cornerRadius = 20
        
        removeDataButton.layer.cornerRadius = 20
        removeDataButton.layer.shadowOpacity = 1
        removeDataButton.layer.shadowColor = UIColor.opaqueSeparator.cgColor
        removeDataButton.layer.shadowRadius = 10
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Settings Loaded")
        
        
        settingsTable.dataSource = self
        settingsTable.delegate = self
        
    }
}



extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsInSection:Int = 0
        
        switch section {
        case 0:     //Profile
            rowsInSection = 1
        case 1:     //Preferences
            rowsInSection = 2
        case 2:     //Preferred Exercises
            if preferredActivites.count == 0 {
                rowsInSection = 1
            } else {
               rowsInSection = preferredActivites.count
            }
        case 3:     //General
            rowsInSection = 2
        default:
            print("noOfRowsInSection")
        }
        
        return rowsInSection
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height:CGFloat = 0.0
        
        switch section {
        case 0:     //Profile
            height = 0
        case 1, 2, 3:     //Preferences, Preferred Exercises, General
            height = 40
        
        default:
            print("heightForHeaderInSection")
        }
        
        return height
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: settingsTable.frame.width, height: 40))
        headerView.backgroundColor = .opaqueSeparator
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: 200, height: 20))
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        headerView.addSubview(titleLabel)
        
        switch section {
        case 0:
            return UIView()
        case 1:
            titleLabel.text = "Preferences"
        case 2:
            titleLabel.text = "Preferred Exercises"
            let button = exercisesSelectButton
            button?.frame = CGRect(x: settingsTable.frame.width - 80, y: 7.5, width: 60, height: 25)
            button?.backgroundColor = .link
            if button != nil {
                headerView.addSubview(button!)
            }
            
        case 3:
            titleLabel.text = "General"
        default:
            print("viewForHeaderInSection")
        }
        
        return headerView
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0.0
        
        switch indexPath.section {
        case 0:
            height = 100
        case 1,2,3:
            height = 50
        default:
            print("heightForRowAt")
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: settingsTable.frame.width, height: 50))
        cell.separatorInset = UIEdgeInsets.zero
        
        switch indexPath.section {
        case 0:     //Profile
            cell.frame = CGRect(x: 0, y: 0, width: settingsTable.frame.width, height: 100)
            cell.accessoryType = .disclosureIndicator
            
            let profileImage = UIImage(systemName: "person.circle")
            let imageView = UIImageView(image: profileImage)
            imageView.tintColor = .black
            imageView.frame = CGRect(x: 20, y: 20, width: 60, height: 60)
            cell.addSubview(imageView)
            
            let profileName = UILabel(frame: CGRect(x: 100, y: 30, width: 120, height: 20))
            profileName.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
            profileName.text = "Default Name"
            cell.addSubview(profileName)
            
            let achievementsComplete = UILabel(frame: CGRect(x: 100, y: 50, width: 120, height: 20))
            achievementsComplete.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
            achievementsComplete.text = "Achievements: 0"
            cell.addSubview(achievementsComplete)
            
        case 1:     //Preferences
            
            let rowTitle = UILabel(frame: CGRect(x: 20, y: 15, width: 120, height: 25))
            rowTitle.font = UIFont(name: "HelveticaNeue", size: 16.0)
            cell.addSubview(rowTitle)
            cell.accessoryType = .disclosureIndicator
            
            switch indexPath.row {
            case 0:         //Preferences: Weight unit
                rowTitle.text = "Weight Unit"
            case 1:         //Preferences: Notifications
                rowTitle.text = "Notifications"
            default:
                print("cellForRowAt section:\(indexPath.section)")
            }
        
            
        case 2:     //PreferredExercises
            
            let rowTitle = UILabel(frame: CGRect(x: 20, y: 15, width: settingsTable.frame.width, height: 25))
            rowTitle.font = UIFont(name: "HelveticaNeue", size: 16.0)
            cell.addSubview(rowTitle)
            
            if preferredActivites.count == 0 {
                rowTitle.text = "No Exercises"
            } else {
                let activityForRow = preferredActivites[indexPath.row]
                rowTitle.text = activityForRow
            }
            
            
        case 3:     //General
            
            let rowTitle = UILabel(frame: CGRect(x: 20, y: 15, width: 120, height: 25))
            rowTitle.font = UIFont(name: "HelveticaNeue", size: 16.0)
            cell.addSubview(rowTitle)
            cell.accessoryType = .disclosureIndicator
            
            switch indexPath.row {
            case 0:
                rowTitle.text = "Terms of Service"
            case 1:
                rowTitle.text = "Privacy Policy"
            default:
                print("cellForRowAt section:\(indexPath.section)")
            }
            
        default:
            print("cellForRowAt")
        }
        
        return cell
    }
    
    
    
    
}
