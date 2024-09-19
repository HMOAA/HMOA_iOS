//
//  HBTIPerfumeResultSection.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/8/24.
//

import Foundation

enum HBTIPerfumeResultSection: Hashable {
    case perfume
}

enum HBTIPerfumeResultItem: Hashable {
    case perfume(HBTIPerfume)
}

extension HBTIPerfumeResultItem {
    var perfume: HBTIPerfume? {
        if case .perfume(let perfume) = self {
            return perfume
        } else {
            return nil
        }
    }
}
