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


public func networking<T: Decodable>(
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
        
        // TODO: - 자동로그인 구현할 때 앱 실행 초기에만 keyChain 불러오기
        let authToken = KeychainManager.read()?.authToken ?? ""
        
        // TODO: 로그인하면 JWT토큰 값 저장하고, 불러오기(없으면 ""로 설정)
        reqeust.setValue(authToken, forHTTPHeaderField: "X-AUTH-TOKEN")
         
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
                    print(error)
                    observer.onError(error)
                }
            }
        
        return Disposables.create()
    }
}


