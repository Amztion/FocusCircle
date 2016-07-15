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
    
    func convertToSeconds() -> TimeInterval {
        return hour * 3600.0 + minute * 60.0 + second
    }
}

class TimerTextTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    private enum OperationType {
        case adding
        case editing
    }
    
    typealias BringDataBackHandler = ((name: String?, durationTime: TimeInterval?) -> Void)
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var durationTimePickerView: UIPickerView!
    
    private var operationType: OperationType!
    private var bringDataBackHandler: BringDataBackHandler!
    
    private var name: String!
    private var durationTime: TimeInterval!
    
    private var durationTimeComponent = TimeComponent()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = name
        nameTextField.delegate = self
        
        durationTimePickerView.dataSource = self
        durationTimePickerView.delegate = self
        
        if operationType == OperationType.editing {
            durationTimeComponent = durationTime.convertIntoTimeComponent()
            
            durationTimePickerView.selectRow(Int(durationTimeComponent.hour), inComponent: 0, animated: false)
            durationTimePickerView.selectRow(Int(durationTimeComponent.minute), inComponent: 1, animated: false)
            durationTimePickerView.selectRow(Int(durationTimeComponent.second), inComponent: 2, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func editTimerWithTimerInfo(_ timer: TimerInfo, completionHandler: BringDataBackHandler) {
        bringDataBackHandler = completionHandler
        operationType = OperationType.editing
        
        name = timer.name
        durationTime = timer.durationTime
    }
    
    func addTimerWithCompletionHandler(_ completionHandler: BringDataBackHandler) {
        bringDataBackHandler = completionHandler
        operationType = OperationType.adding
    }
    
    //MARK: Dismiss Text TableVC Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        let newDurationTime = durationTimeComponent.convertToSeconds()
        let newName = nameTextField.text!
        
        if newDurationTime == 0 {
            self.present(UIAlertController.oneButtonAlertController("出现错误", message: "时间不能为 0", preferredStryle: UIAlertControllerStyle.alert), animated: true, completion: nil)
            
            return
        }
        
        if newName == "" {
            self.present(UIAlertController.oneButtonAlertController("出现错误", message: "项目名称不能为空", preferredStryle: UIAlertControllerStyle.alert), animated: true, completion: nil)
        
            return
        }
        
        if operationType == OperationType.adding {
            self.bringDataBackHandler(name: newName, durationTime: newDurationTime)
        }else{
            switch true {
            case newName == name && newDurationTime == durationTime:
                self.presentingViewController?.dismiss(animated: true, completion: nil)
                return
            case newName != name && newDurationTime != durationTime:
                self.bringDataBackHandler(name: newName, durationTime: newDurationTime)
                return
            case newName == name && newDurationTime != durationTime:
                self.bringDataBackHandler(name: nil, durationTime: newDurationTime)
                return
            case newName != name && newDurationTime == durationTime:
                self.bringDataBackHandler(name: newName, durationTime: nil)
                return
            default:
                return
            }
            
        }
    }
    
    //MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
