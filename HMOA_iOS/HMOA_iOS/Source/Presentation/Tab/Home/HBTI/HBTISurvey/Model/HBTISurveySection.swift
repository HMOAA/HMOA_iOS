//
//  HBTISurveySection.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/14/24.
//

import Foundation

enum HBTISurveySection: Hashable {
    case question
}

enum HBTISurveyItem: Hashable {
    case question(HBTIQuestion)
}

extension HBTISurveyItem {
    var question: HBTIQuestion? {
        if case .question(let question) = self {
            return question
        } else {
            return nil
        }
    }
}
