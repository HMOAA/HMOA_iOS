//
//  HBTIAPI.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/20/24.
//

import RxSwift

final class HBTIAPI {
    static func fetchHomeInfo() -> Observable<HBTIHomeInfo> {
        return networking(
            urlStr: HBTIAddress.fetchHomeInfo.url,
            method: .get,
            data: nil,
            model: HBTIHomeInfo.self)
    }
    
    static func fetchSurvey() -> Observable<HBTISurveyResponse> {
        return networking(
            urlStr: HBTIAddress.fetchQuestionList.url,
            method: .get,
            data: nil,
            model: HBTISurveyResponse.self)
    }
    
    static func postAnswers(params: [String: [Int]]) -> Observable<HBTISurveyResultResponse> {
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        return networking(
            urlStr: HBTIAddress.postAnswerList.url,
            method: .post,
            data: data,
            model: HBTISurveyResultResponse.self)
    }
    
    static func fetchPerfumeSurvey() -> Observable<HBTIPerfumeServeyResponse> {
        return networking(
            urlStr: HBTIAddress.fetchPerfumeSurvey.url,
            method: .get,
            data: nil,
            model: HBTIPerfumeServeyResponse.self)
    }
    
    static func postPerfumeAnswer(params: [String: Any], isContainAll: Bool) -> Observable<HBTIPerfumeResultResponse> {
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        return networking(
            urlStr: HBTIAddress.postPerfumeAnswer.url,
            method: .post,
            data: data,
            model: HBTIPerfumeResultResponse.self,
            query: ["isContainAll": isContainAll])
    }
    
    static func postNoteListToCart(params: [String: [Int]]) -> Observable<HBTICategoryListInfo> {
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        return networking(
            urlStr: HBTIAddress.postNoteListToCart.url,
            method: .post,
            data: data,
            model: HBTICategoryListInfo.self
        )
    }
    
    static func postOrderNoteList(params: [String: [Int]]) -> Observable<HBTIOrderResult> {
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        return networking(
            urlStr: HBTIAddress.postOrderNoteList.url,
            method: .post,
            data: data,
            model: HBTIOrderResult.self
        )
    }
    
    static func fetchOrderInfo(orderId: Int) -> Observable<HBTIOrderInfoResponse> {
        let url = "\(HBTIAddress.fetchOrderInfo.url)/\(orderId)"
        
        return networking(
            urlStr: url,
            method: .get,
            data: nil,
            model: HBTIOrderInfoResponse.self)
    }
        
    static func fetchReivewList(fromMember: Bool, page: Int) -> Observable<HBTIReviewListResponse> {
        let url = fromMember ? HBTIAddress.fetchPostedReview.url : HBTIAddress.fetchReviewList.url
        let query = fromMember ? ["cursor": page] : ["page": page]
        
        return networking(
            urlStr: url,
            method: .get,
            data: nil,
            model: HBTIReviewListResponse.self,
            query: query
        )
    }
    
    static func postPurchaseResult(params: [String: String]) -> Observable<Response> {
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                
        return networking(
            urlStr: HBTIAddress.postPurchaseResult.url,
            method: .post,
            data: data,
            model: Response.self
        )
    }
    
    static func deleteOrderItem(orderId: Int, productId: Int) -> Observable<HBTIOrderInfoResponse> {
        let url = "\(HBTIAddress.deleteOrderItem.url)/\(orderId)/product/\(productId)"
        
        return networking(
            urlStr: url,
            method: .delete,
            data: nil,
            model: HBTIOrderInfoResponse.self)
    }
    
    static func deletePurchase(orderId: Int) -> Observable<Response> {
        return networking(
            urlStr: HBTIAddress.deletePurchase(orderId: orderId).url,
            method: .delete,
            data: nil,
            model: Response.self
        )
    }

    static func putReviewLike(id: Int) -> Observable<Response> {
        return networking(
            urlStr: HBTIAddress.putDeleteReviewLike(id).url,
            method: .put,
            data: nil,
            model: Response.self,
            query: ["ReviewId" : id]
        )
    }
    
    static func deleteReviewLike(id: Int) -> Observable<Response> {
        return networking(
            urlStr: HBTIAddress.putDeleteReviewLike(id).url,
            method: .delete,
            data: nil,
            model: Response.self,
            query: ["ReviewId" : id]
        )
    }
    
    static func fetchNotReviewdOrderList() -> Observable<[NotReviewedOrder]> {
        return networking(
            urlStr: HBTIAddress.fetchNotReviewedOrderList.url,
            method: .get,
            data: nil,
            model: [NotReviewedOrder].self
        )
    }
    
    static func postReview(_ params: [String: Any], images: [UIImage]) -> Observable<HBTIReview> {
        var imageData: [Data]?
        
        if images.isEmpty {
            imageData = nil
        } else {
            imageData = images.compactMap { $0.resize(targetSize: $0.size)?.jpegData(compressionQuality: 0.1) }
        }
        
        return uploadNetworking(
            urlStr: HBTIAddress.postReview.url,
            method: .post,
            imageData: imageData,
            imageFileName: "reviewImage.jpeg",
            parameter: params,
            model: HBTIReview.self)
    }
    
    static func deleteReivew(id: Int) -> Observable<Response> {
        return networking(
            urlStr: HBTIAddress.editDeleteReview(id).url,
            method: .delete,
            data: nil,
            model: Response.self)
    }
    
    static func editReview(reviewID: Int, params: [String: Any], images: [UIImage]) -> Observable<HBTIReview> {
        var imageData: [Data]?
        
        if images.isEmpty {
            imageData = nil
        } else {
            imageData = images.compactMap { $0.resize(targetSize: $0.size)?.jpegData(compressionQuality: 0.1) }
        }
        
        return uploadNetworking(
            urlStr: HBTIAddress.editDeleteReview(reviewID).url,
            method: .post,
            imageData: imageData,
            imageFileName: "reviewImage.jpeg",
            parameter: params,
            model: HBTIReview.self)
    }
}
