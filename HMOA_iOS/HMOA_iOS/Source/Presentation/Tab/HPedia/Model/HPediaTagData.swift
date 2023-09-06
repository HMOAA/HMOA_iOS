//
//  HPediaBrandData.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

struct HPediaQnAData: Hashable {
    var id: Int
    var category: String
    var title: String
}

extension HPediaQnAData {
    static let list =
    [
        HPediaQnAData(id: 1, category: "추천해주세요", title: "여자친구에게 선물할 향수 뭐가 좋을까요?"),
        HPediaQnAData(id: 2, category: "용어", title: "노트를 구분하는 용어들이 어려워요?"),
        HPediaQnAData(id: 3, category: "기타", title: "이런 상황에서 어떻게 하시나요?"),
        HPediaQnAData(id: 4, category: "추천해주세요", title: "여자친구에게 선물할 향수 뭐가 좋을까요?"),
        HPediaQnAData(id: 5, category: "용어", title: "노트를 구분하는 용어들이 어려워요?"),
        HPediaQnAData(id: 6, category: "기타", title: "이런 상황에서 어떻게 하시나요?")
    ]
}
