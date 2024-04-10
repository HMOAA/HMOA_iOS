//
//  MagazineReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2/22/24.
//

import Foundation

import ReactorKit
import RxSwift

class MagazineReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case didTapMagazineCell(IndexPath)
        case didTapTopReviewCell(IndexPath)
    }
    
    enum Mutation {
        case setMagazineBannerItem([MagazineItem])
        case setTopReviewItem([MagazineItem])
        case setSelectedMagazineID(IndexPath?)
        case setSelectedTopReviewID(IndexPath?)
    }
    
    struct State {
        var mainBannerItems: [MagazineItem] = []
        var newPerfumeItems: [MagazineItem] = []
        var topReviewItems: [MagazineItem] = []
        var allMagazineItems: [MagazineItem] = []
        var selectedMagazineID: Int? = nil
        var selectedCommunityID: Int? = nil
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                setUpMagazineList(0),
                setUpTopReviewList()
            ])
            
        case .didTapMagazineCell(let indexPath):
            return .concat([
                .just(.setSelectedMagazineID(indexPath)),
                .just(.setSelectedMagazineID(nil))
            ])
            
        case .didTapTopReviewCell(let indexPath):
            return .concat([
                .just(.setSelectedTopReviewID(indexPath)),
                .just(.setSelectedTopReviewID(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setMagazineBannerItem(let item):
            state.mainBannerItems = item
            
        case .setTopReviewItem(let item):
            state.topReviewItems = item
            
        case .setSelectedMagazineID(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedMagazineID = nil
                return state
            }
            state.selectedMagazineID = currentState.mainBannerItems[indexPath.row].magazine?.magazineID
         
        case .setSelectedTopReviewID(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedCommunityID = nil
                return state
            }
            state.selectedCommunityID = currentState.topReviewItems[indexPath.row].topReview?.communityID
        }
        return state
    }
}

extension MagazineReactor {
    func setUpMagazineList(_ page: Int) -> Observable<Mutation> {
        let query: [String: Any] = ["page": page]
        
        return MagazineAPI.fetchMagazineList(query)
            .catch { _ in .empty() }
            .flatMap { magazineListData -> Observable<Mutation> in
                let listData = magazineListData
                    .map { magazineData in
                        let magazine = Magazine(
                            magazineID: magazineData.magazineID,
                            title: magazineData.title,
                            description: magazineData.description,
                            previewImageURL: magazineData.previewImageURL
                        )
                        return MagazineItem.magazine(magazine)
                    }
                return .just(.setMagazineBannerItem(listData))
            }
    }
    
    func setUpTopReviewList() -> Observable<Mutation> {
        return MagazineAPI.fetchTopReviewList()
            .catch { _ in .empty() }
            .flatMap { topReviewListData -> Observable<Mutation> in
                let listData = topReviewListData
                    .map { topReviewListData in
                        let topReview = TopReview(
                            communityID: topReviewListData.communityID,
                            title: topReviewListData.title,
                            userImageURL: topReviewListData.userImageURL,
                            userName: topReviewListData.userName,
                            content: topReviewListData.content
                        )
                        return MagazineItem.topReview(topReview)
                    }
                return .just(.setTopReviewItem(listData))
            }
    }
}
