//
//  TotalPerfumeSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/28.
//

import Foundation

enum TotalPerfumeSection: Hashable {
    case first([TotalPerfumeSectionItem])
}

enum TotalPerfumeSectionItem {
    case perfumeList(Perfume)
}

extension TotalPerfumeSectionItem: Hashable {
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .perfumeList(let perpume):
            hasher.combine(perpume)
        }
    }
    
    var perfume: Perfume {
        switch self {
        case .perfumeList(let perfume):
            return perfume
        }
    }
}
//
//extension TotalPerfumeSection: SectionModelType {
//    typealias Item = TotalPerfumeSectionItem
//
//
//    var items: [Item] {
//        switch self {
//        case .first(let items):
//            return items
//        }
//    }
//
//    init(original: TotalPerfumeSection, items: [Item]) {
//        switch original {
//        case .first:
//            self = .first(items)
//        }
//    }
//}
