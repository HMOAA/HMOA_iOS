//
//  LiekModel.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/17.
//

import Foundation

struct CardData {
    let id: Int
    let brandName: String
    let korPerpumeName: String
    let engPerpumeName: String
    let price: Int
}


extension CardData {
    static let items: [CardData] = [
        CardData(id: 1,
                 brandName: "조말론 런던",
                 korPerpumeName: "무드 세이지 앤 씨 솔트 코롱",
                 engPerpumeName: "Wood Sage & Sea Salt Cologne",
                 price: 218000),
        CardData(id: 2,
                 brandName: "조말론 런던",
                 korPerpumeName: "무드 세이지 앤 씨 솔트 코롱",
                 engPerpumeName: "Wood Sage & Sea Salt Cologne",
                 price: 228000),
        CardData(id: 3,
                 brandName: "조말론 런던",
                 korPerpumeName: "무드 세이지 앤 씨 솔트 코롱",
                 engPerpumeName: "Wood Sage & Sea Salt Cologne",
                 price: 238000),
        CardData(id: 4,
                 brandName: "조말론 런던",
                 korPerpumeName: "무드 세이지 앤 씨 솔트 코롱",
                 engPerpumeName: "Wood Sage & Sea Salt Cologne",
                 price: 248000),
        CardData(id: 5,
                 brandName: "조말론 런던",
                 korPerpumeName: "무드 세이지 앤 씨 솔트 코롱",
                 engPerpumeName: "Wood Sage & Sea Salt Cologne",
                 price: 218000)
        ]
}
