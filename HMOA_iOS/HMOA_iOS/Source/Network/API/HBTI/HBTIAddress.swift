//
//  HBTIAddress.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/20/24.
//

import Foundation

enum HBTIAddress {
    case fetchHomeInfo
    case fetchQuestionList
    case postAnswerList
    case fetchPerfumeSurvey
    case postPerfumeAnswer
    case fetchNoteList
    case postNoteListToCart
    case postOrderNoteList
    case fetchOrderInfo(Int)
    case postPurchaseResult
    case deleteOrderItem(Int, Int)
    case deletePurchase(Int)
    case fetchReviewList
    case putDeleteReviewLike(Int)
    case fetchNotReviewedOrderList
    case fetchPostedReview
    case postReview
    case editDeleteReview(Int)
    
    var url: String {
        switch self {
        case .fetchHomeInfo:
            return "survey/home"
        case .fetchQuestionList:
            return "survey/note"
        case .postAnswerList:
            return "survey/note/respond"
        case .fetchPerfumeSurvey:
            return "survey/perfume"
        case .postPerfumeAnswer:
            return "survey/perfume/respond"
        case .fetchNoteList:
            return "shop/note"
        case .postNoteListToCart:
            return "shop/note/select"
        case .postOrderNoteList:
            return "shop/note/order"
        case .fetchOrderInfo(let orderId):
            return "shop/note/order/\(orderId)"
        case .postPurchaseResult:
            return "bootpay/confirm"
        case .deleteOrderItem(let orderId, let productId):
            return "shop/note/order/\(orderId)/product/\(productId)"
        case .deletePurchase(let orderId):
            return "bootpay/\(orderId)/cancel"
        case .fetchReviewList:
            return "shop/review"
        case .putDeleteReviewLike(let id):
            return "shop/review/\(id)/like"
        case .fetchNotReviewedOrderList:
            return "shop/order/me"
        case .fetchPostedReview:
            return "shop/review/me"
        case .postReview:
            return "shop/review"
        case .editDeleteReview(let id):
            return "shop/review/\(id)"
        }
    }
}
