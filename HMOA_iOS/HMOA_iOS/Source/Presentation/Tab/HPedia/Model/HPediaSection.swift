//
//  HPediaTagSection.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

enum HPediaSection: Hashable {
    case guide
    case tag
}

enum HPediaSectionItem {
    case guideCell(HPediaGuideData)
    case tagCell(HPediaTagData)
}


extension HPediaSectionItem: Hashable {
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .guideCell(let guideData):
            hasher.combine(guideData)
        case .tagCell(let tagData):
            hasher.combine(tagData)
        }
    }
    
    static func ==(lhs: HPediaSectionItem, rhs: HPediaSectionItem) -> Bool {
        switch (lhs, rhs) {
        case (.guideCell(let lhsGuideData), .guideCell(let rhsGuideData)):
            return lhsGuideData == rhsGuideData
        case (.tagCell(let lhsTagData), .tagCell(let rhsTagData)):
            return lhsTagData == rhsTagData
        default:
            return false
        }
    }
}
