//
//  HomeAPI.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/13.
//

import RxSwift

class HomeAPI {
    
    /// 홈 화면 2개 데이터 값 받아오는 API
    static func getFirstHomeData() -> Observable<HomeFirstData> {
        return networking(
            urlStr: HomeAddress.getFirstHomeData.url,
            method: .get,
            data: nil,
            model: HomeFirstData.self)
    }
    
    /// 홈 화면 나머지 데이터 값 받아오는 API
    static func getSecondHomeData() -> Observable<HomeSecondData> {
        return networking(
            urlStr: HomeAddress.getsecondHomeData.url,
            method: .get,
            data: nil,
            model: HomeSecondData.self)
    }
}


