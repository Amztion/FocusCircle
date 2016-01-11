//
//  TimerTextTableViewController.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/10.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit
struct TimeComponent {
    var hour = 0.0
    var minute = 0.0
    var second = 0.0
    
    func convertToSeconds() -> NSTimeInterval {
        return hour * 3600.0 + minute * 60.0 + second
    }
}

class TimerTextTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    private enum OperationType {
        case Adding
        case Editing
    }
    
    typealias BringDataBackHandler = ((name: String?, durationTime: NSTimeInterval?) -> Void)
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var durationTimePickerView: UIPickerView!
    
    private var operationType: OperationType!
    private var bringDataBackHandler: BringDataBackHandler!
    
    private var name: String = ""
    private var durationTime: NSTimeInterval = 0
    
    private var durationTimeComponent = TimeComponent()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = name
        nameTextField.delegate = self
        
        durationTimePickerView.dataSource = self
        durationTimePickerView.delegate = self
        
        if durationTime != 0 {
            durationTimeComponent = durationTime.convertIntoTimeComponent()
            
            durationTimePickerView.selectRow(Int(durationTimeComponent.hour), inComponent: 0, animated: false)
            durationTimePickerView.selectRow(Int(durationTimeComponent.minute), inComponent: 1, animated: false)
            durationTimePickerView.selectRow(Int(durationTimeComponent.second), inComponent: 2, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func editTimerWithTimerInfo(timer: TimerInfo, completionHandler: BringDataBackHandler) {
        bringDataBackHandler = completionHandler
        operationType = OperationType.Editing
        
        name = timer.name
        durationTime = timer.durationTime
    }
    
    func addTimerWithCompletionHandler(completionHandler: BringDataBackHandler) {
        bringDataBackHandler = completionHandler
        operationType = OperationType.Adding
    }
    
    //MARK: Dismiss Text TableVC Actions
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        let newDurationTime = durationTimeComponent.convertToSeconds()
        let newName = nameTextField.text!
        
        if newDurationTime == 0 {
            self.presentViewController(UIAlertController.oneButtonAlertController("出现错误", message: "时间不能为 0", preferredStryle: UIAlertControllerStyle.Alert), animated: true, completion: nil)
            
            return
        }
        
        if newName == "" {
            self.presentViewController(UIAlertController.oneButtonAlertController("出现错误", message: "项目名称不能为空", preferredStryle: UIAlertControllerStyle.Alert), animated: true, completion: nil)
        
            return
        }
        
        if operationType == OperationType.Adding {
            self.bringDataBackHandler(name: newName, durationTime: newDurationTime)
        }else{
            
            if newName == name && newDurationTime == durationTime {
               self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            self.bringDataBackHandler(name: newName, durationTime: newDurationTime)
        }
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
            durationTimeComponent.hour = Double(row)
        case 1:
            durationTimeComponent.minute = Double(row)
        case 2:
            durationTimeComponent.second = Double(row)
        default:
            durationTimeComponent.second += 0
        }
    }
}
