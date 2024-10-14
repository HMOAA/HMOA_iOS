//
//  OrderCancelLogSection.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/25/24.
//

import Foundation

enum OrderCancelLogSection: Hashable {
    case cancel
}

enum OrderCancelLogItem: Hashable {
    case order(Order)
}

extension OrderCancelLogItem {
    var order: Order? {
        if case .order(let order) = self {
            return order
        } else {
            return nil
        }
    }
}
