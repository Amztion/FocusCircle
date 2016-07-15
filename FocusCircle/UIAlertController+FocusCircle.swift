//
//  UIAlertController+FocusCircle.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/10.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func oneButtonAlertController(_ title: String?, message: String?, preferredStryle: UIAlertControllerStyle, buttonTitle: String = "好的") -> UIAlertController{
        let oneButtonAlertController = UIAlertController(title: title, message: message, preferredStyle: preferredStryle)
        let buttonAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil)
        oneButtonAlertController.addAction(buttonAction)
        return oneButtonAlertController
    }
}
