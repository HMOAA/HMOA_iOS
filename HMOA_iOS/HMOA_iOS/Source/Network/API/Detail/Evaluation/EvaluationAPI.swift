//
//  EvaluationAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/14.
//

import Foundation

import RxSwift

final class EvaluationAPI {
    
    
    ///  계절 값 보내기
    /// - Parameters:
    ///   - id: 향수 id
    ///   - weather:  [weather: 1~4]
    ///     1: 봄, 2: 여름, 3: 가을, 4: 겨울
    static func postSeason(id: String, weather: [String: Int]) -> Observable<Weather> {
        
        guard let data = try? JSONSerialization.data(
                    withJSONObject: weather,
                    options: .prettyPrinted)
        else { return .error(NetworkError.invalidParameters) }
        
        return networking(
            urlStr: EvaluationAddres.postWether(id).url,
            method: .post,
            data: data,
            model: Weather.self)
    }
}
