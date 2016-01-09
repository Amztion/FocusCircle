//
//  TimerViewController.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/9.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //TableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimerController.sharedController.numbersOfTimers()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let timerModel: TimerModel? = TimerController.sharedController.timerModelAtIndex(indexPath.row)

        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("TimerCell", forIndexPath: indexPath)
    
        tableViewCell.textLabel!.text = timerModel!.name
        
        return tableViewCell
    }
}
