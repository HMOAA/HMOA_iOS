//
//  HPediaAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/23/23.
//

import Foundation

import RxSwift

final class HPediaAPI {
    
    
    /// HPedia 용어 받아오기
    static func fetchTermList(_ query: [String: Int]) -> Observable<HpediaTermResponse> {
        
        
        return networking(
            urlStr: HPediaAddress.fetchTermList.url,
            method: .get,
            data: nil,
            model: HpediaTermResponse.self,
            query: query
        )
    }
    
    /// HPedia 노트 받아오기
    static func fetchNoteList(_ query: [String: Int]) -> Observable<HpediaNoteResponse> {
        
        return networking(
            urlStr: HPediaAddress.fetchNoteList.url,
            method: .get,
            data: nil,
            model: HpediaNoteResponse.self,
            query: query)
    }
    
    /// HPedia 조향사 받아오기
    static func fetchPerfumerList(_ query: [String: Int]) -> Observable<HpediaPerfumerResponse> {
        
        return networking(
            urlStr: HPediaAddress.fetchPerfumerList.url,
            method: .get,
            data: nil,
            model: HpediaPerfumerResponse.self,
            query: query)
    }
    
    /// HPedia 브랜드 받아오기
    static func fetchBrandList(_ query: [String: Int]) -> Observable<HpediaBrandResponse> {
        
        return networking(
            urlStr: HPediaAddress.fetchBrandList.url,
            method: .get,
            data: nil,
            model: HpediaBrandResponse.self,
            query: query)
    }
    
    /// HPedia 용어 정보 받아오기
    static func fetchTermDetail(_ id: Int) -> Observable<HpediaTermResponse> {
        return networking(
            urlStr: HPediaAddress.fetchTermDetail("\(id)").url,
            method: .get,
            data: nil,
            model: HpediaTermResponse.self)
    }
    
    /// HPedia 노트 정보 받아오기
    static func fetchNoteDetail(_ id: Int) -> Observable<HpediaNoteResponse> {
        return networking(
            urlStr: HPediaAddress.fetchNoteDetail("\(id)").url,
            method: .get,
            data: nil,
            model: HpediaNoteResponse.self)
    }
    
    /// HPedia 조향사 정보 받아오기
    static func fetchPerfumerDetail(_ id: Int) -> Observable<HpediaPerfumerResponse> {
        return networking(
            urlStr: HPediaAddress.fetchPerfumerDetail("\(id)").url,
            method: .get,
            data: nil,
            model: HpediaPerfumerResponse.self)
    }
    
    /// HPedia 브랜드 정보 받아오기
    static func fetchBrandDetail(_ id: Int) -> Observable<HpediaBrandResponse> {
        return networking(
            urlStr: HPediaAddress.fetchBrandDetail("\(id)").url,
            method: .get,
            data: nil,
            model: HpediaBrandResponse.self)
    }
}
