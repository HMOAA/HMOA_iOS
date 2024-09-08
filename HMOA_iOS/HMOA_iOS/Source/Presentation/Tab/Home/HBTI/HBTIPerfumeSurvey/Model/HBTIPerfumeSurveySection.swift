//
//  HBTIPerfumeSurveySection.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/5/24.
//

import Foundation

enum HBTIPerfumeSurveySection: Hashable {
    case price
    case note
}

enum HBTIPerfumeSurveyItem: Hashable {
    case price(HBTIQuestion)
    case note(HBTINoteQuestion)
}

extension HBTIPerfumeSurveyItem {
    var price: HBTIQuestion? {
        if case .price(let price) = self {
            return price
        } else {
            return nil
        }
    }
    
    var note: HBTINoteQuestion? {
        if case .note(let note) = self {
            return note
        } else {
            return nil
        }
    }
}

struct HBTINoteQuestionSection: Hashable {
    let category: String
}

struct HBTINoteQuestionItem: Hashable {
    let note: String
}

enum HBTISelectedNoteSection: Hashable {
    case selected
}

enum HBTISelectedNoteItem: Hashable {
    case note(String)
}
