//
//  HBTIPaymentMethodModel.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/30/24.
//

import Foundation

enum PaymentMethodType: String {
    case toss = "토스페이"
    case kakao = "카카오페이"
    case payco = "페이코"
    case general = "일반 결제"
}

struct HBTIPaymentMethodModel {
    static let paymentMethods: [PaymentMethodType] = [.toss, .kakao, .payco, .general]
}
