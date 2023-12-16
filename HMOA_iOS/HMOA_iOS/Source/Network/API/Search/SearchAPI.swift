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
    
    /// HPedia 용어 검색
    static func fetchSearchedHPediaTerm(query: [String: Any]) -> Observable<[HpediaTerm]> {
        return networking(
            urlStr: SearchAddress.fetchHPediaTerm.url,
            method: .get,
            data: nil,
            model: [HpediaTerm].self,
            query: query
        )
    }
    
    /// HPedia 노트 검색
    static func fetchSearchedHPediaNote(query: [String: Any]) -> Observable<[HpediaNote]> {
        return networking(
            urlStr: SearchAddress.fetchHPediaNote.url,
            method: .get,
            data: nil,
            model: [HpediaNote].self,
            query: query
        )
    }
    
    /// HPedia 조향사 검색
    static func fetchSearchedHPediaPerfumer(query: [String: Any]) -> Observable<[HpediaPerfumer]> {
        return networking(
            urlStr: SearchAddress.fetchHPediaPerfumer.url,
            method: .get,
            data: nil,
            model: [HpediaPerfumer].self,
            query: query
        )
    }
    
    /// HPedia 브랜드 검색
    static func fetchSearchedHPediaBrand(query: [String: Any]) -> Observable<[HpediaBrand]> {
        return networking(
            urlStr: SearchAddress.fetchHPediaBrand.url,
            method: .get,
            data: nil,
            model: [HpediaBrand].self,
            query: query
        )
    }
    
    /// 커뮤니티 게시를  검색
    static func fetchCommunity(query: [String: Any]) -> Observable<[CategoryList]> {
        return networking(
            urlStr: SearchAddress.fetchCommunity.url,
            method: .get,
            data: nil,
            model: [CategoryList].self,
            query: query
        )
    }
    
}
