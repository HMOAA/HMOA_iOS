//
//  HPediaTagSection.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

import RxDataSources

enum HPediaSection {
    case guide([HPediaSectionItem])
    case tag([HPediaSectionItem])
}

enum HPediaSectionItem {
    case guideCell(HPediaGuideCellReactor, Int)
    case tagCell(HPediaTagCellReactor, Int)
}

extension HPediaSection: SectionModelType {
    typealias Item = HPediaSectionItem
    
    var items: [Item] {
        switch self {
        case.tag(let items):
            return items
        case .guide(let items):
            return items
        }
    }
    
    init(original: HPediaSection, items: [HPediaSectionItem]) {
        switch original {
        case .guide(let items):
            self = .guide(items)
        case .tag(let items):
            self = .tag(items)
        }
        
    }
}
