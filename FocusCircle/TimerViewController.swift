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
        
        timerController.addUIUpdateDelegate(self)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: TimerUIUpdateProtocol
    func updateRemainTime(at index: Int, newRemainingTime: TimeInterval) {
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TimerTableViewCell {
            cell.durationTimeLabel.text = String(seconds: newRemainingTime)
        }
    }
    
    func updateTimer(name newName: String?, durationTime newDurationTime: TimeInterval?, at index: Int) {
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TimerTableViewCell {
            if let name = newName {
                cell.nameLabel.text = name
            }
            
            if let durationTime = newDurationTime {
                cell.durationTimeLabel.text = String(seconds: durationTime)
            }
        }
    }
    
    func updateTimer(state newState:TimerState, at index: Int) {
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TimerTableViewCell{
            cell.controlButton.changeButtonToState(newState)
            tableView.isEditing = false
        }
    }
    
    //MARK: Control Button Operation
    @IBAction func controlButtonTapped(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                if let timerInfo = timerController.timerInfoAtIndex((indexPath as NSIndexPath).row){
                    switch timerInfo.state {
                    case TimerState.stopped, TimerState.paused:
                        timerController.startTimerAtIndex((indexPath as NSIndexPath).row)
                    case TimerState.running:
                        timerController.pauseTimerAtIndex((indexPath as NSIndexPath).row)
                    }
                }
            }
        }
    }
    
    //MARK: TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerController.numberOfTimers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let timerInfo = timerController.timerInfoAtIndex((indexPath as NSIndexPath).row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimerCell", for: indexPath) as! TimerTableViewCell
            cell.nameLabel.text = timerInfo.name
            cell.durationTimeLabel.text = String(seconds: timerInfo.durationTime)
            cell.controlButton.changeButtonToState(timerInfo.state)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    //MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actionsArray = [UITableViewRowAction]()
        let timerInfo = timerController.timerInfoAtIndex((indexPath as NSIndexPath).row)!
        
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "编辑") { (editRowAction, indexPath) -> Void in
            let timerInfo = self.timerController.timerInfoAtIndex((indexPath as NSIndexPath).row)!
            
            if let timerTextNav = self.storyboard?.instantiateViewController(withIdentifier: "TimerTextNav") as? UINavigationController {
                
                let timerTextTableVC = timerTextNav.viewControllers.first! as! TimerTextTableViewController
                
                timerTextTableVC.editTimerWithTimerInfo(timerInfo, completionHandler: { [weak self] (name, durationTime) -> Void in
                    
                    if let newName = name {
                        self?.timerController.renameTimerAtIndex((indexPath as NSIndexPath).row, newName: newName)
                    }
                    
                    if let newDurationTime = durationTime {
                        self?.timerController.modifyTimerAtIndex((indexPath as NSIndexPath).row, newDurationTime: newDurationTime)
                    }
                    
                    self?.dismiss(animated: true, completion: nil)
                })
                self.present(timerTextNav, animated: true, completion: nil)
            }
            self.tableView.isEditing = false
        }
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "删除") { (tableViewRowAction, indexPath) -> Void in
            
            self.timerController.deleteTimerAtIndex((indexPath as NSIndexPath).row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            self.tableView.isEditing = false
        }
        
        let resetRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "重置") { (tableViewRowAction, indexPath) -> Void in
            
            self.timerController.resetTimerAtIndex((indexPath as NSIndexPath).row)
            self.tableView.isEditing = false
        }
        
        switch timerInfo.state {
        case .running:
            actionsArray.append(resetRowAction)
        case .paused:
            actionsArray.append(deleteRowAction)
            actionsArray.append(resetRowAction)
        case .stopped:
            actionsArray.append(deleteRowAction)
            actionsArray.append(editRowAction)
        }
        
        return actionsArray
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    //MARK: Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let timerTextNavVC = segue.destinationViewController as? UINavigationController{
            let timerTextTableVC = timerTextNavVC.viewControllers[0] as? TimerTextTableViewController
            timerTextTableVC?.addTimerWithCompletionHandler({ [weak self] (name, durationTime) -> Void in
                self?.timerController.addNewTimerWithName(name!, durationTime: durationTime!)
                self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
                self?.dismiss(animated: true, completion: nil)
            })
            
        }
    }
    
}
