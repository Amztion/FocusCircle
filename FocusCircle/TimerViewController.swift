//
//  TimerViewController.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/9.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TimerUpdateProtocol {
    
    let timerController: TimerController = TimerController.sharedController

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerController.viewControllerDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: TimerUpdateProtocol
    func updateTimerUIAtIndex(index: Int) {
        let tabViewCell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: index, inSection: 0))
        
        tabViewCell?.textLabel?.text = "test"
    }
    
    //MARK: TableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerController.numbersOfTimers()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let timerModel: TimerModel? = timerController.timerModelAtIndex(indexPath.row)

        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("TimerCell", forIndexPath: indexPath)
        tableViewCell.textLabel!.text = timerModel!.name
        return tableViewCell
    }
    
    //MARK: TableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
