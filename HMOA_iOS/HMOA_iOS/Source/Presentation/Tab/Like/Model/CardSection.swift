//
//  CardSection.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/17.
//

import Foundation
import RxDataSources


struct CardSection {
    var items: [Item]
    
    init(items: [CardData]) {
        self.items = items
    }
}

extension CardSection: SectionModelType {
    typealias Item = CardData
    
    init(original: CardSection, items: [Item]) {
        self = original
        self.items = items
    }
}
