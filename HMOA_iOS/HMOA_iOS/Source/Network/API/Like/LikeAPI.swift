//
//  LikeAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/08/28.
//

import Foundation

import RxSwift

final class LikeAPI {
    static func putLike(_ id: Int) -> Observable<Response> {
        return networking(
            urlStr: LikeAddress.like("\(id)").url,
            method: .put,
            data: nil,
            model: Response.self
        )
    }
    
    static func deleteLike(_ id: Int) -> Observable<Response> {
        return networking(
            urlStr: LikeAddress.like("\(id)").url,
            method: .delete,
            data: nil,
            model: Response.self)
    }
    
    static func fetchLikeList() -> Observable<Response>{
        return networking(
            urlStr: LikeAddress.fetchLikeList.url,
            method: .get,
            data: nil,
            model: Response.self)
    }
}
