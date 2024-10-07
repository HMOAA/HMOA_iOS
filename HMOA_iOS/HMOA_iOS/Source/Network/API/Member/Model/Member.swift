//
//  Member.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/04.
//

import Foundation
import UIKit

struct Member: Codable, Hashable {
    var age: Int
    var memberImageUrl: String
    var memberId: Int
    var nickname: String
    var provider: String
    var sex: Bool
}

struct OrderResponse: Codable {
    let orders: [Order]
    let isLastPage: Bool
    
    enum CodingKeys: String, CodingKey {
        case orders = "data"
        case isLastPage = "lastPage"
    }
}

struct Order: Codable, Hashable {
    let id: Int
    let status: String
    let products: OrderInfo
    let createdAt: String
    let courierCompany: String?
    let trackingNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "orderId"
        case status = "orderStatus"
        case products = "orderProducts"
        case createdAt
        case courierCompany
        case trackingNumber
    }
}

struct OrderInfo: Codable, Hashable {
    let categoryListInfo: HBTICategoryListInfo
    let paymentAmount: Int
    let shippingFee: Int
    let totalAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case categoryListInfo = "productInfo"
        case paymentAmount
        case shippingFee = "shippingAmount"
        case totalAmount
    }
}

enum OrderStatus: String, Codable {
    case CREATED = "CREATED"
    case PAY_FAILED = "PAY_FAILED"
    case PAY_COMPLETE = "PAY_COMPLETE"
    case PAY_CANCEL = "PAY_CANCEL"
    case SHIPPING_PROGRESS = "SHIPPING_PROGRESS"
    case SHIPPING_COMPLETE = "SHIPPING_COMPLETE"
    case PURCHASE_CONFIRMATION = "PURCHASE_CONFIRMATION"
    
    var kr: String {
        switch self {
        case .CREATED:
            return "주문 생성"
        case .PAY_FAILED:
            return "결제 실패"
        case .PAY_COMPLETE:
            return "주문 완료"
        case .PAY_CANCEL:
            return "주문 취소"
        case .SHIPPING_PROGRESS:
            return "배송 중"
        case .SHIPPING_COMPLETE:
            return "배송 완료"
        case .PURCHASE_CONFIRMATION:
            return "구매 확정"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .SHIPPING_COMPLETE: return .customColor(.blue)
        default: return .black
        }
    }
}
