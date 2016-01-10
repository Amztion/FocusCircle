//
//  TimerViewController.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/9.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TimerUIUpdateProtocol {
    
    let timerController: TimerController = TimerController.sharedController

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerController.timerUpdateDelegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: TimerUIUpdateProtocol
    func updateRemaingTimeUIAtIndex(index: Int) {
        
    }
    
    func updateTimerStateUIAtIndex(index: Int) {
        
    }
    
    //MARK: TableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerController.numberOfTimers()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let timerInfo = timerController.timerInfoAtIndex(indexPath.row)
        
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("TimerCell", forIndexPath: indexPath)
        tableViewCell.textLabel!.text = timerInfo!.name
        
        return tableViewCell
    }
    
    //MARK: TableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var actionsArray = [UITableViewRowAction]()
        
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "编辑") { (editRowAction, indexPath) -> Void in
            let timerInfo = self.timerController.timerInfoAtIndex(indexPath.row)!
            
            if let timerTextNav = self.storyboard?.instantiateViewControllerWithIdentifier("TimerTextNav") as? UINavigationController {
                
                let timerTextTableVC = timerTextNav.viewControllers.first! as! TimerTextTableViewController
                
                timerTextTableVC.editTimerWithTimerInfo(timerInfo, completionHandler: { (name, durationTime) -> Void in
                    
                    if let newName = name {
                        self.timerController.renameTimerAtIndex(indexPath.row, name: newName)
                    }
                    
                    if let newDurationTime = durationTime {
                        self.timerController.modifyTimerAtIndex(indexPath.row, durationTime: newDurationTime)
                    }
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                
                self.presentViewController(timerTextNav, animated: true, completion: nil)
            }
        }
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "删除") { (tableViewRowAction, indexPath) -> Void in
            
            self.timerController.deleteTimerAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
        actionsArray.append(editRowAction)
        actionsArray.append(deleteRowAction)
        
        return actionsArray
        
    }
    
    //MARK: Prepare For Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let timerTextNavVC = segue.destinationViewController as? UINavigationController{
            let timerTextTableVC = timerTextNavVC.viewControllers[0] as? TimerTextTableViewController
            timerTextTableVC?.addTimerWithCompletionHandler({ (name, durationTime) -> Void in
                self.timerController.addNewTimerName(name!, durationTime: durationTime!)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
        }
    }
    
}
