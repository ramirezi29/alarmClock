//
//  AlarmTableViewController.swift
//  alarmClock
//
//  Created by Ivan Ramirez on 9/3/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit



protocol AlarmTableViewCellDelegate: class {
    func alarmWasToggled(sender: AlarmTableViewCell)
}

class OtherDummyClass: AlarmTableViewCellDelegate{
    
    func alarmWasToggled(sender: AlarmTableViewCell) {
        print("This function does nothing. But guess what....  I still conform to the protocol")
    }
    
    
}

class AlarmTableViewController: UITableViewController, AlarmTableViewCellDelegate, AlarmScheduler {
    
    func alarmWasToggled(sender: AlarmTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let alarm = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.toggledIsOn(for: alarm)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
 
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellToVC", for: indexPath) as? AlarmTableViewCell
        // where were going to send the info
        let alarm = AlarmController.shared.alarms[indexPath.row]
        cell?.delegate = self
        cell?.alarm = alarm
        
        return cell ?? UITableViewCell() // either one or the other
    }
    
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }    
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let alarm = AlarmController.shared.alarms[indexPath.row]
            let destinationVC = segue.destination as? DetailTableViewController
            destinationVC?.alarm = alarm
        }
    }
    
}

extension AlarmTableViewController {
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
