//
//  DictinoaryData.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

struct HPediaDictionaryData: Hashable {
    var title: String
    var content: String
    var type: HpediaType
}

extension HPediaDictionaryData {
    static let list =
    [
        HPediaDictionaryData(
            title: HpediaType.term.title,
            content:
                  """
                  Top notes
                  탑노트란?
                  """,
            type: .term
        ),
        HPediaDictionaryData(
            title: HpediaType.note.title,
            content:
                  """
                  woody
                  우디
                  """,
            type: .note
        ),
        HPediaDictionaryData(
            title: HpediaType.perfumer.title,
            content:
                  """
                  JoWanHee
                  조완희
                  """,
            type: .perfumer
        ),
        HPediaDictionaryData(
            title: HpediaType.brand.title,
            content:
                  """
                  Gucci
                  구찌
                  """,
            type: .brand
        )
    ]
}
