//
//  TotalPerfumeAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 12/15/23.
//

import Foundation

import RxSwift
final class TotalPerfumeAPI {
    static func fetchTotalPerfumeList(url: TotalPerfumeAddress) -> Observable<[BrandPerfume]> {
        return networking(
            urlStr: url.url,
            method: .get,
            data: nil,
            model: [BrandPerfume].self)
    }
}
