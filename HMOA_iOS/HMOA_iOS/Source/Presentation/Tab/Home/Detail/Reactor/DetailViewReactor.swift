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
        case viewDidLoad(Bool)
        case didTapBrandView
        case didTapMoreButton
        case didTapWriteButton
        case didTapBackButton
        case didTapHomeButton
        case didTapSearchButton
        case didTapLikeButton
        case willDisplaySecondSection
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
        case setCommentCount(Int)
        case setIsPaging(Bool)
        case setIsLogin(Bool)
        case setIsTap(Bool)
        case setPresentBrandId(Int?)
        case setLikeCount(Int?)
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
        var presentBrandId: Int? = nil
        var perfumeId: Int
        var isLiked: Bool? = nil
        var commentCount: Int = 0
        var isPaging: Bool = false
        var isLogin: Bool = false
        var isTapWhenNotLogin: Bool = false
        var likeCount: Int? = nil
    }
    
    init(perfumeId: Int) {
        self.initialState = State(perfumeId: perfumeId)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad(let isLogin):
            return .concat([
                .just(.setIsLogin(isLogin)),
                setUpFirstDetailSections(currentState.perfumeId)
                ])
        case .didTapMoreButton:
            return .concat([
                .just(.setPresentCommentVC(currentState.perfumeId)),
                .just(.setPresentCommentVC(nil))
            ])
            
        case .didTapWriteButton:
            if currentState.isLogin {
                return .concat([
                    .just(.setIsPresentCommentWrite(currentState.perfumeId)),
                    .just(.setIsPresentCommentWrite(nil))
                ])
            } else {
                return .concat([
                    .just(.setIsTap(true)),
                    .just(.setIsTap(false))
                ])
            }
            
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
            
        case .willDisplaySecondSection:
            return setUpSecondDetailSections(id: currentState.perfumeId)
            
        case .didTapBrandView:
            return .concat([
                .just(.setPresentBrandId(currentState.sections[0].items[0].brandId)),
                .just(.setPresentBrandId(nil))
            ])
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
            
        case .setCommentCount(let count):
            state.commentCount = count
            
        case .setIsPaging(let isPaging):
            state.isPaging = isPaging
            
        case .setIsLogin(let isLogin):
            state.isLogin = isLogin
            
        case .setIsTap(let isTap):
            state.isTapWhenNotLogin = isTap
            
        case .setPresentBrandId(let brandId):
            state.presentBrandId = brandId
            
        case .setLikeCount(let count):
            state.likeCount = count
        }
        
        return state
    }
}

extension DetailViewReactor {
    
    
    func setUpFirstDetailSections(_ id: Int) -> Observable<Mutation> {
        return DetailAPI.fetchPerfumeDetail(id)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                let topItem = DetailSectionItem.topCell(data, 0)
                let topSection = DetailSection.top(topItem)
    
                let evaluationItem = DetailSectionItem.evaluationCell(nil, 1)
                let evaluationSection = DetailSection.evaluation(evaluationItem)
                
                let sections = [topSection, evaluationSection]
                
                return .concat([
                    .just(.setSections(sections)),
                    .just(.setIsLiked(data.perfumeDetail.liked)),
                    .just(.setLikeCount(data.perfumeDetail.heartNum))
                ])
            }
    }
    
    func setUpSecondDetailSections(id: Int) -> Observable<Mutation> {
        return DetailAPI.fetchPerfumeDetail2(id)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var sections = self.currentState.sections
                
                
                let evaluation = Evaluation(age: data.age,
                                            gender: data.gender,
                                            weather: data.weather)
                let evaluationItem = DetailSectionItem.evaluationCell(evaluation, 1)
                let evaluationSection = DetailSection.evaluation(evaluationItem)
                
                sections[1] = evaluationSection
                
                var commentItem = data.commentInfo.comments.map { DetailSectionItem.commentCell($0, 2)}
                
                if commentItem.isEmpty {
                    commentItem = [DetailSectionItem.commentCell(nil, 2)]
                }
                print(commentItem)
                let commentSection = DetailSection.comment(commentItem)
                
                let similarItem = data.similarPerfumes.map {
                    DetailSectionItem.similarCell($0, 3)
                }
                let similarSection = DetailSection.similar(similarItem)
        
                sections.append(contentsOf: [commentSection, similarSection])
                
                
                return .concat([
                    .just(.setSections(sections)),
                    .just(.setCommentCount(data.commentInfo.commentCount)),
                    .just(.setIsPaging(true))
                ])
            }
    }
    
    func setPerfumeLike() -> Observable<Mutation> {
        let state = currentState
        let isLogin = state.isLogin
        
        if isLogin {
            guard let isCurrentlyLiked = state.isLiked else { return .empty() }
            guard let likeCount = state.likeCount else { return .empty() }
            let perfumeId = state.perfumeId
            
            if isCurrentlyLiked {
                return LikeAPI.deleteLike(perfumeId)
                    .catch { _ in .empty() }
                    .flatMap { _ -> Observable<Mutation> in
                        return .concat([
                            .just(.setIsLiked(false)),
                            .just(.setLikeCount(likeCount - 1))
                        ])
                    }
            } else {
                return LikeAPI.putLike(perfumeId)
                    .catch { _ in .empty() }
                    .flatMap { _ -> Observable<Mutation> in
                        return .concat([
                            .just(.setIsLiked(true)),
                            .just(.setLikeCount(likeCount + 1))
                        ])
                    }
            }
        } else {
            return .concat([
                .just(.setIsTap(true)),
                .just(.setIsTap(false))
            ])
        }
    }
}
