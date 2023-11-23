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
    static func fetchTermList() -> Observable<HpediaTermResponse> {
        return networking(
            urlStr: HPediaAddress.fetchTermList.url,
            method: .get,
            data: nil,
            model: HpediaTermResponse.self)
    }
    
    /// HPedia 노트 받아오기
    static func fetchNoteList() -> Observable<HpediaNoteResponse> {
        return networking(
            urlStr: HPediaAddress.fetchNoteList.url,
            method: .get,
            data: nil,
            model: HpediaNoteResponse.self)
    }
    
    /// HPedia 조향사 받아오기
    static func fetchPerfumerList() -> Observable<HpediaPerfumerResponse> {
        return networking(
            urlStr: HPediaAddress.fetchPerfumerList.url,
            method: .get,
            data: nil,
            model: HpediaPerfumerResponse.self)
    }
    
    /// HPedia 브랜드 받아오기
    static func fetchBrandList() -> Observable<HpediaBrandResponse> {
        return networking(
            urlStr: HPediaAddress.fetchBrandList.url,
            method: .get,
            data: nil,
            model: HpediaBrandResponse.self)
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
