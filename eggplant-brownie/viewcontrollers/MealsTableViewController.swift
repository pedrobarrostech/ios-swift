//
//  MealsTableTableViewController.swift
//  eggplant-brownie
//
//  Copyright (c) 2014 alura. All rights reserved.
//

import UIKit

class MealsTableViewController: UITableViewController, AddAMealDelegate {

    var meals = Array<Meal>()

    func add(meal: Meal) {
        meals.append(meal)
        let dir = getUserDir()
        let archive =  "\(dir)/eggplant-brownie-meals"
        NSKeyedArchiver.archiveRootObject(meals, toFile: archive)
        tableView.reloadData()
    }
    func getUserDir() -> String {
        let userDir = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask,
            true)
        return userDir[ 0 ] as String
    }
    override func viewDidLoad() {
        let dir = getUserDir()
        let archive =  "\(dir)/eggplant-brownie-meals"
        if let loaded = NSKeyedUnarchiver.unarchiveObjectWithFile(archive) {
            self.meals = loaded as Array
        }
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return meals.count
    }

    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let row = indexPath.row
            let meal = meals[ row ]
            
            var cell = UITableViewCell(style: UITableViewCellStyle.Default,
                reuseIdentifier: nil)
            cell.textLabel.text = meal.name
            let longPress = UILongPressGestureRecognizer(target: self, action: Selector("showDetails:"))
            cell.addGestureRecognizer(longPress)
            return cell
    }
    
    func showDetails(recognizer: UILongPressGestureRecognizer){
        if recognizer.state == UIGestureRecognizerState.Began {
            let cell = recognizer.view as UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            if indexPath == nil {
                return
            }
            let row = indexPath!.row
            let meal = meals[ row ]
            
            RemoveMealController(controller: self).show(meal, { action in
                self.meals.removeAtIndex(row)
                self.tableView.reloadData()
            })
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "addMeal") {
            let view = segue.destinationViewController as ViewController
            view.delegate = self
        }
    }

}
