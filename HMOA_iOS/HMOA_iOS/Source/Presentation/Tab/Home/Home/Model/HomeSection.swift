//
//  HomeSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/20.
//

import UIKit

enum HomeSection: Hashable {
    case topSection([HomeSectionItem])
    case recommendSection(header: String, items: [HomeSectionItem])
}

enum HomeSectionItem: Hashable {
    case topCell(String, Int)
    case recommendCell(RecommendPerfume ,Int, UUID)
}

extension HomeSection {
    
    var items: [HomeSectionItem] {
            switch self {
            case .topSection(let items):
                return items
            case .recommendSection(_, let items):
                return items
            }
        }
}

extension HomeSectionItem {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .topCell(let string, let int):
            hasher.combine(string)
            hasher.combine(int)
        case .recommendCell(let perfume, let int, let uid):
            hasher.combine(perfume)
            hasher.combine(int)
            hasher.combine(uid)
        }
    }
    
    static func ==(lhs: HomeSectionItem, rhs: HomeSectionItem) -> Bool {
        switch (lhs, rhs) {
        case (.topCell(let lhsString, let lhsInt),
              .topCell(let rhsString, let rhsInt)):
            return lhsString == rhsString && lhsInt == rhsInt
        case (.recommendCell(let lhsPerfume, let lhsInt, let lhsUuid),
              .recommendCell(let rhsPerfume, let rhsInt, let rhsUuid)):
            return lhsPerfume == rhsPerfume && lhsInt == rhsInt && lhsUuid == rhsUuid
        default:
            return false
        }
    }
    
    var perfumeId: Int {
            switch self {
            case .topCell(_, let perfumeId):
                return perfumeId
            case .recommendCell(_, let perfumeId, _):
                return perfumeId
            }
        }
}
