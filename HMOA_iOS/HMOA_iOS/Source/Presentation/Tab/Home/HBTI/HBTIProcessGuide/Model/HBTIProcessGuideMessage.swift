//
//  HBTIProcessGuideMessage.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/16/24.
//

import Foundation

struct HBTIProcessGuideData {
    let index: Int
    let title: String
    let description: String
}

extension HBTIProcessGuideData {
    static let processData = [
        HBTIProcessGuideData(index: 1, title: "향료 선택", description: "향BTI 검사 후 추천 받은 향료 카테고리 + 그외에 선호 향료 카테고리 선택 가능 (카테고리 별 향료 3~5개)"),
        HBTIProcessGuideData(index: 2, title: "배송", description: "결제 후 1-2일 내 향료 시향카드 배송 완료\n(시향 후 책갈피로 활용 가능)"),
        HBTIProcessGuideData(index: 3, title: "향수 추천", description: "시향 후 가장 좋았던 향료 선택 + 향수 추천 받기")
    ]
}
