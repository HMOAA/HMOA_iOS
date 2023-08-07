//
//  MyProfileSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/05.
//

import Foundation

enum MyProfileSection {
    case section([MyProfileItem])
}

enum MyProfileItem: Hashable {
    case item(String)
}

extension MyProfileSection: Hashable {
    
    
    var items: [MyProfileItem] {
        switch self {
        case .section(let items):
            return items
        }
    }
}

