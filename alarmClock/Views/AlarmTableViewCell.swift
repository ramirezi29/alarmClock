//
//  AlarmTableViewCell.swift
//  alarmClock
//
//  Created by Ivan Ramirez on 9/3/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit



class AlarmTableViewCell: UITableViewCell {
    
    /// landing Pad
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: AlarmTableViewCellDelegate?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func updateViews() {
        guard let alarm = alarm else { return }
        timeLabel.text = alarm.alarmTitle
        titleLabel.text = alarm.alarmTitle
        toggleSwitch.isOn = alarm.isOn
    }
    
    @IBAction func switchToggled(_ sender: Any) {
        delegate?.alarmWasToggled(sender: self)
    }
    
}
