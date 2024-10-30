//
//  HBTIHomeSection.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/23/24.
//

import Foundation

enum HBTIHomeSection: Hashable {
    case survey
    case review
}

enum HBTIHomeItem: Hashable {
    case survey(HBTIHomeSurvey)
    case review(HBTIReview)
}

extension HBTIHomeItem {
    var survey: HBTIHomeSurvey? {
        if case .survey(let survey) = self {
            return survey
        } else {
            return nil
        }
    }
    
    var review: HBTIReview? {
        if case .review(let review) = self {
            return review
        } else {
            return nil
        }
    }
    
    static let surveys: [HBTIHomeItem] = [
        .survey(HBTIHomeSurvey(title: "향BTI\n검사하러 가기", imageName: "goToSurvey")),
        .survey(HBTIHomeSurvey(title: "향료 입력하기\n(주문 후)", imageName: "selectSpice"))
    ]
}
