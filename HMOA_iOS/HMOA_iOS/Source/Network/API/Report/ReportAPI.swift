//
//  ReportAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/25/23.
//

import Foundation

import RxSwift

final class ReportAPI {
    static func reportContent(_ params: [String: Int], _ url: ReportAddress) -> Observable<Response> {
        guard let data = try? JSONSerialization.data(
            withJSONObject: params,
            options: .prettyPrinted) 
        else { return .error(NetworkError.invalidParameters) }
        
        return networking(
            urlStr: url.url,
            method: .post,
            data: data,
            model: Response.self)
    }
}
