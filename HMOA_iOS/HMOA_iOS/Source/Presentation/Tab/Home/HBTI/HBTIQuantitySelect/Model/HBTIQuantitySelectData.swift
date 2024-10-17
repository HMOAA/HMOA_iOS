//
//  HBTIQuantitySelectData.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/16/24.
//

import Foundation

struct HBTIQuantitySelectionData {
    let titleLabelText = """
                         추천받은 향료 카테고리는 '시트러스' 입니다.
                         원하는 시향카드 배송 수량을
                         선택해주세요
                         """
    
    let descriptionLabelText = "· 향료 1개 당 990원"
}

struct NotesQuantity {
    let text: String
    let quantity: Int
}

extension NotesQuantity {
    static let quantities: [NotesQuantity] = [
        NotesQuantity(text: "2개", quantity: 2),
        NotesQuantity(text: "5개", quantity: 5),
        NotesQuantity(text: "8개", quantity: 8),
        NotesQuantity(text: "자유롭게 선택", quantity: 8)
    ]
}
