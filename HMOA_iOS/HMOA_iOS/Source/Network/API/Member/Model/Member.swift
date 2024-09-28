//
//  Member.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/04.
//

import Foundation

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
        case categoryListInfo
        case paymentAmount
        case shippingFee = "shippingAmount"
        case totalAmount
    }
}
