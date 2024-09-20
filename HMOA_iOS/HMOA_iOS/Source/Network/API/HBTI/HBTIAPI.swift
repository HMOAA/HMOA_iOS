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
}
