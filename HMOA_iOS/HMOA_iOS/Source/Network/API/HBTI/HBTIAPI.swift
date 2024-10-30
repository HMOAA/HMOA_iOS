//
//  HBTIAPI.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/20/24.
//

import RxSwift

final class HBTIAPI {
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
    
    static func postPurchaseResult(params: [String: String]) -> Observable<Response> {
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                
        return networking(
            urlStr: HBTIAddress.postPurchaseResult.url,
            method: .post,
            data: data,
            model: Response.self
        )
    }
}
