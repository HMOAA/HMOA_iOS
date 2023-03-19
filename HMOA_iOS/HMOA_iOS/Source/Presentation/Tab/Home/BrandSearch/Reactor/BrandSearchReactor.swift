//
//  BrandSearchReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/16.
//

import ReactorKit
import RxSwift

class BrandSearchReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case viewDidLoad
        case didTapBackButton
        case didTapItem(Brand)
    }
    
    enum Mutation {
        case setIsPopVC(Bool)
        case setBrandList([BrandList])
        case setSelectedItem(Brand?)
    }
    
    struct State {
        var isPopVC: Bool = false
        var firstSection = BrandSectionModel(
            model: .first,
            items: [])
        var secondSection = BrandSectionModel(
            model: .second,
            items: [])
        var thridSection = BrandSectionModel(
            model: .third,
            items: [])
        var fourthSection = BrandSectionModel(
            model: .fourth,
            items: [])
        var fiveSection = BrandSectionModel(
            model: .five,
            items: [])
        var selectedItem: Brand? = nil
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapBackButton:
            return .concat([
                .just(.setIsPopVC(true)),
                .just(.setIsPopVC(false))
            ])
            
        case .viewDidLoad:
            return reqeustBrandList()
            
        case .didTapItem(let brand):
            return .concat([
                .just(.setSelectedItem(brand)),
                .just(.setSelectedItem(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsPopVC(let isPop):
            state.isPopVC = isPop
            
        case .setBrandList(let list):
            
            state.firstSection = BrandSectionModel(
                model: .first,
                items: list[0].brands.map(BrandCell.BrandItem))
                
            state.secondSection = BrandSectionModel(
                model: .first,
                items: list[1].brands.map(BrandCell.BrandItem))
                
            state.thridSection = BrandSectionModel(
                model: .first,
                items: list[2].brands.map(BrandCell.BrandItem))
                    
            state.fourthSection = BrandSectionModel(
                model: .first,
                items: list[3].brands.map(BrandCell.BrandItem))
            
            state.fiveSection = BrandSectionModel(
                model: .five,
                items: list[4].brands.map(BrandCell.BrandItem))
            
        case .setSelectedItem(let brand):
        
            state.selectedItem = brand
        }
        
        return state
    }
}

extension BrandSearchReactor {
    
    func reqeustBrandList() -> Observable<Mutation>{
        
        let data: [BrandList] = [
            BrandList(consonant: "ㄱ", brands: [
                Brand(brandId: 1, brandName: "가"),
                Brand(brandId: 2, brandName: "가"),
                Brand(brandId: 3, brandName: "가"),
                Brand(brandId: 4, brandName: "가"),
                Brand(brandId: 5, brandName: "가")
            ]),
            
            BrandList(consonant: "ㄴ", brands: [
                Brand(brandId: 6, brandName: "나"),
                Brand(brandId: 7, brandName: "나"),
                Brand(brandId: 8, brandName: "나"),
                Brand(brandId: 9, brandName: "나"),
                Brand(brandId: 10, brandName: "나")
            ]),
            
            BrandList(consonant: "ㄷ", brands: [
                Brand(brandId: 11, brandName: "다"),
                Brand(brandId: 12, brandName: "다"),
                Brand(brandId: 13, brandName: "다"),
                Brand(brandId: 14, brandName: "다"),
                Brand(brandId: 15, brandName: "다")
            ]),
            
            BrandList(consonant: "ㄹ", brands: [
                Brand(brandId: 16, brandName: "라"),
                Brand(brandId: 17, brandName: "라"),
                Brand(brandId: 18, brandName: "라"),
                Brand(brandId: 19, brandName: "라"),
                Brand(brandId: 20, brandName: "라")
            ]),
            
            BrandList(consonant: "ㅁ", brands: [
                Brand(brandId: 21, brandName: "마"),
                Brand(brandId: 22, brandName: "마"),
                Brand(brandId: 23, brandName: "마"),
                Brand(brandId: 24, brandName: "마"),
                Brand(brandId: 25, brandName: "마")
            ])
        ]
        
        return .just(.setBrandList(data))
    }
}
