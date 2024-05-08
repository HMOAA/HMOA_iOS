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
    case updateCommunityList(CategoryList)
    case updateCommunityComment(CommunityComment)
    case editCommunityDetail(CommunityDetail)
    case deleteComment(Int)
}

protocol CommunityListProtocol {
    var event: PublishSubject<CommunityListUserEvent> { get }
    
    func updateCommunityList(to communityList: CategoryList) -> Observable<CategoryList>
    
    func deleteCommunityList(to communityList: CategoryList) -> Observable<CategoryList>
    
    func addCommunityList(to communityList: CategoryList) -> Observable<CategoryList>
    
    func updateCommunityComment(to comment: CommunityComment) -> Observable<CommunityComment>
    
    func editCommunityDetail(to detail: CommunityDetail) -> Observable<CommunityDetail>
    
    func deleteComment(to id: Int) -> Observable<Int>
    
}

class CommunityListService: CommunityListProtocol {

    let event = PublishSubject<CommunityListUserEvent>()
    
    func editCommunityDetail(to detail: CommunityDetail) -> Observable<CommunityDetail> {
        event.onNext(.editCommunityDetail(detail))
        return .just(detail)
    }
    
    func updateCommunityComment(to comment: CommunityComment) -> Observable<CommunityComment> {
        event.onNext(.updateCommunityComment(comment))
        return .just(comment)
    }
    
    func deleteCommunityList(to communityList: CategoryList) -> Observable<CategoryList> {
        event.onNext(.deleteCommunityList(communityList))
        return .just(communityList)
    }
    
    func updateCommunityList(to communityList: CategoryList) -> Observable<CategoryList> {
        event.onNext(.updateCommunityList(communityList))
        return .just(communityList)
    }
    
    func addCommunityList(to communityList: CategoryList) -> Observable<CategoryList> {
        event.onNext(.addCommunityList(communityList))
        return .just(communityList)
    }
    
    func deleteComment(to id: Int) -> Observable<Int> {
        event.onNext(.deleteComment(id))
        return .just(id)
    }
}

