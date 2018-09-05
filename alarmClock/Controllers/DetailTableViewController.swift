//
//  DetailTableViewController.swift
//  alarmClock
//
//  Created by Ivan Ramirez on 9/3/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController, AlarmScheduler {
    

    var alarm: Alarm? {
        didSet{
            loadViewIfNeeded()
            self.updateViews()
        }
    }
    var alarmisOn: Bool = true
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var alarmEnableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupBackground()
    }
    
    func updateViews() {
        guard let alarm = alarm else {return }
        alarmisOn = alarm.isOn
        datePicker.date = alarm.alarmTime
        titleTextField.text = alarm.alarmTitle
        setUpAlarmButton()
    }
    
    func setUpAlarmButton() {
        switch alarmisOn {
        case true:
            alarmEnableButton.backgroundColor = UIColor.cyan
            alarmEnableButton.setTitle("On", for: .normal)
        case false:
            alarmEnableButton.backgroundColor = UIColor.gray
            alarmEnableButton.setTitle("Off", for: .normal)
        }
    }
    
    @IBAction func alarmEnableButton(_ sender: Any) {
        if let alarm = alarm {
            AlarmController.shared.toggledIsOn(for: alarm)
            alarmisOn = alarm.isOn
        } else {
            alarmisOn = !alarmisOn
        }
        setUpAlarmButton()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text else {return}
        guard title != "" else {return}
        
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, alarmTitle: title, alarmTime: datePicker.date, isOn: alarmisOn)
            
        } else{
            AlarmController.shared.createAlarm(alarmTitle: title, alarmTime: datePicker.date, isOn: alarmisOn)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailTableViewController {
    func setupBackground() {
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "waterBlue"))
        tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        
        // Make a blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        imageView.clipsToBounds = true
    }
}
