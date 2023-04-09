//
//  HpediaGuideSection.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

import RxDataSources

struct HPediaGuideSection {
    var items: [Item]
    
    init(items: [HPediaGuideData]) {
        self.items = items
    }
}

extension HPediaGuideSection: SectionModelType {
    
    typealias Item = HPediaGuideData
    
    init(original: HPediaGuideSection, items: [Item]) {
        self = original
        self.items = items
    }
}