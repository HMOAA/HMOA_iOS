//
//  CommunityAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/30.
//

import Foundation

import RxSwift

final class CommunityAPI {
    
    
    
    /// 카테고리별 게시글 받아오기
    static func fetchPostListsByCaetgory() -> Observable<CategoryList> {
        return networking(
            urlStr: CommunityAddress.fetchPostsByCategory.url,
            method: .get,
            data: nil,
            model: CategoryList.self)
    }
    
    
    /// 게시글 상세 정보 받아오기
    /// - Parameter id: communityId
    static func fetchPostDetail(_ id: Int) -> Observable<CommunityDetail> {
        return networking(
            urlStr: CommunityAddress.fetchPostDetail("\(id)").url,
            method: .get,
            data: nil,
            model: CommunityDetail.self)
    }
    
    
    /// 게시글 작성하기
    /// - Parameter params: [
    ///category: String
    ///content: String
    ///title: String]
    static func postCommunityPost(_ params: [String: Any]) -> Observable<CommunityDetail> {
        
        let data = try? JSONSerialization.data(
            withJSONObject: params,
            options: .prettyPrinted
        )
        
        return networking(
            urlStr: CommunityAddress.postCommnunityPost.url,
            method: .post,
            data: data,
            model: CommunityDetail.self)
    }
}
    
