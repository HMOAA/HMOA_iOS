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
        case scrollCollectionView(Int)
    }
    
    enum Mutation {
        case setIsPopVC(Bool)
        case setSelectedItem(Brand?)
        case setRequestData([BrandList])
        case setSection([BrandListSection])
        case setSearchResult([BrandListSection])
        case setLoadedPage(Int)
        case setSearchWord(String)
        
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
        var loadedPage: Set<Int> = []
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
            
        case .scrollCollectionView(let consonant):
            return .concat([
                reqeustBrandList(consonant: consonant)
                ])
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
            state.brandList = section
        
        case .setRequestData(let brandList):
            state.reqeustData = brandList
            
        case .setLoadedPage(let page):
            state.loadedPage.insert(page)
            
        case .setSearchWord(let word):
            state.isFiltering = word == "" ? false : true
        }
        
        return state
    }
}

extension BrandSearchReactor {
    
    func reqeustBrandList(consonant: Int) -> Observable<Mutation> {
        if currentState.loadedPage.contains(consonant) { return .empty() }
        
        return SearchAPI.getBrandPaging(query: ["consonant": consonant])
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var brand: BrandList!
                if data.isEmpty {
                    brand = BrandList(consonant: consonant, brands: [Brand(brandId: 0, brandImageUrl: "", brandName: "", englishName: "")])
                } else {
                    brand = BrandList(consonant: consonant, brands: data)
                }
                var newBrandList = self.currentState.reqeustData
                newBrandList.append(brand)
                var newSections = self.currentState.brandList
                newSections.append(brand.section)
                
                return .concat([
                    .just(.setRequestData(newBrandList)),
                    .just(.setSection(newSections)),
                    .just(.setLoadedPage(consonant))
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
                    filteringSection.append(list.section)
                }
                
                return .just(.setSearchResult(filteringSection))
            }

    }
}
