//
//  ViewController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 02/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit
import CoreData
import SOTabBar

class ViewController: SOTabBarController {
    
    
    //MARK: Attributes
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext?
    
    
    //MARK: Remove Core Data
    func removeCoreData() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutList")
        //let entity = NSEntityDescription.entity(forEntityName: "WorkoutList", in: context!)
        
        do {
            let results = try context?.fetch(fetchRequest)
            if results!.count > 0 {
                for result in results as! [NSManagedObject] {
                    context?.delete(result)
                }
                do {
                    try context?.save()
                } catch {
                    print("Error updating context from delete:",error)
                }
            }
        } catch {
            print("Error fetching results: ",error)
        }
    }
    
    
    override func loadView() {
        super.loadView()
        SOTabBarSetting.tabBarAnimationDurationTime = 0.3
        SOTabBarSetting.tabBarTintColor = .white
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //MARK: Tab bar
        let firstVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        let secondVC = UIStoryboard(name: "Workouts", bundle: nil).instantiateViewController(withIdentifier: "Workouts")
        let thirdVC = UIStoryboard(name: "Progress", bundle: nil).instantiateViewController(withIdentifier: "Progress")
        let fourthVC = UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "Community")
           
        firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "icons8-home"), selectedImage: UIImage(named: "icons8-home"))
        secondVC.tabBarItem = UITabBarItem(title: "Workout", image: UIImage(named: "icons8-workouts"), selectedImage: UIImage(named: "icons8-workouts"))
        thirdVC.tabBarItem = UITabBarItem(title: "Progress", image: UIImage(named: "icons8-progress"), selectedImage: UIImage(named: "icons8-progress"))
        fourthVC.tabBarItem = UITabBarItem(title: "Community", image: UIImage(named: "icons8-community"), selectedImage: UIImage(named: "icons8-community"))
       
        
        viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
        
    }
    
}
