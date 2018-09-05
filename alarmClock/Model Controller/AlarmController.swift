//
//  AlarmController.swift
//  alarmClock
//
//  Created by Ivan Ramirez on 9/3/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation
import UserNotifications


class AlarmController: AlarmScheduler {
    
    //Singleton
    static let shared = AlarmController()
    
    
    
    // Source of Truth
    var alarms = [Alarm]()
    
    func createAlarm(alarmTitle: String, alarmTime: Date, isOn: Bool) {
        
        let alarm = Alarm(alarmTitle: alarmTitle, alarmTime: alarmTime)
        alarm.isOn = isOn
        AlarmController.shared.alarms.append(alarm)
        scheduleUserNotification(for: alarm)
        save()
    }
    
    func update(alarm: Alarm, alarmTitle: String, alarmTime: Date, isOn: Bool) {
        
        
        cancelUserNotfication(for: alarm)
        
        alarm.alarmTitle = alarmTitle
        alarm.alarmTime = alarmTime
        alarm.isOn = isOn
        
        scheduleUserNotification(for: alarm)
        save()
        
    }
    
    func toggledIsOn(for alarm: Alarm){
        alarm.isOn = !alarm.isOn  // on vs. off
        if alarm.isOn {
            scheduleUserNotification(for: alarm)
        } else {
            cancelUserNotfication(for: alarm)
        }
    }
    
    func delete(alarm: Alarm) {
        guard let index = alarms.index(of: alarm) else { return }
        self.cancelUserNotfication(for: alarm)
        alarms.remove(at: index)
        save()
    }
    
    
    func filePath() -> URL {
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let path = paths.first else { fatalError("bad Path")}
        let url = path.appendingPathComponent("alarm.json")
        return url
    }
    
    func load() -> [Alarm] {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: filePath())
            let alarms = try decoder.decode([Alarm].self, from: data)
            return alarms
        } catch let error {
            print("Error savng \(error) \(error.localizedDescription)")
        }
        return []
    }
    func save() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(alarms)
            try data.write(to: filePath())
        } catch let error {
            print("🔥 Error saving \(error) \(error.localizedDescription)")
        }
    }
}

protocol AlarmScheduler: class {
    func scheduleUserNotification(for alarm: Alarm)
    func cancelUserNotfication(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotification(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.body = "Your alarm named \(alarm.alarmTitle) is going off!"
        content.title = "time to get up"
        content.sound = UNNotificationSound.default()
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.alarmTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("💩 There was an error in \(#function) : (error) : \(error.localizedDescription) 💩")
            }
        }
    }

func cancelUserNotfication(for alarm: Alarm) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
}
}
