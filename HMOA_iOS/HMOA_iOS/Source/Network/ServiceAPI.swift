//
//  ServiceAPI.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/16.
//

import Alamofire
import GoogleSignIn
import RxSwift

enum NetworkError: Error {
    case invalidParameters
    case invalidURL
    case invalidResponse
    case decodingError
    case unknownError
    case statusCodeMoreThan400(String, String)
}


fileprivate func networking<T: Decodable>(
    urlStr: String,
    method: HTTPMethod,
    data: Data?,
    model: T.Type) -> Observable<T> {
    
    return Observable<T>.create { observer in
        
        let loginManager = LoginManager.shared

        // TODO: 도메인 생성되면 baseURL로 따로 빼서 정의
        guard let url = URL(string: baseURL.url + urlStr) else {
            observer.onError(NetworkError.invalidURL)
            return Disposables.create()
        }
        var reqeust = URLRequest(url: url)
        reqeust.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // TODO: 로그인하면 JWT토큰 값 저장하고, 불러오기(없으면 ""로 설정)
        reqeust.setValue(loginManager.googleToken?.authToken, forHTTPHeaderField: "X-AUTH-TOKEN")
        
        reqeust.httpBody = data
        reqeust.method = method

        AF.request(reqeust)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: model.self) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 409
                    {
                        observer.onNext(true as! T)
                    } else {
                        observer.onError(error)
                    }
                }
            }
        
        return Disposables.create()
    }
}

final class API {
    
    /// 향수 한 개 받아오기
    static func getPerfumeOne(perfumeId: Int) -> Observable<Object> {
        
        return networking(
            urlStr: Address.perfumeOne(perfumeId).url,
            method: .get,
            data: nil,
            model: Object.self)
    }
    
    static func postPerfumeLike(perfumeId: Int) -> Observable<String> {
        
        return networking(
            urlStr: Address.perfumeOne(perfumeId).url,
            method: .post,
            data: nil,
            model: String.self)
        
    }
    
    //googleToken 보내기
    static func postAccessToken(params: [String: String]) -> Observable<GoogleToken> {
        
        guard let data = try? JSONSerialization.data(
                    withJSONObject: params,
                    options: .prettyPrinted)
                
        else { return Observable.error(NetworkError.invalidParameters)}
        
        return networking(
            urlStr: Address.postToken.url,
            method: .post,
            data: data,
            model: GoogleToken.self)
        
    }
    
    //닉네임 중복 검사
    static func checkDuplicateNickname(params: [String: String]) -> Observable<Bool> {
        
        guard let data = try? JSONSerialization.data(withJSONObject: params)
        else { return Observable.error(NetworkError.invalidParameters) }

        
        return networking(
            urlStr: Address.checkNickname.url,
            method: .post,
            data: data,
            model: Bool.self)
    }
    
    //닉네임 업데이트
    static func updateNickname(params: [String: String]) -> Observable<Response> {
        
        guard let data = try? JSONSerialization.data(withJSONObject: params)
        else { return Observable.error(NetworkError.invalidParameters) }
        
        return networking(
            urlStr: Address.patchNickname.url,
            method: .patch,
            data: data,
            model: Response.self)
    }
    
    static func updateSex(params: [String: String]) -> Observable<Response> {
        guard let data = try? JSONSerialization.data(withJSONObject: params)
        else { return Observable.error(NetworkError.invalidParameters) }
        
        return networking(
            urlStr: Address.patchSex.url,
            method: .patch,
            data: data,
            model: Response.self)
    }
    
    static func updateAge(params: [String: Int]) -> Observable<Response> {
        guard let data = try? JSONSerialization.data(withJSONObject: params)
        else { return Observable.error(NetworkError.invalidParameters) }
        
        return networking(
            urlStr: Address.patchAge.url,
            method: .patch,
            data: data,
            model: Response.self)
    }
    
    static func join(params: [String: Any]) -> Observable<JoinResponse> {
        guard let data = try? JSONSerialization.data(withJSONObject: params)
        else { return Observable.error(NetworkError.invalidParameters) }
        
        return networking(
            urlStr: Address.patchJoin.url,
            method: .patch,
            data: data,
            model: JoinResponse.self)
    }
}
