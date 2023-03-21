//
//  BrandDetailReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import ReactorKit
import RxSwift

class BrandDetailReactor: Reactor {
    
    enum Action {
        case didTapBackButton
    }
    
    enum Mutation {
        case setPopVC(Bool)
    }
    
    struct State {
        var section = BrandDetailModel(
            model: .first,
            items: [])
        var brandId: Int = 0
        var title: String = ""
        var isPopVC: Bool = false
    }
    
    var initialState: State
    
    init(_ brandId: Int, _ title: String) {
        initialState = State(section: BrandDetailReactor.requestBrandInfo(brandId),
                             brandId: brandId,
                             title: title)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapBackButton:
            return .concat([
                .just(.setPopVC(true)),
                .just(.setPopVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPopVC(let isPop):
            state.isPopVC = isPop
        }
        
        return state
    }
}


extension BrandDetailReactor {
    
    static func requestBrandInfo(_ brandId: Int) -> BrandDetailModel {
        
        // 해당 브랜드 Id로 서버 통신해서 데이터 받아옴
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
        
        return BrandDetailModel(
            model: .first,
            items: perfumeList.map(BrandDetailSectionItem.perfumeList))
    }
}
