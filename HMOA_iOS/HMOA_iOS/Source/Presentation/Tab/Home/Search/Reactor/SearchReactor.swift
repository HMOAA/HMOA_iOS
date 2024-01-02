//
//  SearchReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/23.
//

import ReactorKit
import RxSwift

class SearchReactor: Reactor {
    
    enum Action {
        case didTapBackButton
        case didChangeTextField(String)
        case didEndTextField
        case didTapProductButton
        case didTapSearchListCell(IndexPath)
        case didTapSearchResultCell(IndexPath)
        case didClearTextField
        case willDisplayResultCell(Int)
        case willDisplayListCell(Int)
    }
    
    enum Mutation {
        case isPopVC(Bool)
        case isChangeToResultVC(Bool, Int?)
        case isChangeToListVC(Bool, Int?)
        case isChangeToDefaultVC(Int?)
        case isTapSearchListCell(String)
        case setKeyword([String])
        case setList([String])
        case setContent(String)
        case setResultProduct([SearchPerfume])
        case setProductButtonState(Bool)
        case setSelectedPerfumeId(Int?)
        case setLoadedResultPage(Int)
        case setLoadedListPage(Int)
        case setIsLiked(BrandPerfume)
    }
    
    struct State {
        var content: String = "" // textField에 입력된 값
        var listContent: String = "" // 연관 검색어 List 클릭한 값
        var isPopVC: Bool = false
        var isChangeTextField: Bool = false
        var isEndTextField: Bool = false
        var keywords: [String] = []
        var lists: [String] = [] // 연관 검색어 리스트
        var resultProduct: [SearchPerfume] = []
        var isSelectedProductButton: Bool = true
        var selectedPerfumeId: Int? = nil
        var loadedResultPages: Set<Int> = []
        var loadedListPages: Set<Int> = []
        var nowPage: Int = 1 // 현재 보여지고 있는 페이지
        var prePage: Int = 0 // 이전 페이지
    }
    
    var initialState: State
    let service: BrandDetailService
    
    init(service: BrandDetailService) {
        initialState = State()
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackButton:
            return .concat([
                .just(.isPopVC(true)),
                .just(.isPopVC(false))
            ])
        case .didChangeTextField(let content):
            return .concat([
                .just(.isChangeToListVC(true, 2)),
                reqeustList(0, content),
                .just(.isChangeToListVC(false, nil))
            ])
        case .didEndTextField:
            return .concat([
                .just(.isChangeToResultVC(true, 3)),
                setResultItems(0, currentState.content),
                .just(.isChangeToResultVC(false, nil))
            ])
        case .didClearTextField:
            return .concat([
                .just(.isChangeToDefaultVC(1)),
                .just(.isChangeToDefaultVC(nil))
            ])
        case .didTapProductButton:
            return .just(.setProductButtonState(true))
            
        case .didTapSearchListCell(let indexPath):
            return .concat([
                .just(.isChangeToResultVC(true, 3)),
                .just(.isTapSearchListCell(currentState.lists[indexPath.item])),
                setResultItems(0, currentState.lists[indexPath.item]),
                .just(.isChangeToResultVC(false, nil)),
                .just(.isTapSearchListCell(""))
            ])
            
        case .didTapSearchResultCell(let indexPath):
            return .concat([
                .just(.setSelectedPerfumeId(currentState.resultProduct[indexPath.item].perfumeId)),
                .just(.setSelectedPerfumeId(nil))
            ])
            
        case .willDisplayResultCell(let page):
            return setResultItems(page, currentState.content)
        case .willDisplayListCell(let page):
            return reqeustList(page, currentState.content)
        }
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setKeyword(let keywords):
            state.keywords = keywords
        case .setList(let lists):
            state.lists = lists
        case .setContent(let inputContent):
            state.content = inputContent
        case .setResultProduct(let products):
            state.resultProduct = products
        case .isPopVC(let isPop):
            state.isPopVC = isPop
        case .isChangeToListVC(let isChange, let nowPage):
            state.isChangeTextField = isChange
            // 이전 페이지 값을 state.nowPage로 구현해봤는데 코드가 좀 복잡해져서 나중에 손봐야될 것 같습니다
            if let nowPage = nowPage {
                if state.nowPage != 2 { // text가 바뀔 때 state.nowPage도 2, 전달되어지는 nowPage값도 2인 경우가 있어서 일단 이렇게 처리
                    state.prePage = state.nowPage
                    state.nowPage = nowPage
                }
            }
            
        case .isChangeToResultVC(let isEnd, let nowPage):
            state.isEndTextField = isEnd
            if let nowPage = nowPage {
                state.prePage = state.nowPage
                state.nowPage = nowPage
            }
            
        case .isChangeToDefaultVC(let nowPage):
            if let nowPage = nowPage {
                state.prePage = state.nowPage
                state.nowPage = nowPage
            }
            
        case .setProductButtonState(let isSelected):
            state.isSelectedProductButton = isSelected
            
        case .isTapSearchListCell(let content):
            state.listContent = content
            
        case .setSelectedPerfumeId(let perfumeId):
            state.selectedPerfumeId = perfumeId
            
        case .setLoadedResultPage(let page):
            if page == 0 { state.loadedResultPages = [] }
            state.loadedResultPages.insert(page)
            
        case .setLoadedListPage(let page):
            if page == 0 { state.loadedListPages = [] }
            state.loadedListPages.insert(page)
        case .setIsLiked(let perfume):
            let searchPerfume = SearchPerfume(
                brandName: perfume.brandName,
                isHeart: perfume.liked,
                perfumeId: perfume.perfumeId,
                perfumeImageUrl: perfume.perfumeImgUrl,
                perfumeName: perfume.perfumeName)
            var perfumes = state.resultProduct
            for i in 0..<perfumes.count {
                if perfumes[i].perfumeId == searchPerfume.perfumeId {
                    state.resultProduct[i].isHeart = searchPerfume.isHeart
                    break
                }
            }
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .setIsLikedPerfume(let perfume):
                return .just(.setIsLiked(perfume))
            }
        }
        
        return .merge(mutation, eventMutation)
    }
}

extension SearchReactor {
    
    func reqeustList(_ page: Int, _ content: String) -> Observable<Mutation> {
        
        if content.isEmpty { return .empty() }
        
        if page != 0 && currentState.loadedListPages.contains(page)  {
            return .empty()
        }
        
        let params: [String: Any] = [
            "page": page,
            "searchWord": content
        ]
        
        return SearchAPI.getPerfumeName(params: params)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var perfumeNames: [String]!
                if page == 0 { perfumeNames = [] }
                else {
                    perfumeNames = self.currentState.lists
                }
                
                data.forEach {
                    perfumeNames.append($0.perfumeName)
                }
                return .concat([
                    .just(.setList(perfumeNames)),
                    .just(.setContent(content)),
                    .just(.setLoadedListPage(page))
                ])
            }
    }
    
    func setResultItems(_ page: Int, _ content: String) -> Observable<Mutation> {
        if page != 0 && currentState.loadedResultPages.contains(page)  {
            return .empty()
        }
        
        let query: [String: Any] = [
            "page": page,
            "searchWord": content
        ]
        
        return SearchAPI.getPerfumeInfo(params: query)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var perfumes: [SearchPerfume]!
                if page == 0 { perfumes = [] } 
                else {
                    perfumes = self.currentState.resultProduct
                }
                perfumes.append(contentsOf: data)
                return .concat([
                    .just(.setResultProduct(perfumes)),
                    .just(.setLoadedResultPage(page))
                ])
            }
    }
}
