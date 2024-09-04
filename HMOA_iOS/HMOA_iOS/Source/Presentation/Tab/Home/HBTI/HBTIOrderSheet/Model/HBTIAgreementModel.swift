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
    static let agreementData: [HBTIAgreementModel] = [
        HBTIAgreementModel(agreementTitle: "배송/취소/반품/교환정책"),
        HBTIAgreementModel(agreementTitle: "개인정보 제공 동의")
    ]
}

