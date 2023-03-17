//
//  ListSecton.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/17.
//

import Foundation
import RxDataSources


struct ListSection {
    var items: [Item]
    
    init(items: [ListData]) {
        self.items = items
    }
}

extension ListSection: SectionModelType {
    typealias Item = ListData
    
    init(original: ListSection, items: [Item]) {
        self = original
        self.items = items
    }
}
