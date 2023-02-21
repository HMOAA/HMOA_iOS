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
    }
    
    enum Mutation {
    }
    
    struct State {
        var sections: [DetailSection]
    }
    
    init() {
        self.initialState = State(
            sections: DetailViewReactor.setUpSections())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
            
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
    
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
            Comment(name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test"),
            Comment(name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test"),
            Comment(name: "test", image: UIImage(named: "jomalon")!, likeCount: 100, content: "test")
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
        
        let commentItem = commentItems.map { DetailSectionItem.commentCell($0) }
        let commentSections = DetailSection.comment(commentItem)
        
        let recommed = recommendItems.map { DetailSectionItem.recommendCell($0) }
        let recommendSections = DetailSection.recommend(recommed)
        
        return [topSection, commentSections, recommendSections]
    }
}
