//
//  CardSection.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/17.
//

import Foundation

enum CardSection: CaseIterable {
    case main
}

struct CardSectionItem: Hashable {
    let id: Int
    let brandName: String
    let korPerpumeName: String
    let engPerpumeName: String
    let price: Int
}
