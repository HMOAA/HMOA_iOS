//
//  MemberAPI.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/04.
//

import Foundation
import RxSwift
import UIKit
import KakaoSDKTalk
import RxKakaoSDKTalk
import KakaoSDKUser
import RxKakaoSDKUser

final class MemberAPI {

    /// 멤버 단일 정보 가져오기
    static func getMember() -> Observable<Member?> {

        return networking(
            urlStr: MemberAddress.member.url,
            method: .get,
            data: nil,
            model: Member.self)
        .map { result in
            return result
        }
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
    
    /// 이미지 업로드
    static func uploadImage(image: UIImage) -> Observable<Response> {
        
        guard let data = image.resize(targetSize: image.size)?.jpegData(compressionQuality: 0.1) else {
            return Observable.error(NetworkError.invalidParameters)}
        
        return uploadNetworking(
            urlStr: MemberAddress.uploadImage.url,
            method: .post,
            imageData: [data],
            imageFileName: "profileImage.jpeg",
            parameter: nil,
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
    
    
    /// 좋아요한 향수 댓글 불러오기
    /// - Parameter query: [Page: Int]
    static func fetchLikedPerfumeComments(_ query: [String: Int]) -> Observable<[MyLogComment]> {
        return networking(
            urlStr: MemberAddress.fetchLikedPerfumeComment.url,
            method: .get,
            data: nil,
            model: [MyLogComment].self,
            query: query
        )
    }
    
    /// 좋아요한 커뮤니티 댓글 불러오기
    /// - Parameter query: [Page: Int]
    static func fetchLikedCommunityComments(_ query: [String: Int]) -> Observable<[MyLogComment]> {
        return networking(
            urlStr: MemberAddress.fetchLikedCommunityComment.url,
            method: .get,
            data: nil,
            model: [MyLogComment].self,
            query: query
        )
    }
    
    /// 작성한 향수 댓글 불러오기
    /// - Parameter query: [Page: Int]
    static func fetchPerfumeComments(_ query: [String: Int]) -> Observable<[MyLogComment]> {
        return networking(
            urlStr: MemberAddress.fetchPerfumeComment.url,
            method: .get,
            data: nil,
            model: [MyLogComment].self,
            query: query
        )
    }
    
    /// 작성한 커뮤니티 댓글 불러오기
    /// - Parameter query: [Page: Int]
    static func fetchCommunityComments(_ query: [String: Int]) -> Observable<[MyLogComment]> {
        return networking(
            urlStr: MemberAddress.fetchCommunityComment.url,
            method: .get,
            data: nil,
            model: [MyLogComment].self,
            query: query
        )
    }
    
    static func deleteMember() -> Observable<Response> {
        return networking(
            urlStr: MemberAddress.deleteMember.url,
            method: .delete,
            data: nil,
            model: Response.self)
    }
    
    static func fetchWritedPosts(_ query: [String: Int]) -> Observable<[CategoryList]> {
        return networking(
            urlStr: MemberAddress.fetchWritedPost.url,
            method: .get,
            data: nil,
            model: [CategoryList].self,
            query: query)
    }
    
    static func kakaoTalkAddChannel() -> Observable<Bool> {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return Observable.create { observer in
                TalkApi.shared.rx.addChannel(channelPublicId: "_VxmaGG")
                    .subscribe(
                        onCompleted: {
                            observer.onNext(true)
                            observer.onCompleted()
                        },
                        onError: { error in
                            observer.onError(error)
                        }
                    )
            }
        } else {
            return .just(false)
        }
    }
}
