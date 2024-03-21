//
//  MagazineDetailReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/4/24.
//

import Foundation

import ReactorKit
import RxSwift

class MagazineDetailReactor: Reactor {
    
    enum Action {
        // TODO: viewDidLoad case 작성 후 각 섹션 setUp method 호출
        case viewDidLoad
    }
    
    enum Mutation {
        case setInfoItem(MagazineDetailItem)
    }
    
    struct State {
        var infoItems: [MagazineDetailItem] = []
        var contentItems: [MagazineDetailItem] = []
        var likeItems: [MagazineDetailItem] = []
        var otherMagazineItems: [MagazineDetailItem] = []
        
        var magazineID: Int
    }
    
    let initialState: State
    
    init(_ id: Int) {
        self.initialState = State(magazineID: id)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                setUpMagazineInfoSection()
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setInfoItem(let item):
            state.infoItems.append(item)
            
        }
        return state
    }
}

extension MagazineDetailReactor {
    func setUpMagazineInfoSection() -> Observable<Mutation> {
        return MagazineAPI.fetchMagazineDetail(currentState.magazineID)
            .catch { _ in .empty() }
            .flatMap { magazineDetailData -> Observable<Mutation> in
                
                let title = magazineDetailData.title
                let releasedDate = magazineDetailData.releasedDate
                let viewCount = magazineDetailData.viewCount
                let infoData = MagazineInfo(title: title, releasedDate: releasedDate, viewCount: viewCount)
                
                return .concat([
                    .just(.setInfoItem(.info(infoData)))
                ])
            }
    }
}
