//
//  MyProfileSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/05.
//

import Foundation
import RxDataSources

enum MyProfileSection {
    case section([MyProfileItem])
}

enum MyProfileItem {
    case item(String)
}

extension MyProfileSection: SectionModelType {
    
    init(original: MyProfileSection, items: [MyProfileItem]) {
        self = original
    }
    
    var items: [MyProfileItem] {
        switch self {
        case .section(let items):
            return items
        }
    }
}

