//
//  SearchAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/07/15.
//

import Foundation
import RxSwift

final class SearchAPI {
    
    static func getPerfumeName(params: [String: Any]) -> Observable<[SearchPerfumeName]> {
        return networking(
            urlStr: SearchAddress.getPerfumeName.url,
            method: .get,
            data: nil,
            model: [SearchPerfumeName].self,
            query: params
        )
    }
    
    static func getPerfumeInfo(params: [String: Any]) -> Observable<[SearchPerfume]> {
        return networking(
            urlStr: SearchAddress.getPerfumeInfo.url,
            method: .get,
            data: nil,
            model: [SearchPerfume].self,
            query: params
        )
    }
    
    static func getBrandPaging(query: [String: Int]) -> Observable<[Brand]> {
        return networking(
            urlStr: SearchAddress.fetchBrandAll.url,
            method: .get,
            data: nil,
            model: [Brand].self,
            query: query
        )
    }
    
    static func fetchSearchBrand(query: [String: String]) -> Observable<[BrandList]> {
        return networking(
            urlStr: SearchAddress.fetchSearchBrand.url,
            method: .get,
            data: nil,
            model: [BrandList].self,
            query: query
        )
    }
    
}
