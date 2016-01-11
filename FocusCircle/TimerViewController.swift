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
    func updateRemainingTimeUIAtIndex(index: Int, newRemainingTime: NSTimeInterval) {
        if let tableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) {
        }
    }
    
    func updateTimerInfoUIAtIndex(index: Int, newName: String?, newDurationTime: NSTimeInterval?) {
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? TimerTableViewCell {
            if let name = newName {
                cell.nameLabel.text = name
            }
            
            if let durationTime = newDurationTime {
                cell.durationTimeLabel.text = String(seconds: durationTime)
            }
        }
    }
    
    func updateTimerStateUIAtIndex(index: Int, newState: TimerState) {
        if let tableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) {
        }
    }
    
    //MARK: TableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerController.numberOfTimers()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let timerInfo = timerController.timerInfoAtIndex(indexPath.row) {
            let cell = tableView.dequeueReusableCellWithIdentifier("TimerCell", forIndexPath: indexPath) as! TimerTableViewCell
            cell.nameLabel.text = timerInfo.name
            cell.durationTimeLabel.text = String(seconds: timerInfo.durationTime)
            
            return cell
        }else{
            return UITableViewCell()
        }
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
                        self.timerController.renameTimerAtIndex(indexPath.row, newName: newName)
                    }
                    
                    if let newDurationTime = durationTime {
                        self.timerController.modifyTimerAtIndex(indexPath.row, newDurationTime: newDurationTime)
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    
    //MARK: Prepare For Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let timerTextNavVC = segue.destinationViewController as? UINavigationController{
            let timerTextTableVC = timerTextNavVC.viewControllers[0] as? TimerTextTableViewController
            timerTextTableVC?.addTimerWithCompletionHandler({ (name, durationTime) -> Void in
                self.timerController.addNewTimerWithName(name!, durationTime: durationTime!)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
        }
    }
    
}
