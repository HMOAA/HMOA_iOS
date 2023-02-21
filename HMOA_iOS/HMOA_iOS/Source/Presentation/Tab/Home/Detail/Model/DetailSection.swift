//
//  DetailSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit
import RxDataSources

enum DetailSection {
    case top(DetailSectionItem)
    case comment([DetailSectionItem])
    case recommend([DetailSectionItem])
}

enum DetailSectionItem {
    case topCell(PerfumeDetailReactor)
    case commentCell(Comment)
    case recommendCell(Perfume)
}

extension DetailSection: SectionModelType {
    typealias Item = DetailSectionItem
    
    var items: [Item] {
        switch self {
        case .top(let items):
            return [items]
        case .comment(let items):
            return items
        case .recommend(let items):
            return items
        }
    }
    
    init(original: DetailSection, items: [DetailSectionItem]) {
        switch original {
        case .top:
            self = .top(items.first!)
        case .comment:
            self = .comment(items)
        case .recommend:
            self = .recommend(items)
       
        }
    }
}
