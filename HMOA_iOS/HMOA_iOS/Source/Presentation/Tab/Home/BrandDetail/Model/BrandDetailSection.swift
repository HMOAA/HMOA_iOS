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

enum BrandDetailSectionItem: Hashable {
    case perfumeList(BrandPerfume)
}

extension BrandDetailSection: Hashable {

    
    typealias Item = BrandDetailSectionItem
    
    var items: [Item] {
        switch self {
        case .first(let items):
            return items
        }
    }
}

extension BrandDetailSectionItem {
    var perfumeId: Int {
        switch self {
        case .perfumeList(let perfume):
            return perfume.perfumeId
        }
    }
}
