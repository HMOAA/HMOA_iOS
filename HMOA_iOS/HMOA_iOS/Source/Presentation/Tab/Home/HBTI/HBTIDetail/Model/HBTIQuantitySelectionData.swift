//
//  HBTIQuantitySelectionData.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/10/24.
//

import Foundation

struct HBTIQuantitySelectionData {
    let title: String
    let subtitle: String?
    
    static let titleText = """
                           추천받은 카테고리는 '시트러스' 입니다.
                           원하는 카테고리 배송 수량을
                           선택해주세요  · 향료 1개 당 990원
                           """
}

extension HBTIQuantitySelectionData {
    static let options = [
        HBTIQuantitySelectionData(title: "2개", subtitle: nil),
        HBTIQuantitySelectionData(title: "5개", subtitle: nil),
        HBTIQuantitySelectionData(title: "8개", subtitle: "31,900원 33,000원"),
        HBTIQuantitySelectionData(title: "자유롭게 선택", subtitle: nil),
    ]
}
