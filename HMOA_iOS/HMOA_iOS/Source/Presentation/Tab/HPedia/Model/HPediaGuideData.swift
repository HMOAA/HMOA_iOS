//
//  GuideData.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

struct HPediaGuideData {
    var title: String
    var content: String
}

extension HPediaGuideData {
    static let list =
    [
        GuideData(title: "용어",
                  content:
                  """
                  Top notes
                  탑노트란?
                  """),
        GuideData(title: "브랜드",
                  content:
                  """
                  Chanel
                  샤넬
                  """),
        GuideData(title: "노트",
                  content:
                  """
                  woody
                  우디
                  """)
    ]
}
