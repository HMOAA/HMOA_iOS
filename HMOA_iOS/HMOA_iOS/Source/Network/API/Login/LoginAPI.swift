//
//  LoginAPI.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/04.
//

import Foundation
import RxSwift

final class LoginAPI {
    
    //googleToken 보내기
    static func postAccessToken(params: [String: String]) -> Observable<Token> {
        
        guard let data = try? JSONSerialization.data(
                    withJSONObject: params,
                    options: .prettyPrinted)
                
        else { return Observable.error(NetworkError.invalidParameters)}
        
        return networking(
            urlStr: LoginAddress.postToken.url,
            method: .post,
            data: data,
            model: Token.self)
    }
}
