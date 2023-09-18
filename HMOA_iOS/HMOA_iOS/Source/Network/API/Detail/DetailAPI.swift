//
//  DetailAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/08/18.
//

import Foundation
import RxSwift

final class DetailAPI {
    
    
    /// 향수 정보 받아오기1
    /// - Parameter id: 향수 id
    static func fetchPerfumeDetail(_ id: Int) -> Observable<FirstDetail> {
        return networking(
            urlStr: DetailAddress.fetchFirstPerfumeDetail.url + "\(id)",
            method: .get,
            data: nil,
            model: FirstDetail.self
        )
    }
    
    /// 향수 정보 받아오기2
    /// - Parameter id: 향수 id
    static func fetchPerfumeDetail2(_ id: Int) -> Observable<SecondDetail> {
        return networking(
            urlStr: DetailAddress.fetchSecondPErfumeDetail(String(id)).url,
            method: .post,
            data: nil,
            model: SecondDetail.self)
    }
}
