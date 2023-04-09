//
//  HPediaReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

import ReactorKit
import RxCocoa

class HPediaReactor: Reactor {
    var initialState: State
    
    enum Action {
        
    }
    
    struct State {
        var sections: [HPediaSection]
    }
    
    enum Mutation {
        
    }
    
    init() {
        initialState = State(sections: HPediaReactor.setUpSections())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
}

extension HPediaReactor {
    
    static func setUpSections() -> [HPediaSection] {
        let guides = HPediaGuideData.list
        let tags = HPediaTagData.list
        
        let guideItem = guides.map {
            HPediaSectionItem
                .guideCell(HPediaGuideCellReactor(guide: $0), $0.id)
        }
        
        let guideSection = HPediaSection.guide(guideItem)
        
        let tagItem = tags.map {
            HPediaSectionItem.tagCell(HPediaTagCellReactor(tag: $0), $0.id)
        }
        
        let tagSection = HPediaSection.tag(tagItem)
        
        
        
        return [guideSection, tagSection]
    }
}
