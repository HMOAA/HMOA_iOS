//
//  HBTIOrderSheetData.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/29/24.
//

import Foundation

enum HBTIOrderSheetProductSection: Hashable {
    case order
}

enum HBTIOrderSheetProductItem: Hashable {
    case productInfo(HBTICategory)
}

extension HBTIOrderSheetProductItem {
    var product: HBTICategory? {
        if case .productInfo(let product) = self {
            return product
        } else {
            return nil
        }
    }
}
