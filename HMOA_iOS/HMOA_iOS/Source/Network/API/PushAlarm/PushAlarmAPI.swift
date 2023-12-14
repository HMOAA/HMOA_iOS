//
//  PushAlarmAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 12/14/23.
//

import Foundation

import RxSwift

final class PushAlarmAPI {
    static func postFcmToken(_ params: [String: String]) -> Observable<Response> {
        guard let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) else { return .error(NetworkError.invalidParameters) }
        
        return networking(
            urlStr: PushAlarmAddress.postFcmToken.url,
            method: .post,
            data: data,
            model: Response.self)
    }
    
    static func deleteFcmToken() -> Observable<Response> {
        
        return networking(
            urlStr: PushAlarmAddress.deleteFcmToken.url,
            method: .delete,
            data: nil,
            model: Response.self)
    }
}
