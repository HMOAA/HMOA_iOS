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
//    case note(HBTINote)
}

extension HBTIOrderSheetProductItem {
    var product: HBTICategory? {
        if case .productInfo(let product) = self {
            return product
        } else {
            return nil
        }
    }
    
//    var note: HBTINote? {
//        if case .note(let note) = self {
//            return note
//        } else {
//            return nil
//        }
//    }
}
