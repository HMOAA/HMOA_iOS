//
//  HBTISurveyResultSection.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/13/24.
//

import Foundation

enum HBTISurveyResultSection: Hashable {
    case recommend
}

enum HBTISurveyResultItem: Hashable {
    case recommand(HBTISurveyResultNote)
}

extension HBTISurveyResultItem {
    var note: HBTISurveyResultNote? {
        if case .recommand(let note) = self {
            return note
        } else {
            return nil
        }
    }
}
