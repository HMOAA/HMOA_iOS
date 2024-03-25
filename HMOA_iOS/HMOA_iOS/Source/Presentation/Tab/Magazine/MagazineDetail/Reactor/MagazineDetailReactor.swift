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
        case viewDidLoad
    }
    
    enum Mutation {
        case setInfoItem([MagazineDetailItem])
        case setContentItem([MagazineDetailItem])
        case setTagItem([MagazineDetailItem])
        case setLikeItem([MagazineDetailItem])
    }
    
    struct State {
        var infoItems: [MagazineDetailItem] = []
        var contentItems: [MagazineDetailItem] = []
        var tagItems: [MagazineDetailItem] = []
        var likeItems: [MagazineDetailItem] = []
        var otherMagazineItems: [MagazineDetailItem] = []
        
        var magazineID: Int
    }
    
    let initialState: State
    
    init(_ id: Int) {
        self.initialState = State(magazineID: id)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setUpMagazineDetail()
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
                
                let magazineInfo = MagazineInfo(title: title, releasedDate: releasedDate, viewCount: viewCount)
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
                let likeCount = magazineDetailData.likeCount
                let likeData = MagazineDetailItem.like(MagazineLike(likeCount: likeCount))
                
                return .concat([
                    .just(.setInfoItem([infoData])),
                    .just(.setContentItem(contentsData)),
                    .just(.setTagItem(tagsData)),
                    .just(.setLikeItem([likeData]))
                ])
            }
    }
}
