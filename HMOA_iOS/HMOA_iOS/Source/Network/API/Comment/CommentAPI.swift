//
//  CommentAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/02.
//

import Foundation
import RxSwift

final class CommentAPI {
    
    
    /// 댓글 작성
    /// - Parameters:
    ///   - params: content: 댓글 내용
    ///   - id: 향수 아이디
    static func postComment(_ params: [String: String], _ id: Int) -> Observable<Response> {
        guard let data = try? JSONSerialization.data(
            withJSONObject: params,
            options: .prettyPrinted) else { return .error(NetworkError.invalidParameters) }
                
        return networking(
            urlStr: CommentAddress.postCommnet(id).url,
            method: .post,
            data: data,
            model: Response.self)
        
    }
    
    
    /// 댓글 리스트 받아오기
    /// - Parameters:
    ///   - params: [page: Int,  perfumeId: Int]
    ///   - type: String - 최신순, 좋아요 순 여부
    static func fetchCommentList(_ params: [String: Int], type: String) -> Observable<ResponseComment> {
        guard let id = params["perfumeId"] else { return .error(NetworkError.invalidParameters) }
        
        //type에 따른 url 변경
        var typeUrl: String
        if type == "Latest" { typeUrl = "" }
        else if type == "Like" { typeUrl = "top" }
        else { return .error(NetworkError.invalidURL) }
        
        return networking(
            urlStr: CommentAddress.fetchCommentList(id, typeUrl).url,
            method: .get,
            data: nil,
            model: ResponseComment.self,
            query: params)
    }
    
    /// 댓글 좋아요
    /// - Parameter id: perfumId
    static func putCommentLike(_ id: Int) -> Observable<Response> {
        return networking(
            urlStr: CommentAddress.setCommentLike(id).url,
            method: .put,
            data: nil,
            model: Response.self)
    }
    
    
    /// 댓글 좋아요 삭제
    /// - Parameter id: perfumeId
    static func deleteCommentLike(_ id: Int) -> Observable<Response> {
        return networking(
            urlStr: CommentAddress.setCommentLike(id).url,
            method: .delete,
            data: nil,
            model: Response.self)
    }
}
