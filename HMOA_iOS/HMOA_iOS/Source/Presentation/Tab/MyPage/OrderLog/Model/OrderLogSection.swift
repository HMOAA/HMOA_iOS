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
    
    static let exampleOrder: [OrderLogItem] = [
        .order(Order(
            id: 1,
            status: OrderStatus.PAY_COMPLETE.rawValue,
            products: OrderInfo(
                categoryListInfo: HBTICategoryListInfo(
                    totalPrice: 40000,
                    categoryList: [
                        HBTICategory(
                            id: 1,
                            name: "시트러스",
                            imageURL: "https://example.com/citrus.jpeg",
                            noteCount: 3,
                            noteList: [
                                HBTINote(name: "라임", content: "상쾌하고 달콤한 라임 향"),
                                HBTINote(name: "레몬", content: "시원한 레몬 향"),
                                HBTINote(name: "오렌지", content: "진하고 상큼한 오렌지 향")
                            ],
                            price: 20000
                        ),
                        HBTICategory(
                            id: 2,
                            name: "플로럴",
                            imageURL: "https://example.com/floral.jpeg",
                            noteCount: 2,
                            noteList: [
                                HBTINote(name: "로즈", content: "달콤하고 은은한 장미 향"),
                                HBTINote(name: "라벤더", content: "편안하고 깊이 있는 라벤더 향")
                            ],
                            price: 20000
                        )
                    ]
                ),
                paymentAmount: 40000,
                shippingFee: 3000,
                totalAmount: 43000
            ),
            createdAt: "2024/09/24",
            courierCompany: nil,
            trackingNumber: nil
        )),
        .order(Order(
            id: 2,
            status: OrderStatus.SHIPPING_PROGRESS.rawValue,
            products: OrderInfo(
                categoryListInfo: HBTICategoryListInfo(
                    totalPrice: 30000,
                    categoryList: [
                        HBTICategory(
                            id: 2,
                            name: "우디",
                            imageURL: "https://example.com/woody.jpeg",
                            noteCount: 2,
                            noteList: [
                                HBTINote(name: "시더우드", content: "따뜻하고 깊이 있는 나무 향"),
                                HBTINote(name: "베티버", content: "흙내음이 나는 깊고 묵직한 나무 향")
                            ],
                            price: 15000
                        )
                    ]
                ),
                paymentAmount: 30000,
                shippingFee: 3000,
                totalAmount: 33000
            ),
            createdAt: "2024/09/25",
            courierCompany: "대한통운",
            trackingNumber: "1234567890"
        )),
        .order(Order(
            id: 3,
            status: OrderStatus.SHIPPING_COMPLETE.rawValue,
            products: OrderInfo(
                categoryListInfo: HBTICategoryListInfo(
                    totalPrice: 75000,
                    categoryList: [
                        HBTICategory(
                            id: 5,
                            name: "프루티",
                            imageURL: "https://example.com/fruity.jpeg",
                            noteCount: 3,
                            noteList: [
                                HBTINote(name: "복숭아", content: "달콤하고 부드러운 복숭아 향"),
                                HBTINote(name: "블랙베리", content: "진하고 달콤한 블랙베리 향"),
                                HBTINote(name: "자몽", content: "새콤하고 상큼한 자몽 향")
                            ],
                            price: 35000
                        ),
                        HBTICategory(
                            id: 6,
                            name: "그린",
                            imageURL: "https://example.com/green.jpeg",
                            noteCount: 2,
                            noteList: [
                                HBTINote(name: "바질", content: "상쾌하고 풍부한 허브 향"),
                                HBTINote(name: "파인", content: "산뜻하고 시원한 솔잎 향")
                            ],
                            price: 40000
                        )
                    ]
                ),
                paymentAmount: 75000,
                shippingFee: 3500,
                totalAmount: 78500
            ),
            createdAt: "2024/09/26",
            courierCompany: "한진택배",
            trackingNumber: "0987654321"
        ))
    ]
}
