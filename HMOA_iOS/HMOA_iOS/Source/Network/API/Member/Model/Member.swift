//
//  Member.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/04.
//

import Foundation

struct Member: Codable {
    let age: Int
    let email: String
    let imgUrl: String?
    let memberId: Int
    let nickname: String
    let sex: String
}
