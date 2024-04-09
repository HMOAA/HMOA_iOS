//
//  MagazineAPI.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/11/24.
//

import RxSwift

final class MagazineAPI {
    // Magazine
    static func fetchMagazineList(_ query: [String: Any]) -> Observable<[Magazine]> {
        return networking(
            urlStr: MagazineAddress.fetchMagazines.url,
            method: .get,
            data: nil,
            model: [Magazine].self,
            query: query)
    }
    
    static func fetchNewPerfumeList(_ query: [String: Any]) -> Observable<[MagazineItem]> {
        return networking(
            urlStr: MagazineAddress.fetchNewPerfumes.url,
            method: .get,
            data: nil,
            model: [MagazineItem].self,
            query: query)
    }
    
    static func fetchTopReviewList() -> Observable<[TopReview]> {
        return networking(
            urlStr: MagazineAddress.fetchTopReviews.url,
            method: .get,
            data: nil,
            model: [TopReview].self)
    }
    
    // MagazineDetail
    static func fetchMagazineDetail(_ id: Int) -> Observable<MagazineDetailResponse> {
        return networking(
            urlStr: MagazineAddress.fetchMagazineDetail(id).url,
            method: .get,
            data: nil,
            model: MagazineDetailResponse.self
        )
    }
    
    static func putMagazineLike(id: Int) -> Observable<Response> {
        return networking(
            urlStr: MagazineAddress.putDeleteMagazineLike(id).url,
            method: .put,
            data: nil,
            model: Response.self
        )
    }
    
    static func deleteMagazineLike(id: Int) -> Observable<Response> {
        return networking(
            urlStr: MagazineAddress.putDeleteMagazineLike(id).url,
            method: .delete,
            data: nil,
            model: Response.self
        )
    }
}
