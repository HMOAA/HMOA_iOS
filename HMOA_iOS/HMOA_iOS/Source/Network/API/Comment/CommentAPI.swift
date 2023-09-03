//
//  CommentAPI.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/02.
//

import Foundation
import RxSwift

final class CommentAPI {
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
    
    static func fetchCommentList(_ params: [String: Int], type: String) -> Observable<ResponseComment> {
        guard let id = params["perfumeId"] else { return .error(NetworkError.invalidParameters) }
        
        //type에 따른 url 변경
        var typeUrl: String
        if type == "Latest" { typeUrl = "" }
        else if type == "Like" { typeUrl = "/top" }
        else { return .error(NetworkError.invalidURL) }
        
        return networking(
            urlStr: CommentAddress.fetchCommentList(id).url + typeUrl,
            method: .get,
            data: nil,
            model: ResponseComment.self,
            query: params)
    }
}
