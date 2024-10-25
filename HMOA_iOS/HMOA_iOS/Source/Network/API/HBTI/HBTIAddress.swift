//
//  HBTIAddress.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/20/24.
//

import Foundation

enum HBTIAddress {
    case fetchQuestionList
    case postAnswerList
    case fetchPerfumeSurvey
    case postPerfumeAnswer
    case fetchReviewList
    case putDeleteReviewLike(Int)
    case fetchNotReviewedOrderList
    
    var url: String {
        switch self {
        case .fetchQuestionList:
            return "survey/note"
        case .postAnswerList:
            return "survey/note/respond"
        case .fetchPerfumeSurvey:
            return "survey/perfume"
        case .postPerfumeAnswer:
            return "survey/perfume/respond"
        case .fetchReviewList:
            return "shop/review"
        case .putDeleteReviewLike(let id):
            return "shop/review/\(id)/like"
        case .fetchNotReviewedOrderList:
            return "shop/order/me"
        }
    }
}
