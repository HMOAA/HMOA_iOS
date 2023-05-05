//
//  MyProfileSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/05.
//

import Foundation
import RxDataSources

enum MyProfileSection {
    case nickname([MyProfileItem])
    case year([MyProfileItem])
    case sex([MyProfileItem])
}

enum MyProfileItem {
    case nickname(String)
    case year(String)
    case sex(String)
}

extension MyProfileSection: SectionModelType {
    
    init(original: MyProfileSection, items: [MyProfileItem]) {
        switch original {
        case .nickname:
            self = .nickname(items)
        case .year:
            self = .year(items)
        case .sex:
            self = .sex(items)
        }
    }
    
    var items: [MyProfileItem] {
        switch self {
        case .nickname(let items):
            return items
        case .year(let items):
            return items
        case .sex(let items):
            return items
        }
    }
}

