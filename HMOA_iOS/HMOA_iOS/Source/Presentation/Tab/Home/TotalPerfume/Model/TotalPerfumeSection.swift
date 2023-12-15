//
//  TotalPerfumeSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/28.
//

import Foundation

enum TotalPerfumeSection{
    case first([TotalPerfumeSectionItem])
}

enum TotalPerfumeSectionItem {
    case perfumeList(RecommendPerfume)
}

extension TotalPerfumeSectionItem: Hashable {
    
    var perfume: RecommendPerfume {
        switch self {
        case .perfumeList(let perfume):
            return perfume
        }
    }
}

extension TotalPerfumeSection: Hashable {
    var items: [TotalPerfumeSectionItem] {
        switch self {
        case .first(let item):
            return item
        }
    }
}
