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
    case postNoteListToCart
    case postOrderNoteList
    case fetchOrderInfo
    case postPurchaseResult
    
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
        case .postNoteListToCart:
            return "shop/note/select"
        case .postOrderNoteList:
            return "shop/note/order"
        case .fetchOrderInfo:
            return "shop/note/order"
        case .postPurchaseResult:
            return "bootpay/confirm"
        }
    }
}
