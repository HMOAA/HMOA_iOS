//
//  PushAlarm.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 6/27/24.
//

import Foundation

struct PushAlarmResponse: Hashable, Codable {
    let data: [PushAlarm]
}

struct PushAlarm: Codable, Hashable {
    let ID: Int
    let senderProfileImage: String
    let category: String
    let content: String
    let pushDate: String
    let deeplink: String
    let isRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case senderProfileImage = "senderProfileImg"
        case category = "title"
        case content
        case pushDate = "createdAt"
        case deeplink
        case isRead = "read"
    }
}
