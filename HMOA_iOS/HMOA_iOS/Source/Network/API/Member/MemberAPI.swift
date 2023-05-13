//
//  MemberAPI.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/04.
//

import Foundation
import RxSwift


final class MemberAPI {

    /// 멤버 단일 정보 가져오기
    static func getMember() -> Observable<Member> {

        return networking(
            urlStr: MemberAddress.member.url,
            method: .get,
            data: nil,
            model: Member.self)
    }
    
    ///닉네임 중복 검사
    static func checkDuplicateNickname(params: [String: String]) -> Observable<Bool> {
        
        guard let data = try? JSONSerialization.data(withJSONObject: params)
        else { return Observable.error(NetworkError.invalidParameters) }

        
        return networking(
            urlStr: MemberAddress.checkNickname.url,
            method: .post,
            data: data,
            model: Bool.self)
        .map { result -> Bool in
            return result
        }
        .catch { error -> Observable<Bool> in
            if let statusCode = error.asAFError?.responseCode, statusCode == 409 {
                return Observable.just(true)
            }
            return Observable.error(error)
        }
    }
    
    /// 닉네임 업데이트
    static func updateNickname(params: [String: String]) -> Observable<Response> {
        
        guard let data = try? JSONSerialization.data(withJSONObject: params)
        else { return Observable.error(NetworkError.invalidParameters) }
        return networking(
            urlStr: MemberAddress.patchNickname.url,
            method: .patch,
            data: data,
            model: Response.self)
    }
    
    /// 성별 업데이트
    static func updateSex(params: [String: Bool]) -> Observable<Response> {
        guard let data = try? JSONSerialization.data(withJSONObject: params)
        else { return Observable.error(NetworkError.invalidParameters) }
        
        return networking(
            urlStr: MemberAddress.patchSex.url,
            method: .patch,
            data: data,
            model: Response.self)
    }
    
    /// 나이 업데이트
    static func updateAge(params: [String: Int]) -> Observable<Response> {
        guard let data = try? JSONSerialization.data(withJSONObject: params)
        else { return Observable.error(NetworkError.invalidParameters) }
        
        return networking(
            urlStr: MemberAddress.patchAge.url,
            method: .patch,
            data: data,
            model: Response.self)
    }
    
    static func join(params: [String: Any]) -> Observable<JoinResponse> {
        guard let data = try? JSONSerialization.data(withJSONObject: params)
        else { return Observable.error(NetworkError.invalidParameters) }
        
        return networking(
            urlStr: MemberAddress.patchJoin.url,
            method: .patch,
            data: data,
            model: JoinResponse.self)
    }
    
}
