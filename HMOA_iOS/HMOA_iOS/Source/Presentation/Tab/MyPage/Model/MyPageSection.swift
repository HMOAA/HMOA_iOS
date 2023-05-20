//
//  MyPageSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/24.
//

import RxDataSources

enum MyPageSection {
    case memberSection(MyPageSectionItem)
    case otherSection([MyPageSectionItem])
}

enum MyPageSectionItem {
    case memberCell(MemberCellReactor)
    case otherCell(String)
}

extension MyPageSection: SectionModelType {

    typealias Item = MyPageSectionItem
    
    var items: [MyPageSectionItem] {
        switch self {
        case .memberSection(let item):
            return [item]
        case .otherSection(let items):
            return items
        }
    }
    
    init(original: MyPageSection, items: [MyPageSectionItem]) {
        self = original
    }
}
