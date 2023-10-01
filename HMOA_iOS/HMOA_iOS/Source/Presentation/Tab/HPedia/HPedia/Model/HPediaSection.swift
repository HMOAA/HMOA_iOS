//
//  HPediaTagSection.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

enum HPediaSection: Hashable {
    case dictionary
    case qna
}

enum HPediaSectionItem: Hashable {
    case dictionary(HPediaDictionaryData)
    case qna(CategoryList)
}

extension HPediaSectionItem {
    var id: Int {
        switch self {
        case .dictionary(let data):
            return data.id
        case .qna(let data):
            return 1
        }
    }
}

