//
//  PushAlarmSection.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 6/27/24.
//

import Foundation

enum PushAlarmSection: Hashable {
    case list
}

enum PushAlarmItem: Hashable {
    case pushAlarm(PushAlarm)
}

extension PushAlarmItem {
    var pushAlarm: PushAlarm? {
        if case .pushAlarm(let pushAlarm) = self {
            return pushAlarm
        } else {
            return nil
        }
    }
}
