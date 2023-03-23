//
//  BrandDetailSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import UIKit
import RxDataSources


enum BrandDetailSection {
    case first([BrandDetailSectionItem])
}

enum BrandDetailSectionItem {
    case perfumeList(Perfume)
}

extension BrandDetailSection: SectionModelType {

    
    typealias Item = BrandDetailSectionItem
    
    var items: [Item] {
        switch self {
        case .first(let items):
            return items
        }
    }
    
    init(original: BrandDetailSection, items: [BrandDetailSectionItem]) {
        switch original {
        case .first:
            self = .first(items)
        }
    }
}
