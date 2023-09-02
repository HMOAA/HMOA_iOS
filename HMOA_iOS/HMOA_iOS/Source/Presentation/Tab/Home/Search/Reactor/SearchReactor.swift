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
        case scrollCollectionView(IndexPath)
        case scrollTableView(IndexPath)
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
        case setRecentResultPage(Int)
        case setRecentListPage(Int)
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
        var nowPage: Int = 1 // 현재 보여지고 있는 페이지
        var prePage: Int = 0 // 이전 페이지
        var isSelectedProductButton: Bool = true
        var selectedPerfumeId: Int? = nil
        var recentResultPage: Int = -1
        var recentListPage: Int = -1
    }
    
    var initialState = State()
    
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
                reqeustList(content),
                .just(.isChangeToListVC(false, nil))
            ])
        case .didEndTextField:
            return .concat([
                .just(.isChangeToResultVC(true, 3)),
                requestResult(currentState.content),
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
                requestResult(currentState.lists[indexPath.item]),
                .just(.isChangeToResultVC(false, nil)),
                .just(.isTapSearchListCell(""))
            ])
            
        case .didTapSearchResultCell(let indexPath):
            return .concat([
                .just(.setSelectedPerfumeId(currentState.resultProduct[indexPath.item].perfumeId)),
                .just(.setSelectedPerfumeId(nil))
            ])
            
        case .scrollCollectionView(let indexPath):
            return self.requestResultPaging((indexPath.item + 1) / 6, currentState.listContent)
        //TODO: - 향수 이름 list api 개수 바꿔주기
        case .scrollTableView(let indexPath):
            return self.requestListPaging((indexPath.item + 1) / 10, currentState.content)
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
            
        case .setRecentResultPage(let page):
            state.recentResultPage = page
            
        case .setRecentListPage(let page):
            state.recentListPage = page
        }
        
        return state
    }
}

extension SearchReactor {
    
    func reqeustList(_ content: String) -> Observable<Mutation> {
        if content.isEmpty { return .empty() }
        print("입력한 값:", content)
        let params: [String: Any] = [
            "page": 0,
            "searchWord": content
        ]
        
        return SearchAPI.getPerfumeName(params: params)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var perfumeNames = [String]()
                data.forEach {
                    let name = $0.perfumeName
                    perfumeNames.append(name)
                }
                return .concat([
                    .just(.setList(perfumeNames)),
                    .just(.setContent(content))
                ])
            }
    }
    
    func requestListPaging(_ page: Int, _ content: String) -> Observable<Mutation> {
        
        if page == currentState.recentListPage || page == 0 {
            return .empty()
        }
        
        let params: [String: Any] = [
            "page": page,
            "searchWord": content
        ]

        return SearchAPI.getPerfumeName(params: params)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var perfumeNames = self.currentState.lists
                data.forEach {
                    let name = $0.perfumeName
                    perfumeNames.append(name)
                }
                return .concat([
                    .just(.setList(perfumeNames)),
                    .just(.setContent(content)),
                    .just(.setRecentListPage(page))
                ])
            }
    }
    
    func requestResult(_ content: String) -> Observable<Mutation> {
        let params: [String: Any] = [
            "page": 0,
            "searchWord": content
        ]
        return SearchAPI.getPerfumeInfo(params: params)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                print(content)
                print(data)
                var perfumes = [SearchPerfume]()
                data.forEach {
                    perfumes.append($0)
                }
                return .just(.setResultProduct(perfumes))
            }
    }
    
    func requestResultPaging(_ page: Int, _ content: String) -> Observable<Mutation> {
        
        if content.isEmpty { return .empty() }
        
        if page == currentState.recentResultPage {
            return .empty()
        }
        
        print(page)
        
        let params: [String: Any] = [
            "page": page,
            "searchWord": content
        ]
        return SearchAPI.getPerfumeInfo(params: params)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var perfumes = self.currentState.resultProduct
                data.forEach {
                    perfumes.append($0)
                }
                return .concat([
                    .just(.setResultProduct(perfumes)),
                    .just(.setRecentResultPage(page))
                ])
            }
    }
}
