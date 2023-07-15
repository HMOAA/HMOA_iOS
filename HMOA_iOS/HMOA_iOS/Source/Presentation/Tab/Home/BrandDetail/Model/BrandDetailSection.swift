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

extension BrandDetailSection: Hashable {

    
    typealias Item = BrandDetailSectionItem
    
    var items: [Item] {
        switch self {
        case .first(let items):
            return items
        }
    }
}

extension BrandDetailSectionItem: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .perfumeList(let perfume):
            hasher.combine(perfume)
        }
    }
}
