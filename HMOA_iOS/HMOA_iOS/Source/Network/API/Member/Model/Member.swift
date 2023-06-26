//
//  Member.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/04.
//

import Foundation

struct Member: Codable {
    var age: Int
    var memberImageUrl: String
    var memberId: Int
    var nickname: String
    var provider: String
    var sex: Bool
}
