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
        case didTapMoreButton
        case didTapCell(DetailSectionItem)
    }
    
    enum Mutation {
        case setPresentCommentVC(Bool)
        case setSelectedComment(Int?)
        case setSelecctedPerfume(Int?)
    }
    
    struct State {
        var sections: [DetailSection]
        var isPresentCommetVC: Bool = false
        var presentCommentId: Int? = nil
        var presentPerfumeId: Int? = nil
    }
    
    init() {
        self.initialState = State(
            sections: DetailViewReactor.setUpSections())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapMoreButton:
            return .concat([
                .just(.setPresentCommentVC(true)),
                .just(.setPresentCommentVC(false))
            ])
        case .didTapCell(let item):
            
            if item.section == 1 {
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPresentCommentVC(let isPresent):
            state.isPresentCommetVC = isPresent
            
        case .setSelectedComment(let commentId):
            state.presentCommentId = commentId
            
        case .setSelecctedPerfume(let perfumeId):
            state.presentPerfumeId = perfumeId
        }
        
        return state
    }
}

extension DetailViewReactor {
    static func setUpSections() -> [DetailSection] {

        let perfumeDetail = PerfumeDetail(
            perfumeId: 5,
            perfumeImage: UIImage(named: "jomalon")!,
            likeCount: 5,
            koreanName: "test",
            englishName: "test",
            category: ["test"],
            price: 1000,
            volume: [10, 20],
            age: 20,
            gender: "여성",
            BrandImage: UIImage(named: "jomalon")!,
            productInfo: "test",
            topTasting: "test",
            heartTasting: "test",
            baseTasting: "test",
            isLikePerfume: false,
            isLikeBrand: false
        )
        
        let commentItems = [
            Comment(commentId: 1, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 2, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false),
            Comment(commentId: 3, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false)
        ]
        
        let recommendItems = [
            Perfume(perfumeId: 1, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!),
            Perfume(perfumeId: 2, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!),
            Perfume(perfumeId: 3, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!),
            Perfume(perfumeId: 4, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!),
            Perfume(perfumeId: 5, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!),
            Perfume(perfumeId: 6, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!),
            Perfume(perfumeId: 7, titleName: "조 말론 런던", content: "우드 세이지 엔 씨 쏠트 코롱 100ml", image: UIImage(named: "jomalon")!)
        ]
        
        let topItem = DetailSectionItem.topCell(PerfumeDetailReactor(detail: perfumeDetail))
        let topSection = DetailSection.top(topItem)
        
        let commentItem = commentItems.map { DetailSectionItem.commentCell(CommentReactor(comment: $0), $0.commentId) }
        
        let commentSections = DetailSection.comment(commentItem)
        
        let recommed = recommendItems.map { DetailSectionItem.recommendCell($0, $0.perfumeId) }
        let recommendSections = DetailSection.recommend(recommed)
        
        return [topSection, commentSections, recommendSections]
    }
}
