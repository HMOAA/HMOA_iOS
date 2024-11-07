//
//  HBTINotesCategoryData.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/19/24.
//

import Foundation

struct HBTICategoryLabelTexts {
    let noteName: String
    var titleLabelText: String {
         """
         추천받은 카테고리는 '\(noteName)' 입니다.
         그 외에 원하는 시향카드 카테고리를
         선택해주세요
         """
    }
    let descriptionLabelText = "*향료 1개 당 990원"
}

enum HBTINotesCategorySection: Hashable {
    case category
}

enum HBTINotesCategoryItem: Hashable {
    case note(HBTINotesCategory)
}

extension HBTINotesCategoryItem {
    var result: HBTINotesCategory? {
        if case .note(let noteList) = self {
            return noteList
        } else {
            return nil
        }
    }
}
