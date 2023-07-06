//
//  GuideData.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

struct HPediaGuideData: Hashable{
    var id: Int
    var title: String
    var content: String
}

extension HPediaGuideData {
    static let list =
    [
        HPediaGuideData(
            id: 1,
            title: "용어",
            content:
                  """
                  Top notes
                  탑노트란?
                  """),
        HPediaGuideData(
            id: 2,
            title: "브랜드",
            content:
                  """
                  Chanel
                  샤넬
                  """),
        HPediaGuideData(
            id: 3,
            title: "노트",
            content:
                  """
                  woody
                  우디
                  """),
        HPediaGuideData(
            id: 4,
            title: "노트",
            content:
                  """
                  woody
                  우디
                  """)
    ]
}
