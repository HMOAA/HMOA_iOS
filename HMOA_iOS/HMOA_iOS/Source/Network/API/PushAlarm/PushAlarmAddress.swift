//
//  PushAlarmAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 12/14/23.
//

import Foundation

enum PushAlarmAddress {
    case postFcmToken
    case deleteFcmToken
    case fetchAlarmList
    case putReadAlarm(Int)
}

extension PushAlarmAddress {
    var url: String {
        switch self {
        case .postFcmToken:
            return "fcm/save"
        case .deleteFcmToken:
            return "fcm/delete"
        case .fetchAlarmList:
            return "fcm/list"
        case .putReadAlarm(let id):
            return "fcm/read/\(id)"
        }
    }
}
