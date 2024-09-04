//
//  HBTIAgreementModel.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/1/24.
//

import Foundation

struct HBTIAgreementModel {
    let agreementTitle: String
}

extension HBTIAgreementModel {
    static let allAgreementData: HBTIAgreementModel = HBTIAgreementModel(agreementTitle: "주문 내용을 확인했으며, 아래의 정보 제공 및 결제에 모두 동의합니다.")
    
    static let partialAgreementData: [HBTIAgreementModel] = [
        HBTIAgreementModel(agreementTitle: "배송/취소/반품/교환정책"),
        HBTIAgreementModel(agreementTitle: "개인정보 제공 동의")
    ]
}

