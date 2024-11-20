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
        case didTapBackButton
        case didTapItem(Brand)
        case updateSearchResult(String)
        case scrollCollectionView
    }
    
    enum Mutation {
        case setIsPopVC(Bool)
        case setSelectedItem(Brand?)
        case setRequestData([BrandList])
        case setSection([BrandListSection])
        case setSearchResult([BrandListSection])
        case setSearchWord(String)
        case setNextConsonant(Int)
    }
    
    struct State {
        var isPopVC: Bool = false
        
        var sections: [BrandListSection] {
            if isFiltering {
                return searchResult
            } else {
                return brandList
            }
        }
        
        var reqeustData: [BrandList] = []
        var selectedItem: Brand? = nil
        var brandList: [BrandListSection] = []
        var searchResult: [BrandListSection] = []
        var isFiltering: Bool = false
        var nextConsonant: Int = 1
    }
    
    init() {
        
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapBackButton:
            return .concat([
                .just(.setIsPopVC(true)),
                .just(.setIsPopVC(false))
            ])

            
        case .didTapItem(let brand):
            return .concat([
                .just(.setSelectedItem(brand)),
                .just(.setSelectedItem(nil))
            ])
            
        case .updateSearchResult(let word):
            return .concat([
                .just(.setSearchWord(word)),
                findSearhList(word)
                ])
            
        case .scrollCollectionView:
            let consonant = currentState.nextConsonant
            return reqeustBrandList(consonant: consonant)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsPopVC(let isPop):
            state.isPopVC = isPop
                    
            state.brandList = []
        case .setSelectedItem(let brand):
            state.selectedItem = brand
    
        case .setSearchResult(let result):
            state.searchResult = result
            
        case .setSection(let section):
            state.brandList += section
        
        case .setRequestData(let brandList):
            state.reqeustData += brandList
            
        case .setSearchWord(let word):
            state.isFiltering = word == "" ? false : true
            
        case .setNextConsonant(let index):
            state.nextConsonant = index
        }
        
        return state
    }
}

extension BrandSearchReactor {
    
    func reqeustBrandList(consonant: Int) -> Observable<Mutation> {
        return SearchAPI.getBrandPaging(query: ["consonant": consonant])
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                if data.isEmpty && consonant < 20 {
                    return self.reqeustBrandList(consonant: consonant + 1)
                }
                let brand = BrandList(consonant: consonant, brands: data)
                guard let section = brand.section else { return .empty() }
                
                return .concat([
                    .just(.setRequestData([brand])),
                    .just(.setSection([section])),
                    .just(.setNextConsonant(consonant + 1))
                ])
            }
    }
    
    func findSearhList(_ searchResult: String) -> Observable<Mutation> {
        if searchResult == "" { return .empty() }
        
        var filteringSection: [BrandListSection] = []

       return SearchAPI.fetchSearchBrand(query: ["searchWord": searchResult])
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                data.forEach { list in
                    guard let section = list.section else { return }
                    filteringSection.append(section)
                }
                
                return .just(.setSearchResult(filteringSection))
            }

    }
}
