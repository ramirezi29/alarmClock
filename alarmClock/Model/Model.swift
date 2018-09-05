//
//  Model.swift
//  alarmClock
//
//  Created by Ivan Ramirez on 9/3/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation

class Alarm: Equatable, Codable {
    
    init(alarmTitle: String, alarmTime: Date, isOn: Bool = true, uuid: String = UUID().uuidString) {
        self.alarmTime = alarmTime
        self.isOn = isOn
        self.alarmTitle = alarmTitle
        self.uuid = uuid
        
    }
    
    var alarmTime: Date
    var alarmTitle: String
    var isOn: Bool
    let uuid: String
    
    var alarmString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: alarmTime)
    }
}

func ==(lhs:Alarm, rhs: Alarm) -> Bool {
    return lhs.uuid == rhs.uuid
}
