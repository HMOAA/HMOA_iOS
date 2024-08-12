//
//  HBTIProcessGuideData.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/10/24.
//

import Foundation

struct HBTIProcessGuideData {
    let index: Int
    let title: String
    let description: String
}

extension HBTIProcessGuideData {
    static let data = [
        HBTIProcessGuideData(index: 1, title: "향료 선택", description: "향BTI 검사 이후 추천하는 향료, 원하는 향료 선택\n(기격대 상이)"),
        HBTIProcessGuideData(index: 2, title: "배송", description: "결제 후 1-2일 내 배송 완료"),
        HBTIProcessGuideData(index: 3, title: "향수 추천", description: "시향 후 가장 좋았던 향료 선택, 향수 추천 받기")
    ]
}
