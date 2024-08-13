//
//  HBTISurveyResultSection.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/13/24.
//

import Foundation

enum HBTISurveyResultSection: Hashable {
    case recommand
}

enum HBTISurveyResultItem: Hashable {
    case recommand(HBTISurveyResultNote)
}

extension HBTISurveyResultItem {
    var question: HBTISurveyResultNote? {
        if case .recommand(let note) = self {
            return note
        } else {
            return nil
        }
    }
}

// TODO: HBTI 설문 병합 후 이동
struct HBTISurveyResultResponse: Hashable {
    let recommandNotes: [HBTISurveyResultNote]
}

struct HBTISurveyResultNote: Hashable {
    let id: Int
    let name: String
    let photoURL: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case id = "noteId"
        case name = "noteName"
        case photoURL = "notePhotoUrl"
        case content
    }
}
