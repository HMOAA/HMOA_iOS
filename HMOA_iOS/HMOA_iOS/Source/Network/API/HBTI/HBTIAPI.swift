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
}
