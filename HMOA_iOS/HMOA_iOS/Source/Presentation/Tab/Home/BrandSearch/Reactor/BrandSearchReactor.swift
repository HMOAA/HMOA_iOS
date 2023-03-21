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
    }
    
    enum Mutation {
        case setIsPopVC(Bool)
        case setSelectedItem(Brand?)
        case setSearchResult(String)
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
    }
    
    init() {
        let data = BrandSearchReactor.reqeustBrandList()
        
        initialState = State(reqeustData: data.0, brandList:  data.1)
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
            
        case .updateSearchResult(let result):
            return .just(.setSearchResult(result))
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
            state.isFiltering = result == "" ? false : true
            state.searchResult = findSearhList(result)
        }
        
        return state
    }
}

extension BrandSearchReactor {
    
    static func reqeustBrandList() -> ([BrandList], [BrandListSection]) {
        
        let data: [BrandList] = [
            BrandList(consonant: 1, brands: [
                Brand(brandId: 1, brandName: "구찌"),
                Brand(brandId: 2, brandName: "겔랑"),
                Brand(brandId: 3, brandName: "기븐시"),
                Brand(brandId: 4, brandName: "까르띠에"),
                Brand(brandId: 5, brandName: "고디바")
            ]),
            
            BrandList(consonant: 2, brands: [
                Brand(brandId: 1, brandName: "나르시소"),
                Brand(brandId: 2, brandName: "로드리게즈"),
                Brand(brandId: 3, brandName: "니나리찌"),
                Brand(brandId: 4, brandName: "노마드"),
                Brand(brandId: 10, brandName: "노어")
            ]),
            
            BrandList(consonant: 3, brands: [
                Brand(brandId: 11, brandName: "디올"),
                Brand(brandId: 12, brandName: "덴티스"),
                Brand(brandId: 13, brandName: "도스토옙스"),
                Brand(brandId: 14, brandName: "돌체앤가바나"),
                Brand(brandId: 15, brandName: "라끌랑")
            ]),
            
            BrandList(consonant: 4, brands: [
                Brand(brandId: 16, brandName: "랑방"),
                Brand(brandId: 17, brandName: "랑콤"),
                Brand(brandId: 18, brandName: "러쉬"),
                Brand(brandId: 19, brandName: "루이비통"),
                Brand(brandId: 20, brandName: "르꼬끄 스포르티브")
            ]),
            
            BrandList(consonant: 5, brands: [
                Brand(brandId: 1, brandName: "마린 세르브르"),
                Brand(brandId: 2, brandName: "마리 구르랭"),
                Brand(brandId: 3, brandName: "마크 제이콥스"),
                Brand(brandId: 4, brandName: "만시에르 까랑"),
                Brand(brandId: 5, brandName: "망고")
            ]),
            
            BrandList(consonant: 6, brands: [
                Brand(brandId: 11, brandName: "발렌시아가"),
                Brand(brandId: 12, brandName: "버버리"),
                Brand(brandId: 13, brandName: "베네통"),
                Brand(brandId: 14, brandName: "보테가베네타"),
                Brand(brandId: 15, brandName: "본")
            ]),
            
            BrandList(consonant: 7, brands: [
                Brand(brandId: 26, brandName: "사뿐"),
                Brand(brandId: 27, brandName: "샤넬"),
                Brand(brandId: 28, brandName: "샤넬 뷰티"),
                Brand(brandId: 29, brandName: "샤넬 프리"),
                Brand(brandId: 30, brandName: "샤넬 알뤼르")
            ]),
            
            BrandList(consonant: 8, brands: [
                Brand(brandId: 21, brandName: "올리브영"),
                Brand(brandId: 22, brandName: "왁스앤와니"),
                Brand(brandId: 23, brandName: "왓소니"),
                Brand(brandId: 24, brandName: "워터루"),
                Brand(brandId: 25, brandName: "유리아쥬")
            ]),
            
            BrandList(consonant: 9, brands: [
                Brand(brandId: 21, brandName: "지오다노"),
                Brand(brandId: 22, brandName: "지방시"),
                Brand(brandId: 23, brandName: "질스튜어트"),
                Brand(brandId: 24, brandName: "즐리"),
                Brand(brandId: 25, brandName: "차앤박")
            ]),
            
            BrandList(consonant: 10, brands: [
                Brand(brandId: 21, brandName: "쵸파드"),
                Brand(brandId: 22, brandName: "카르텔"),
                Brand(brandId: 23, brandName: "커버걸"),
                Brand(brandId: 24, brandName: "컬러풀몬스터"),
                Brand(brandId: 25, brandName: "코스")
            ]),
            
            BrandList(consonant: 11, brands: [
                Brand(brandId: 21, brandName: "크리니크"),
                Brand(brandId: 22, brandName: "클라란스"),
                Brand(brandId: 23, brandName: "크리스찬디올"),
                Brand(brandId: 24, brandName: "크리스티나애거스턴"),
                Brand(brandId: 25, brandName: "키엘")
            ]),
            
            BrandList(consonant: 12, brands: [
                Brand(brandId: 21, brandName: "타미힐피거"),
                Brand(brandId: 22, brandName: "톰포드"),
                Brand(brandId: 23, brandName: "투쿨포스쿨"),
                Brand(brandId: 24, brandName: "트와이스"),
                Brand(brandId: 25, brandName: "트와이닝스")
            ]),
            
            BrandList(consonant: 13, brands: [
                Brand(brandId: 21, brandName: "파코라반"),
                Brand(brandId: 22, brandName: "파리게이츠"),
                Brand(brandId: 23, brandName: "페라리"),
                Brand(brandId: 24, brandName: "펜할리곤스"),
                Brand(brandId: 25, brandName: "폴로")
            ]),
            
            BrandList(consonant: 14, brands: [
                Brand(brandId: 21, brandName: "한스킨"),
                Brand(brandId: 22, brandName: "해피바스"),
                Brand(brandId: 23, brandName: "허밍어바이하니"),
                Brand(brandId: 24, brandName: "호빗"),
                Brand(brandId: 25, brandName: "후")
            ])
        ]
        
        var result: [BrandListSection] = []
        
        for section in data {
            result.append(section.section)
        }
        
        return (data, result)
    }
    
    func findSearhList(_ searchResult: String) -> [BrandListSection] {
        var filteringResult = [BrandList]()
        var filteringSection: [BrandListSection] = []

        for list in currentState.reqeustData {
            
            let brandList = list.brands.filter { $0.brandName.lowercased().contains(searchResult) }
            
            if !brandList.isEmpty {
                filteringResult.append(BrandList(consonant: list.consonant, brands: brandList))
            }
        }
        
        
        for list in filteringResult {
            filteringSection.append(list.section)
        }
        
        return filteringSection
    }
}

