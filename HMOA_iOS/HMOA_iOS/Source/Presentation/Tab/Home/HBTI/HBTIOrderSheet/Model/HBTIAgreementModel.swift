//
//  HBTIAgreementModel.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/1/24.
//

import Foundation

enum HBTIAgreementType {
    case allAgree
    case partialAgree
}

struct HBTIAgreementModel {
    let agreeTitle: String
    let agreementType: HBTIAgreementType
    
    static let agreementData: [HBTIAgreementModel] = [
        HBTIAgreementModel(agreeTitle: "주문 내용을 확인했으며, 아래의 정보 제공 및 결제에 모두 동의합니다.", agreementType: .allAgree),
        HBTIAgreementModel(agreeTitle: "배송/취소/반품/교환정책", agreementType: .partialAgree),
        HBTIAgreementModel(agreeTitle: "개인정보 제공 동의", agreementType: .partialAgree)
    ]
}

