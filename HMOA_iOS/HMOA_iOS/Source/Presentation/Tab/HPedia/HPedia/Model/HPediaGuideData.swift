//
//  DictinoaryData.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

struct HPediaDictionaryData: Hashable{
    var id: Int
    var title: String
    var content: String
}

extension HPediaDictionaryData {
    static let list =
    [
        HPediaDictionaryData(
            id: 1,
            title: "용어",
            content:
                  """
                  Top notes
                  탑노트란?
                  """),
        HPediaDictionaryData(
            id: 2,
            title: "노트",
            content:
                  """
                  woody
                  우디
                  """),
        HPediaDictionaryData(
            id: 3,
            title: "조향사",
            content:
                  """
                  JoWanHee
                  조완희
                  """),
        HPediaDictionaryData(
            id: 4,
            title: "브랜드",
            content:
                  """
                  Gucci
                  구찌
                  """)
    ]
}
