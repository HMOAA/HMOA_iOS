//
//  CommunityListService.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/23.
//

import Foundation
import RxSwift

enum CommunityListUserEvent {
    case addCommunityList(CategoryList)
    case deleteCommunityList(CategoryList)
    case editCommunityList(CategoryList)
    case editCommunityComment(CommunityComment)
    case editCommunityDetail(CommunityDetail)
    case updateCommunityPostLike(CategoryList)
}

protocol CommunityListProtocol {
    var event: PublishSubject<CommunityListUserEvent> { get }
    
    func updateCommunityList(to communityList: CategoryList) -> Observable<CategoryList>
    
    func deleteCommunityList(to communityList: CategoryList) -> Observable<CategoryList>
    
    func editCommunityList(to communityList: CategoryList) -> Observable<CategoryList>
    
    func editCommunityComment(to comment: CommunityComment) -> Observable<CommunityComment>
    
    func editCommunityDetail(to detail: CommunityDetail) -> Observable<CommunityDetail>
    
    func updateCommunityPostLike(to communityList: CategoryList) -> Observable<CategoryList>
    
}

class CommunityListService: CommunityListProtocol {

    let event = PublishSubject<CommunityListUserEvent>()
    
    func editCommunityDetail(to detail: CommunityDetail) -> Observable<CommunityDetail> {
        event.onNext(.editCommunityDetail(detail))
        return .just(detail)
    }
    
    func editCommunityComment(to comment: CommunityComment) -> Observable<CommunityComment> {
        event.onNext(.editCommunityComment(comment))
        return .just(comment)
    }
    
    func deleteCommunityList(to communityList: CategoryList) -> Observable<CategoryList> {
        event.onNext(.deleteCommunityList(communityList))
        return .just(communityList)
    }
    
    func editCommunityList(to communityList: CategoryList) -> Observable<CategoryList> {
        event.onNext(.editCommunityList(communityList))
        return .just(communityList)
    }
    
    func updateCommunityList(to communityList: CategoryList) -> Observable<CategoryList> {
        event.onNext(.addCommunityList(communityList))
        return .just(communityList)
    }
    
    func updateCommunityPostLike(to communityList: CategoryList) -> Observable<CategoryList> {
        event.onNext(.updateCommunityPostLike(communityList))
        return .just(communityList)
    }
}

