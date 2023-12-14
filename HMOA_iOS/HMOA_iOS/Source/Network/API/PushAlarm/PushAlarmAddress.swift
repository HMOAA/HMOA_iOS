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
}

extension PushAlarmAddress {
    var url: String {
        switch self {
        case .postFcmToken:
            return "fcm/save"
        case .deleteFcmToken:
            return "fcm/delete"
        }
    }
}
