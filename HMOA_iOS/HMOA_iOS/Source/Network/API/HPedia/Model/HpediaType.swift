//
//  HpediaType.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/23/23.
//

import Foundation

enum HpediaType {
    case term
    case note
    case perfumer
    case brand
}

extension HpediaType {
    
    var title: String {
        switch self {
        case .term:
            return "용어"
        case .note:
            return "노트"
        case .perfumer:
            return "조향사"
        case .brand:
            return "brand"
        }
    }
}
