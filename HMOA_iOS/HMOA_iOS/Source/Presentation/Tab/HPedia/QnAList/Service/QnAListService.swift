//
//  QnAListService.swift
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
}

protocol CommunityListProtocol {
    var event: PublishSubject<CommunityListUserEvent> { get }
    
    func updateCommunityList(to communityList: CategoryList) -> Observable<CategoryList>
    func deleteCommunityList(to communityList: CategoryList) -> Observable<CategoryList>
    func editCommunityList(to communityList: CategoryList) -> Observable<CategoryList>
}

class CommunityListService: CommunityListProtocol {
    func deleteCommunityList(to communityList: CategoryList) -> Observable<CategoryList> {
        event.onNext(.deleteCommunityList(communityList))
        return .just(communityList)
    }
    
    func editCommunityList(to communityList: CategoryList) -> Observable<CategoryList> {
        event.onNext(.editCommunityList(communityList))
        return .just(communityList)
    }
    
    let event = PublishSubject<CommunityListUserEvent>()
    
    func updateCommunityList(to communityList: CategoryList) -> Observable<CategoryList> {
        event.onNext(.addCommunityList(communityList))
        return .just(communityList)
    }
}

