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
    var currentPerfumeId: Int

    enum Action {
        case didTapMoreButton
        case didTapCell(DetailSectionItem)
        case didTapWriteButton
        case didTapBackButton
        case didTapHomeButton
        case didTapSearchButton
    }
    
    enum Mutation {
        case setPresentCommentVC(Int?)
        case setSelectedComment(Int?)
        case setSelecctedPerfume(Int?)
        case setIsPresentCommentWrite(Int?)
        case setIsPopVC(Bool)
        case setIsPopRootVC(Bool)
        case setIsPresentSearchVC(Bool)
    }
    
    struct State {
        var sections: [DetailSection]
        var persentCommentPerfumeId: Int? = nil
        var presentCommentId: Int? = nil
        var presentPerfumeId: Int? = nil
        var isPresentCommentWirteVC: Int? = nil
        var isPopVC: Bool = false
        var isPopRootVC: Bool = false
        var isPresentSearchVC: Bool = false
    }
    
    init(_ id: Int) {
        self.currentPerfumeId = id
        self.initialState = State(
            sections: DetailViewReactor.setUpSections(currentPerfumeId))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapMoreButton:
            return .concat([
                .just(.setPresentCommentVC(currentPerfumeId)),
                .just(.setPresentCommentVC(nil))
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
        case .didTapWriteButton:
            return .concat([
                .just(.setIsPresentCommentWrite(currentPerfumeId)),
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
        }
        
        return state
    }
}

extension DetailViewReactor {
    static func setUpSections(_ perfumeId: Int) -> [DetailSection] {

        // TODO: perfumeId로 서버와 통신
        print(perfumeId)
        
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
            isLikePerfume: true,
            isLikeBrand: false
        )
        
        let commentItems = [
            Comment(commentId: 1, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false, isWrite: false),
            Comment(commentId: 2, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false, isWrite: false),
            Comment(commentId: 3, name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test", isLike: false, isWrite: false)
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
        
        let topItem = DetailSectionItem.topCell(PerfumeInfoViewReactor(detail: perfumeDetail))
        let topSection = DetailSection.top(topItem)
        
        let commentItem = commentItems.map { DetailSectionItem.commentCell(CommentCellReactor(comment: $0), $0.commentId) }
        
        let commentSections = DetailSection.comment(commentItem)
        
        let recommed = recommendItems.map { DetailSectionItem.recommendCell(HomeCellReactor(perfume: $0), $0.id) }
        let recommendSections = DetailSection.recommend(recommed)
        
        return [topSection, commentSections, recommendSections]
    }
}
