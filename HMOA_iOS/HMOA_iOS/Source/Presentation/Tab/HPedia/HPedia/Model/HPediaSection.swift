//
//  HPediaTagSection.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

enum HPediaSection: Hashable {
    case dictionary
    case community
}

enum HPediaSectionItem: Hashable {
    case dictionary(HPediaDictionaryData)
    case community(CategoryList)
}
