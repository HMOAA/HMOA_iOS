//
//  TotalPerfumeSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/28.
//

import Foundation
import RxDataSources

enum TotalPerfumeSection {
    case first([TotalPerfumeSectionItem])
}

enum TotalPerfumeSectionItem {
    case perfumeList(Perfume)
}

extension TotalPerfumeSection: SectionModelType {
    typealias Item = TotalPerfumeSectionItem
    
    
    var items: [Item] {
        switch self {
        case .first(let items):
            return items
        }
    }
    
    init(original: TotalPerfumeSection, items: [Item]) {
        switch original {
        case .first:
            self = .first(items)
        }
    }
}
