//
//  DictionaryData.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/06.
//

import Foundation

struct DictionaryData {
    let englishName: String
    let koreanName: String
}

extension DictionaryData {
    static let data: [DictionaryData] = [
        DictionaryData(englishName: "Top Notes", koreanName: "탑 노트"),
        DictionaryData(englishName: "Middle Notes", koreanName: "미들 노트"),
        DictionaryData(englishName: "Base Notes", koreanName: "베이스 노트")
    ]
}
