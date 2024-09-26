//
//  OrderLogSection.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/25/24.
//

import Foundation

enum OrderLogSection: Hashable {
    case order
}

enum OrderLogItem: Hashable {
    // TODO: String -> Networking Model로 교체
    case order(String)
}

extension OrderLogItem {
    var order: String? {
        if case .order(let order) = self {
            return order
        } else {
            return nil
        }
    }
}
