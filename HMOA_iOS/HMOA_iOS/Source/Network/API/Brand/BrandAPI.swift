//
//  BrandAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/25.
//

import Foundation

import RxSwift

final class BrandAPI {
    
    
    /// 브랜드 단건 조회
    /// - Parameter brandId: 브랜드 id
    static func fetchBrandInfo(brandId: Int) -> Observable<BrandResponse> {
        return networking(
            urlStr: BrandAdress.fetchBrandInfomation("\(brandId)").url,
            method: .get,
            data: nil,
            model: BrandResponse.self)
    }
    
    static func fetchBrandList(_ query: [String: Int], brandId: Int, type: String) -> Observable<BrandPerfumeResponse> {
        
        return networking(
            urlStr: BrandAdress.fetchPerfumeListByBrand("\(brandId)", type).url,
            method: .get,
            data: nil,
            model: BrandPerfumeResponse.self,
            query: query)
    }
    
    
}
