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
    case order(Order)
}

extension OrderLogItem {
    var order: Order? {
        if case .order(let order) = self {
            return order
        } else {
            return nil
        }
    }
}
