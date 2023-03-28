//
//  ServiceAPI.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/16.
//

import Alamofire
import RxSwift

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case unknownError
}

fileprivate func networking<T: Decodable>(
    urlStr: String,
    method: HTTPMethod,
    data: Data?,
    model: T.Type) -> Observable<T> {
    
    return Observable<T>.create { observer in

        // TODO: 도메인 생성되면 baseURL로 따로 빼서 정의
        guard let url = URL(string: "아직없음" + urlStr) else {
            observer.onError(NetworkError.invalidURL)
            return Disposables.create()
        }
        
        var reqeust = URLRequest(url: url)
        reqeust.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // TODO: 로그인하면 JWT토큰 값 저장하고, 불러오기(없으면 ""로 설정)
        reqeust.setValue("JWT토큰 값", forHTTPHeaderField: "x-auth-token")
        
        reqeust.httpBody = data
        reqeust.method = method
        
        AF.request(reqeust)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: model.self) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
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
}
