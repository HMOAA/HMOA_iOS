//
//  HBTINotesResultModel.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/23/24.
//

import Foundation

struct HBTINotesResultModel {
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let price: Int
    let description: String
}

extension HBTINotesResultModel {
    static let notesResultData = [
        HBTINotesResultModel(
            id: 1,
            title: "프루트",
            subtitle: "(3가지 향료)",
            image: "Fruit",
            price: 4800,
            description: """
                         · 통카빈 : 열대 나무 씨앗을 말린 향신료
                         · 넛맥 : 넛맥이란 식물을 말린 향신료
                         · 페퍼 : 후추
                         """
        ),
        HBTINotesResultModel(
            id: 2,
            title: "플로럴",
            subtitle: "6가지 향료",
            image: "Floral",
            price: 4800,
            description: """
                         · 네롤리 : 오렌지 꽃에서 추출한 에센셜 오일
                         · 화이트 로즈 : 흰 장미 향
                         · 핑크 로즈 : 분홍 장미 향
                         """
        ),
        HBTINotesResultModel(
            id: 3,
            title: "시트러스",
            subtitle: "6가지 향료",
            image: "Citrus",
            price: 6000,
            description: """
                         · 라임 만다린 : 라임과 만다린의 혼합 향
                         · 베르가못 : 시트러스 계열의 과일 향
                         · 비터 오렌지 : 쓴 오렌지 향
                         · 자몽 : 상큼한 자몽 향
                         """
        )
    ]
}
