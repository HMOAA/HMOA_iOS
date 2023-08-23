//
//  DetailAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/08/18.
//

import Foundation
import RxSwift

final class DetailAPI {
    
    //향수 단일 정보 검색
    static func fetchPerfumeDetail(_ id: Int) -> Observable<PerfumeDetail>{
        return networking(
            urlStr: DetailAddress.fetchPerfumeDetail.url + "\(id)",
            method: .get,
            data: nil,
            model: PerfumeDetail.self
        )
    }
}
