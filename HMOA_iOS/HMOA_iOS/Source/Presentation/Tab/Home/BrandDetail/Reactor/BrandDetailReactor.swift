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
        case viewDidLoad
    }
    
    enum Mutation {

        case setPopVC(Bool)
        case setSections([BrandDetailSection])
        case setBrand(Brand)
    }
    
    struct State {
        var section: [BrandDetailSection] = []
        var brand: Brand? = nil
        var isPopVC: Bool = false
        var brandId: Int = 0
    }
    
    var initialState: State
    
    init(_ brandId: Int) {
        let perfumeList = BrandDetailReactor.setUp()
                initialState = State(section: perfumeList,
                                     brandId: brandId)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapBackButton:
            return .concat([
                .just(.setPopVC(true)),
                .just(.setPopVC(false))
            ])
        case .viewDidLoad:
            return requestBrandInfo(currentState.brandId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPopVC(let isPop):
            state.isPopVC = isPop
            
        case .setSections(let section):
            state.section = section
            
        case .setBrand(let brand):
            state.brand = brand
        }
        
        
        return state
    }
}


extension BrandDetailReactor {
    static func setUp() -> [BrandDetailSection] {
        
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
        
        return [BrandDetailSection.first(perfumeList.map { BrandDetailSectionItem.perfumeList($0) })]
    }
    
    func requestBrandInfo(_ brandId: Int) -> Observable<Mutation> {
        BrandAPI.fetchBrandInfo(brandId: brandId)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .just(.setBrand(data.data))
            }
    }
}
