//
//  TimerTableViewCell.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/10.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

class TimerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var controlButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}
