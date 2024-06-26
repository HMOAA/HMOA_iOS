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
        case loadMagazineListNextPage
        case currentPageChanged(Int)
        case didTapMagazineCell(IndexPath)
        case didTapNewPerfuleCell(IndexPath)
        case didTapTopReviewCell(IndexPath)
    }
    
    enum Mutation {
        case setMagazineBannerItem([MagazineItem])
        case setNewPerfumeItem([MagazineItem])
        case setTopReviewItem([MagazineItem])
        case setAllMagazineItem([MagazineItem])
        case setCenteredMagazineImageURL(Int)
        case setSelectedMagazineID(IndexPath?)
        case setSelectedNewPerfumeID(IndexPath?)
        case setSelectedTopReviewID(IndexPath?)
        case setCurrentMagazineListPage(Int)
    }
    
    struct State {
        var mainBannerItems: [MagazineItem] = []
        var newPerfumeItems: [MagazineItem] = []
        var topReviewItems: [MagazineItem] = []
        var allMagazineItems: [MagazineItem] = []
        var centeredMagazineImageURL: String? = nil
        var selectedMagazineID: Int? = nil
        var selectedNewPerfumeID: Int? = nil
        var selectedCommunityID: Int? = nil
        var currentMagazineListPage: Int = 1
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                setUpMagazineBannerList(),
                setUpNewPerfumeList(),
                setUpTopReviewList(),
                setUpALLMagazineList()
            ])
            
        case .loadMagazineListNextPage:
            let nextPage = currentState.currentMagazineListPage + 1
            return .concat([
                setUpALLMagazineList(),
                .just(.setCurrentMagazineListPage(nextPage))
            ])
            
        case .currentPageChanged(let pageIndex):
            return .just(Mutation.setCenteredMagazineImageURL(pageIndex))
            
        case .didTapMagazineCell(let indexPath):
            return .concat([
                .just(.setSelectedMagazineID(indexPath)),
                .just(.setSelectedMagazineID(nil))
            ])
            
        case .didTapNewPerfuleCell(let indexPath):
            return .concat([
                .just(.setSelectedNewPerfumeID(indexPath)),
                .just(.setSelectedNewPerfumeID(nil))
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
            
        case .setNewPerfumeItem(let item):
            state.newPerfumeItems = item
            
        case .setTopReviewItem(let item):
            state.topReviewItems = item
            
        case .setAllMagazineItem(let item):
            state.allMagazineItems += item
            
        case .setCenteredMagazineImageURL(let pageIndex):
            guard !state.mainBannerItems.isEmpty else { return state }
            state.centeredMagazineImageURL = state.mainBannerItems[pageIndex].magazine!.previewImageURL
            
        case .setSelectedMagazineID(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedMagazineID = nil
                return state
            }
            
            let section = indexPath.section == 0 ? currentState.mainBannerItems : currentState.allMagazineItems
            state.selectedMagazineID = section[indexPath.row].magazine?.magazineID
            
        case .setSelectedNewPerfumeID(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedNewPerfumeID = nil
                return state
            }
            state.selectedNewPerfumeID = currentState.newPerfumeItems[indexPath.row].newPerfume?.perfumeID
         
        case .setSelectedTopReviewID(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedCommunityID = nil
                return state
            }
            state.selectedCommunityID = currentState.topReviewItems[indexPath.row].topReview?.communityID
          
        case .setCurrentMagazineListPage(let page):
            state.currentMagazineListPage = page
        }
        return state
    }
}

extension MagazineReactor {
    func setUpMagazineBannerList() -> Observable<Mutation> {
        let query: [String: Any] = ["page": 0]
        
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
    
    func setUpNewPerfumeList() -> Observable<Mutation> {
        return MagazineAPI.fetchNewPerfumeList()
            .catch { _ in .empty() }
            .flatMap { newPerfumeListData -> Observable<Mutation> in
                print(newPerfumeListData)
                let listData = newPerfumeListData
                    .map { newPerfumeData in
                        let newPerfume = NewPerfume(
                            perfumeID: newPerfumeData.perfumeID,
                            name: newPerfumeData.name,
                            brand: newPerfumeData.brand,
                            releaseDate: newPerfumeData.releaseDate,
                            perfumeImageURL: newPerfumeData.perfumeImageURL
                        )
                        return MagazineItem.newPerfume(newPerfume)
                    }
                return .just(.setNewPerfumeItem(listData))
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
    
    func setUpALLMagazineList() -> Observable<Mutation> {
        let query: [String: Any] = ["page": currentState.currentMagazineListPage]
        let nextPage = currentState.currentMagazineListPage + 1
        
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
                return .concat([
                    .just(.setAllMagazineItem(listData)),
                    .just(.setCurrentMagazineListPage(nextPage))
                ])
            }
    }
}
