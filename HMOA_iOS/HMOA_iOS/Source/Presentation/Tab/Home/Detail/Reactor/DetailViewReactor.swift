//
//  DetailViewReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import RxSwift
import ReactorKit
import RxDataSources

final class DetailViewReactor: Reactor {
    var initialState: State

    enum Action {
        case viewDidLoad
        case didTapMoreButton
        case didTapCell(DetailSectionItem)
        case didTapWriteButton
        case didTapBackButton
        case didTapHomeButton
        case didTapSearchButton
        case didTapLikeButton
    }
    
    enum Mutation {
        case setSections([DetailSection])
        case setPresentCommentVC(Int?)
        case setSelectedComment(Int?)
        case setSelecctedPerfume(Int?)
        case setIsPresentCommentWrite(Int?)
        case setIsPopVC(Bool)
        case setIsPopRootVC(Bool)
        case setIsPresentSearchVC(Bool)
        case setIsLiked(Bool)
    }
    
    struct State {
        var sections: [DetailSection] = []
        var persentCommentPerfumeId: Int? = nil
        var presentCommentId: Int? = nil
        var presentPerfumeId: Int? = nil
        var isPresentCommentWirteVC: Int? = nil
        var isPopVC: Bool = false
        var isPopRootVC: Bool = false
        var isPresentSearchVC: Bool = false
        var perfumeId: Int
        var isLiked: Bool = false
    }
    
    init(perfumeId: Int) {
        self.initialState = State(perfumeId: perfumeId)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setUpSections(currentState.perfumeId)
        case .didTapMoreButton:
            return .concat([
                .just(.setPresentCommentVC(currentState.perfumeId)),
                .just(.setPresentCommentVC(nil))
            ])
        case .didTapCell(let item):
            
            if item.section == 2 {
                return .concat([
                    .just(.setSelectedComment(item.id)),
                    .just(.setSelectedComment(nil))
                ])
            } else {
                return .concat([
                    .just(.setSelecctedPerfume(item.id)),
                    .just(.setSelecctedPerfume(nil))
                ])
            }
        case .didTapWriteButton:
            return .concat([
                .just(.setIsPresentCommentWrite(currentState.perfumeId)),
                .just(.setIsPresentCommentWrite(nil))
            ])
            
        case .didTapBackButton:
            return .concat([
                .just(.setIsPopVC(true)),
                .just(.setIsPopVC(false))
            ])
            
        case .didTapHomeButton:
            return .concat([
                .just(.setIsPopRootVC(true)),
                .just(.setIsPopRootVC(false))
            ])
        
        case .didTapSearchButton:
            return .concat([
                .just(.setIsPresentSearchVC(true)),
                .just(.setIsPresentSearchVC(false))
            ])
        case .didTapLikeButton:
            return setPerfumeLike()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPresentCommentVC(let perfumeId):
            state.persentCommentPerfumeId = perfumeId
            
        case .setSelectedComment(let commentId):
            state.presentCommentId = commentId
            
        case .setSelecctedPerfume(let perfumeId):
            state.presentPerfumeId = perfumeId
            
        case .setIsPresentCommentWrite(let perfumeId):
            state.isPresentCommentWirteVC = perfumeId
       
        case .setIsPopVC(let isPop):
            state.isPopVC = isPop
            
        case .setIsPopRootVC(let isPop):
            state.isPopRootVC = isPop
            
        case .setIsPresentSearchVC(let isPresent):
            state.isPresentSearchVC = isPresent
            
        case .setSections(let sections):
            state.sections = sections
            
        case .setIsLiked(let isLiked):
            state.isLiked = isLiked
        }
        
        return state
    }
}

extension DetailViewReactor {
    
    
    func setUpSections(_ id: Int) -> Observable<Mutation> {

        let commentItems = [
            Comment(content: "test", heartCount: 100,  id: 1, nickname: "test", perfumeId: currentState.perfumeId),
            Comment(content: "test", heartCount: 100,  id: 2, nickname: "test", perfumeId: currentState.perfumeId),
            Comment(content: "test", heartCount: 100,  id: 3, nickname: "test", perfumeId: currentState.perfumeId)
        ]
        
        let recommendItems = [
            RecommendPerfume(id: 1, brandName: "조 말론 런던", perfumeName: "우드 세이지 엔 씨 쏠트 코롱 100ml", imageUrl: ""),
            RecommendPerfume(id: 2, brandName: "조 말론 런던", perfumeName: "우드 세이지 엔 씨 쏠트 코롱 100ml", imageUrl: ""),
            RecommendPerfume(id: 3, brandName: "조 말론 런던", perfumeName: "우드 세이지 엔 씨 쏠트 코롱 100ml", imageUrl: ""),
            RecommendPerfume(id: 4, brandName: "조 말론 런던", perfumeName: "우드 세이지 엔 씨 쏠트 코롱 100ml", imageUrl: ""),
            RecommendPerfume(id: 5, brandName: "조 말론 런던", perfumeName: "우드 세이지 엔 씨 쏠트 코롱 100ml", imageUrl: ""),
            RecommendPerfume(id: 6, brandName: "조 말론 런던", perfumeName: "우드 세이지 엔 씨 쏠트 코롱 100ml", imageUrl: ""),
            RecommendPerfume(id: 7, brandName: "조 말론 런던", perfumeName: "우드 세이지 엔 씨 쏠트 코롱 100ml", imageUrl: ""),
            RecommendPerfume(id: 8, brandName: "조 말론 런던", perfumeName: "우드 세이지 엔 씨 쏠트 코롱 100ml", imageUrl: ""),
            RecommendPerfume(id: 9, brandName: "조 말론 런던", perfumeName: "우드 세이지 엔 씨 쏠트 코롱 100ml", imageUrl: "")
        ]
        
        let evaluationSection = DetailSection.evaluation(DetailSectionItem.evaluationCell(1))
        
        let commentItem = commentItems.map { DetailSectionItem.commentCell($0, $0.id) }
        
        let commentSections = DetailSection.comment(commentItem)
        
        let recommed = recommendItems.map { DetailSectionItem.recommendCell($0, $0.id) }
        let recommendSections = DetailSection.recommend(recommed)
        
        return DetailAPI.fetchPerfumeDetail(id)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                print(data)
                let topItem = DetailSectionItem.topCell(data, 0)
                let topSection = DetailSection.top(topItem)
                
                let sections = [topSection, evaluationSection, commentSections, recommendSections]
                
                return .just(.setSections(sections))
            }
        
        
        
    }
    
    func setPerfumeLike() -> Observable<Mutation> {
        let state = currentState
        let isCurrentlyLiked = state.isLiked
        let perfumeId = state.perfumeId
        
        if isCurrentlyLiked {
            return LikeAPI.deleteLike(perfumeId)
                .catch { _ in .empty() }
                .flatMap { _ -> Observable<Mutation> in
                    return .just(.setIsLiked(false))
                }
        } else {
            return LikeAPI.putLike(perfumeId)
                .catch { _ in .empty() }
                .flatMap { _ -> Observable<Mutation> in
                    return .just(.setIsLiked(true))
                }
        }
    }
}
