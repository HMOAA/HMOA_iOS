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
    // TODO: Networking Model 정의 후 String에서 교체
    case order(String)
}

extension OrderCancelLogItem {
    var order: String? {
        if case .order(let order) = self {
            return order
        } else {
            return nil
        }
    }
}
