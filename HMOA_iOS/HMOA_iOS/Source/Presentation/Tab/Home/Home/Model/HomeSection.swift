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
    
    var perfumeId: Int {
            switch self {
            case .topCell(_, let perfumeId):
                return perfumeId
            case .recommendCell(_, let perfumeId, _):
                return perfumeId
            }
        }
    
    var perfumeImage: String {
        switch self {
        case .recommendCell(let perfume, _, _):
            return perfume.imageUrl
        default: return ""
        }
    }
}
