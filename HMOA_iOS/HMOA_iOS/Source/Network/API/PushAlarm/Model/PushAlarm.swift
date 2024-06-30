//
//  PushAlarm.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 6/27/24.
//

import Foundation

struct PushAlarm: Codable, Hashable {
    let ID: Int
    let category: String
    let content: String
    let pushDate: String
    let deepLink: String
    let isRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case category = "title"
        case content
        case pushDate = "createdAt"
        case deepLink
        case isRead = "read"
    }
}
