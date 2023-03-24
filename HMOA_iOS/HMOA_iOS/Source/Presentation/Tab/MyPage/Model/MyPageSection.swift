//
//  MyPageSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/24.
//

import RxDataSources

enum MyPageSection {
    case first(MyPageSectionItem)
    case etc([MyPageSectionItem])
}

enum MyPageSectionItem {
    case userInfo(UserInfo)
    case etc(String)
}

extension MyPageSection: SectionModelType {

    typealias Item = MyPageSectionItem
    
    var items: [MyPageSectionItem] {
        switch self {
        case .first(let item):
            return [item]
        case .etc(let items):
            return items
        }
    }
    
    init(original: MyPageSection, items: [MyPageSectionItem]) {
        switch original {
        case .first:
            self = .first(items.first!)
        case .etc:
            self = .etc(items)
        }
    }
}
