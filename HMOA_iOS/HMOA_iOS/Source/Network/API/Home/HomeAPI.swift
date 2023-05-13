//
//  HomeAPI.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/13.
//

import RxSwift

class HomeAPI {
    
    static func getHomeData() -> Observable<HomeData> {
        return networking(
            urlStr: HomeAddress.getHomeData.url,
            method: .get,
            data: nil,
            model: HomeData.self)
    }
}


