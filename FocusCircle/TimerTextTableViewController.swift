//
//  TimerTextTableViewController.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/10.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

protocol NewTimerInfoBringBackProtocol: class {
    func addNewTimer(name: String?, durationTime: NSTimeInterval!)
}

class TimerTextTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    typealias BringDataBackHandler = ((name: String?, durationTime: NSTimeInterval?) -> Void)
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var durationTimePickerView: UIPickerView!
    
    weak var receiveNewInfoDelegate: NewTimerInfoBringBackProtocol?
    
    private var name: String?
    private var durationTime: NSTimeInterval = 0
    
    private var newName: String?
    private var newDurationTime: NSTimeInterval?
    private var bringDataBackHandler: BringDataBackHandler!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = oldName
        
        durationTimePickerView.dataSource = self
        durationTimePickerView.delegate = self
        
        durationTimePickerView.selectRow(0, inComponent: 0, animated: true)
        durationTimePickerView.selectRow(1, inComponent: 0, animated: true)
        durationTimePickerView.selectRow(2, inComponent: 0, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func editTimerInfo(timer: TimerInfo, completionHandler: BringDataBackHandler) {
        bringDataBackHandler = completionHandler
        
        if let name = timer.name {
            self.name = name
        }
        
        self.durationTime = timer.durationTime
    }
    
    //MARK: UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component{
        case 0:
            return 24
        case 1:
            return 60
        case 2:
            return 60
        default:
            return 0
        }
    }
    
    //MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) 小时"
        case 1:
            return "\(row) 分钟"
        case 2:
            return "\(row) 秒"
        default:
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            durationTime += row * 3600
        case 1:
            durationTime += row * 60
        case 2:
            durationTime += row
        default:
            durationTime += 0
        }
    }
    
    //MARK: Dismiss Text TableVC Actions
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        if let delegate = receiveNewInfoDelegate {
           delegate.addNewTimer(newName, durationTime: newDurationTime!)
        }else{
            self.bringDataBackHandler(name: newName, durationTime: newDurationTime)
        }
    }
}
