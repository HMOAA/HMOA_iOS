//
//  QnADetailReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import Foundation

import ReactorKit
import RxSwift

class QnADetailReactor: Reactor {
    let initialState: State
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setSections([QnADetailSection])
    }
    
    struct State {
        var sections: [QnADetailSection] = []
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setUpSection()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setSections(let sections):
            state.sections = sections
        }
        
        return state
    }
}

extension QnADetailReactor {
    func setUpSection() -> Observable<Mutation> {
        let commentItems = [
            Comment(content: "test", heartCount: 100,  id: 1, nickname: "test", perfumeId: 1),
            Comment(content: "test", heartCount: 100,  id: 2, nickname: "test", perfumeId: 2),
            Comment(content: "test", heartCount: 100,  id: 3, nickname: "test", perfumeId: 3),
            Comment(content: "test", heartCount: 100,  id: 3, nickname: "test", perfumeId: 4)
        ]
        
        let commentItem = commentItems.map { QnADetailSectionItem.commentCell($0) }
        let commentSection = QnADetailSection.comment(commentItem)
        
        let qnaPostItem = QnADetailSectionItem.qnaPostCell(QnAData(id: 0, nickname: "닉네임입니다", day: 10, title: "여자친구한테 선물할 향수 뭐가 좋을까요?", content: "곧 있으면 여자친구 생일이라 향수를 선물해주고 싶은데, 요즘 20대 여성이 사용할 만한 향수 추천해주세요 가격대는 10~20만원정도로 생각하고 있습니다", profileImageUrl: nil))
        
        let qnaSection = QnADetailSection.qnaPost([qnaPostItem])
        
        return .just(.setSections([qnaSection, commentSection]))
        
    }
}
