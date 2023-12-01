//
//  DetailViewReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import RxSwift
import ReactorKit

final class DetailViewReactor: Reactor {
    var initialState: State

    enum Action {
        case viewDidLoad(Bool)
        case viewWillAppear
        case didTapBrandView
        case didTapMoreButton
        case didTapWriteButton
        case didTapLikeButton
        case willDisplaySecondSection
        case didTapCommentCell(Int)
        case didTapSimillarCell(Int)
        case didTapOptionButton(Int)
        case didDeleteComment

    }
    
    enum Mutation {
        case setSections([DetailSection])
        case setPresentCommentVC(Int?)
        case setSelectedComment(Comment?)
        case setSelecctedPerfume(Int?)
        case setIsPresentCommentWrite(Int?)
        case setIsLiked(Bool)
        case setCommentCount(Int)
        case setIsPaging(Bool)
        case setIsLogin(Bool)
        case setIsTap(Bool)
        case setPresentBrandId(Int?)
        case setLikeCount(Int?)
        case setSelectedCommentRow(Int)
        case setBrandName(String)
    }
    
    struct State {
        var sections: [DetailSection] = []
        var persentCommentPerfumeId: Int? = nil
        var presentComment: Comment? = nil
        var presentPerfumeId: Int? = nil
        var isPresentCommentWirteVC: Int? = nil
        var presentBrandId: Int? = nil
        var perfumeId: Int
        var isLiked: Bool? = nil
        var commentCount: Int = 0
        var isPaging: Bool = false
        var isLogin: Bool = false
        var isTapWhenNotLogin: Bool = false
        var likeCount: Int? = nil
        var selectedCommentRow: Int? = nil
        var brandName: String = ""
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
        case .didTapLikeButton:
            return setPerfumeLike()
            
        case .willDisplaySecondSection, .didDeleteComment:
            return setUpSecondDetailSections(id: currentState.perfumeId)
            
        case .didTapBrandView:
            return .concat([
                .just(.setPresentBrandId(currentState.sections[0].items[0].brandId)),
                .just(.setPresentBrandId(nil))
            ])
        case .viewWillAppear:
            if currentState.sections.count > 2 {
                return setUpSecondDetailSections(id: currentState.perfumeId)
            } else { return .empty() }
            
        case .didTapCommentCell(let row):
            return .concat([
                .just(.setSelectedComment(currentState.sections[2].items[row].comment!)),
                .just(.setSelectedComment(nil))
            ])
            
        case .didTapSimillarCell(let row):
            return .concat([
                .just(.setSelecctedPerfume(currentState.sections[3].items[row].id)),
                .just(.setSelecctedPerfume(nil))
            ])
            
        case .didTapOptionButton(let row):
            return .just(.setSelectedCommentRow(row))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPresentCommentVC(let perfumeId):
            state.persentCommentPerfumeId = perfumeId
            
        case .setSelectedComment(let comment):
            state.presentComment = comment
            
        case .setSelecctedPerfume(let perfumeId):
            state.presentPerfumeId = perfumeId
            
        case .setIsPresentCommentWrite(let perfumeId):
            state.isPresentCommentWirteVC = perfumeId
            
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
            
        case .setSelectedCommentRow(let row):
            state.selectedCommentRow = row
            
        case .setBrandName(let name):
            state.brandName = name
        }
        
        return state
    }
}

extension DetailViewReactor {
    
    
    func setUpFirstDetailSections(_ id: Int) -> Observable<Mutation> {
        return DetailAPI.fetchPerfumeDetail(id)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                let topItem = DetailSectionItem.topCell(data)
                let topSection = DetailSection.top(topItem)
                
                let evaluation = Evaluation(age: data.evaluation.age,
                                            gender: data.evaluation.gender,
                                            weather: data.evaluation.weather)
                let evaluationItem = DetailSectionItem.evaluationCell(evaluation)
                let evaluationSection = DetailSection.evaluation(evaluationItem)
                
                let sections = [topSection, evaluationSection]
                
                return .concat([
                    .just(.setSections(sections)),
                    .just(.setIsLiked(data.liked)),
                    .just(.setLikeCount(data.heartNum)),
                    .just(.setBrandName(data.brandName))
                ])
            }
    }
    
    func setUpSecondDetailSections(id: Int) -> Observable<Mutation> {
        return DetailAPI.fetchPerfumeDetail2(id)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var sections = self.currentState.sections
                
                var commentItem = data.commentInfo.comments.map { DetailSectionItem.commentCell($0)}
                
                if commentItem.isEmpty {
                    commentItem = [DetailSectionItem.commentCell(nil)]
                }
                let commentSection = DetailSection.comment(commentItem)
                
                let similarItem = data.similarPerfumes.map {
                    DetailSectionItem.similarCell($0)
                }
                let similarSection = DetailSection.similar(similarItem)
        
                if sections.count < 3 {
                    sections.append(contentsOf: [commentSection, similarSection])
                } else {
                    sections[2] = commentSection
                    sections[3] = similarSection
                }
                
                
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
    
    func reactorForCommentEdit() -> CommentWriteReactor {
        return CommentWriteReactor(
            perfumeId: currentState.perfumeId,
            isWrite: true,
            content: currentState.sections[2].items[currentState.selectedCommentRow!].comment!.content,
            commentId: currentState.sections[2].items[currentState.selectedCommentRow!].comment!.id,
            isCommunity: false, commentService: nil)
    }
    
    func reactorForCommentAdd() -> CommentWriteReactor {
        return CommentWriteReactor(
            perfumeId: currentState.perfumeId,
            isWrite: false,
            content: "",
            commentId: nil,
            isCommunity: true,
            commentService: nil,
            communityService: nil)
    }
}
