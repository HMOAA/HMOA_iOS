//
//  MagazineDetailReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/4/24.
//

import Foundation

import ReactorKit
import RxSwift

class MagazineDetailReactor: Reactor {
    
    enum Action {
        case viewDidLoad(Bool)
        case didTapLikeButton
    }
    
    enum Mutation {
        case setInfoItem([MagazineDetailItem])
        case setContentItem([MagazineDetailItem])
        case setTagItem([MagazineDetailItem])
        case setLikeItem([MagazineDetailItem])
        
        case setIsLogin(Bool)
        case setMagazineLike(Bool)
        case setMagazineLikeCount(Int)
        case setIsTap(Bool)
    }
    
    struct State {
        var infoItems: [MagazineDetailItem] = []
        var contentItems: [MagazineDetailItem] = []
        var tagItems: [MagazineDetailItem] = []
        var likeItems: [MagazineDetailItem] = []
        var otherMagazineItems: [MagazineDetailItem] = []
        
        var magazineID: Int
        var isLogin: Bool = false
        var isLiked: Bool = true
        var likeCount: Int? = nil
        var isTapWhenNotLogin: Bool = false
    }
    
    let initialState: State
    
    init(_ id: Int) {
        self.initialState = State(magazineID: id)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad(let isLogin):
            return .concat([
                setUpMagazineDetail(),
                .just(.setIsLogin(isLogin))
            ])
        case .didTapLikeButton:
            return setMagazineLike()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setInfoItem(let item):
            state.infoItems = item

        case .setContentItem(let item):
            state.contentItems = item
            
        case .setTagItem(let item):
            state.tagItems = item
            
        case .setLikeItem(let item):
            state.likeItems = item
            
        case .setIsLogin(let isLogin):
            state.isLogin = isLogin
            
        case .setMagazineLike(let isLiked):
            state.isLiked = isLiked
            
        case .setMagazineLikeCount(let count):
            state.likeCount = count
            
        case .setIsTap(let isTap):
            state.isTapWhenNotLogin = isTap
        }
        return state
    }
}

extension MagazineDetailReactor {
    func setUpMagazineDetail() -> Observable<Mutation> {
        return MagazineAPI.fetchMagazineDetail(currentState.magazineID)
            .catch { _ in .empty() }
            .flatMap { magazineDetailData -> Observable<Mutation> in
                
                // info section item
                let title = magazineDetailData.title
                let releasedDate = magazineDetailData.releasedDate
                let viewCount = magazineDetailData.viewCount
                let previewImage = magazineDetailData.previewImage
                let description = magazineDetailData.description
                
                let magazineInfo = MagazineInfo(title: title, releasedDate: releasedDate, viewCount: viewCount, previewImageURL: previewImage, description: description)
                let infoData = MagazineDetailItem.info(magazineInfo)
                
                // magazineContents section item
                let magazineContents = magazineDetailData.contents // [MagazineContent]
                let contentsData = magazineContents.map {
                    let content = MagazineContent(type: $0.type, data: $0.data)
                    return MagazineDetailItem.magazineContent(content)
                }
                
                // tag section item
                let magazineTags = magazineDetailData.tags
                let tagsData = magazineTags.map {
                    let tag = MagazineTag(tag: $0)
                    return MagazineDetailItem.magazineTag(tag)
                }
                
                // like section item
                let magazineID = magazineDetailData.magazineID
                let isLiked = magazineDetailData.liked
                let likeCount = magazineDetailData.likeCount
                let likeData = MagazineDetailItem.like(MagazineLike(id: magazineID ,isLiked: isLiked ,likeCount: likeCount))
                
                return .concat([
                    .just(.setInfoItem([infoData])),
                    .just(.setContentItem(contentsData)),
                    .just(.setTagItem(tagsData)),
                    .just(.setLikeItem([likeData])),
                    .just(.setMagazineLike(isLiked)),
                    .just(.setMagazineLikeCount(likeCount))
                ])
            }
    }
    
    func setMagazineLike() -> Observable<Mutation> {
        var magazineLike = currentState.likeItems.first!.like!
        
        guard currentState.isLogin else {
            return .concat([
                .just(.setIsTap(true)),
                .just(.setIsTap(false))
            ]) }
        
        if !currentState.isLiked {
            return MagazineAPI.putMagazineLike(id: magazineLike.id)
                .catch { _ in .empty() }
                .flatMap { _ -> Observable<Mutation> in
                    magazineLike.isLiked = true
                    magazineLike.likeCount = self.currentState.likeCount! + 1
                    
                    return .concat([
                        .just(.setMagazineLike(true)),
                        .just(.setMagazineLikeCount(magazineLike.likeCount))
                    ])
                }
        } else {
            return MagazineAPI.deleteMagazineLike(id: currentState.magazineID)
                .catch { _ in .empty() }
                .flatMap { _ -> Observable<Mutation> in
                    magazineLike.isLiked = false
                    magazineLike.likeCount = self.currentState.likeCount! - 1
                    
                    return .concat([
                        .just(.setMagazineLike(false)),
                        .just(.setMagazineLikeCount(magazineLike.likeCount))
                    ])
                }
        }
    }
}
