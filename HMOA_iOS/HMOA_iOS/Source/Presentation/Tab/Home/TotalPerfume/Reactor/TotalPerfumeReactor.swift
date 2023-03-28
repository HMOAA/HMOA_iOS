//
//  TotalPerfumeReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/28.
//

import Foundation
import ReactorKit

class TotalPerfumeReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var section: [TotalPerfumeSection]
    }
    
    var initialState: State
    
    init(_ listType: Int) {
        initialState = State(section: TotalPerfumeReactor.reqeustPerfumeList(listType))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
}

extension TotalPerfumeReactor {
    
    static func reqeustPerfumeList(_ listType: Int) -> [TotalPerfumeSection]{
        
        let perfumeList: [Perfume] = [
            Perfume(
                perfumeId: 1,
                titleName: "조말론",
                content: "우드세이지 앤 씨솔트",
                image: UIImage(named: "jomalon")!,
                isLikePerfume: false),
            Perfume(
                perfumeId: 2,
                titleName: "조말론",
                content: "우드세이지 앤 씨솔트",
                image: UIImage(named: "jomalon")!,
                isLikePerfume: false),
            Perfume(
                perfumeId: 3,
                titleName: "조말론",
                content: "우드세이지 앤 씨솔트",
                image: UIImage(named: "jomalon")!,
                isLikePerfume: false),
            Perfume(
                perfumeId: 4,
                titleName: "조말론",
                content: "우드세이지 앤 씨솔트",
                image: UIImage(named: "jomalon")!,
                isLikePerfume: false),
            Perfume(
                perfumeId: 5,
                titleName: "조말론",
                content: "우드세이지 앤 씨솔트",
                image: UIImage(named: "jomalon")!,
                isLikePerfume: false),
            Perfume(
                perfumeId: 6,
                titleName: "조말론",
                content: "우드세이지 앤 씨솔트",
                image: UIImage(named: "jomalon")!,
                isLikePerfume: false),
            Perfume(
                perfumeId: 7,
                titleName: "조말론",
                content: "우드세이지 앤 씨솔트",
                image: UIImage(named: "jomalon")!,
                isLikePerfume: false)]
        
        return [TotalPerfumeSection.first(perfumeList.map { TotalPerfumeSectionItem.perfumeList($0) })]
    }
}
