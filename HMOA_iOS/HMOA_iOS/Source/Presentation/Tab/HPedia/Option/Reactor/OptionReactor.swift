//
//  OptionReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/09.
//

import RxSwift
import ReactorKit

final class OptionReactor: Reactor {
    
    var initialState: State
    let service: CommunityListProtocol?
    
    enum Action {
        case didTapBackgroundView
        case didTapOptionButton(OptionType)
        case didTapOptionCell(Int)
        case didTapCancleButton
        case didTapOkReportAlert
    }
    
    enum Mutation {
        case setisHiddenOptionView(Bool)
        case setIsTapEdit(Bool)
        case setIsTapDelete(Bool)
        case setCommentData(OptionCommentData)
        case setPostData(OptionPostData)
        case setType(OptionType)
        case setOptions([String])
        case delete
        case setIsTapReport(Bool)
        case setIsReport(Bool)
    }
    
    struct State {
        var options: [String] = []
        var isHiddenOptionView: Bool = true
        var isTapEdit: Bool = false
        var isTapDelete: Bool = false
        var commentData: OptionCommentData? = nil
        var postData: OptionPostData? = nil
        var type: OptionType? = nil
        var category: String = ""
        var isTapReport: Bool = false
        var isReport: Bool = false
    }
    
    init(service: CommunityListProtocol? = nil) {
        initialState = State()
        self.service = service
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackgroundView:
            return .just(.setisHiddenOptionView(true))
            
        case .didTapOptionButton(let type):
            
            switch type {
            case .Post(let postData):
                if postData.isWrited {
                    return .concat([
                        .just(.setOptions(["수정", "삭제"])),
                        .just(.setPostData(postData)),
                        .just(.setisHiddenOptionView(false)),
                        .just(.setType(type))
                    ])
                } else {
                    return .concat([
                        .just(.setOptions(["신고"])),
                        .just(.setPostData(postData)),
                        .just(.setisHiddenOptionView(false)),
                        .just(.setType(type))
                    ])
                }
            case .Comment(let commentData):
                if commentData.isWrited {
                    return .concat([
                        .just(.setOptions(["수정", "삭제"])),
                        .just(.setCommentData(commentData)),
                        .just(.setisHiddenOptionView(false)),
                        .just(.setType(type))
                    ])
                } else {
                    return .concat([
                        .just(.setOptions(["신고"])),
                        .just(.setCommentData(commentData)),
                        .just(.setisHiddenOptionView(false)),
                        .just(.setType(type))
                    ])
                }
            }
            
        case .didTapOptionCell(let item):
            let selectedOption = currentState.options[item]
            switch selectedOption {
            case "수정":
                return .concat([
                    .just(.setisHiddenOptionView(true)),
                    .just(.setIsTapEdit(true)),
                    .just(.setIsTapEdit(false))
                ])
                
            case "삭제":
                switch currentState.type {
                case .Comment(let data):
                    if data.isCommunity {
                        return deleteCommunityComment()
                    } else { return deletePerfumeComment() }
                case .Post(_):
                    return deletePost()
                default: return .empty()
                }
            case "신고":
                return .concat([
                    .just(.setIsTapReport(true)),
                    .just(.setIsTapReport(false))
                ])
                
            default: return .empty()
            }
            
        case .didTapCancleButton:
            return .just(.setisHiddenOptionView(true))
            
        case .didTapOkReportAlert:
            return reportContent()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
            
        case .setisHiddenOptionView(let isHidden):
            state.isHiddenOptionView = isHidden
            
        case .setIsTapEdit(let isTap):
            state.isTapEdit = isTap
        
        case .setIsTapDelete(let isTap):
            state.isTapDelete = isTap
            
        case .setCommentData(let data):
            state.commentData = data
            
        case .setPostData(let data):
            state.postData = data
            
        case .setType(let type):
            state.type = type
            
        case .setOptions(let options):
            state.options = options
            
        case .delete: break
            
        case .setIsTapReport(let isTap):
            state.isTapReport = isTap
            
        case .setIsReport(let isReport):
            state.isReport = isReport
        }
        
        return state
    }
    
    
}

extension OptionReactor {
    
    func deleteCommunityComment() -> Observable<Mutation> {
        return CommunityAPI.deleteCommunityComment(currentState.commentData!.id)
            .catch { _ in .empty() }
            .flatMap { _  -> Observable<Mutation> in
                return .concat([
                    .just(.setisHiddenOptionView(true)),
                    .just(.setIsTapDelete(true)),
                    .just(.setIsTapDelete(false))
                ])
            }
    }
    
    func deletePerfumeComment() -> Observable<Mutation> {
        return CommentAPI.deleteComment(currentState.commentData!.id)
            .catch { _ in .empty() }
            .flatMap { _  -> Observable<Mutation> in
                return .concat([
                    .just(.setisHiddenOptionView(true)),
                    .just(.setIsTapDelete(true)),
                    .just(.setIsTapDelete(false))
                ])
            }
    }
    
    func deletePost() -> Observable<Mutation> {
        return CommunityAPI.deleteCommunityPost(currentState.postData!.id)
            .catch { _ in .empty() }
            .flatMap { _ -> Observable<Mutation> in
                let postData = self.currentState.postData!
                return .concat([
                    .just(.setisHiddenOptionView(true)),
                    .just(.setIsTapDelete(true)),
                    .just(.setIsTapDelete(false)),
                    self.service!.deleteCommunityList(to: CategoryList(
                        communityId: postData.id,
                        category: postData.category,
                        title: postData.title,
                        commentCount: 0,
                        heartCount: 0,
                        liked: false
                    ))
                    .map { _ in .delete }
                ])
            }
    }
    
    func reportContent() -> Observable<Mutation> {
        switch currentState.type {
        case .Comment(let data):
            if data.isCommunity {
                return ReportAPI.reportContent(
                    ["targetId": data.id],
                    .reportCommunityComment)
                .catch { _ in .empty() }
                .flatMap { _ -> Observable<Mutation> in
                        .concat([
                            .just(.setisHiddenOptionView(true)),
                            .just(.setIsReport(true)),
                            .just(.setIsReport(false))
                        ])
                }
            } else {
                return ReportAPI.reportContent(
                    ["targetId": data.id],
                    .reportPerfumeComment)
                .catch { _ in .empty() }
                .flatMap { _ -> Observable<Mutation> in
                        .concat([
                            .just(.setisHiddenOptionView(true)),
                            .just(.setIsReport(true)),
                            .just(.setIsReport(false))
                        ])
                }
            }
        case .Post(let data):
            return ReportAPI.reportContent(
                ["targetId": data.id],
                .reportCommunity)
            .catch { _ in .empty() }
            .flatMap { _ -> Observable<Mutation> in
                    .concat([
                        .just(.setisHiddenOptionView(true)),
                        .just(.setIsReport(true)),
                        .just(.setIsReport(false))
                    ])
            }
            
        default: return .empty()
        }
    }
}
