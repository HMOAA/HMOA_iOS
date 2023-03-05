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
        case keywordViewDidLoad
        case didTapBackButton
        case didChangeTextField
        case didEndTextField
        case didTapProductButton
        case didTapBrandButton
        case didTapPostButton
        case didTapHpediaButton
    }
    
    enum Mutation {
        case isPopVC(Bool)
        case isChangeToResultVC(Bool, Int?)
        case isChangeToListVC(Bool, Int?)
        case setKeyword([String])
        case setList([String])
        case setResultProduct([Product])
        case setProductButtonState(Bool)
        case setBrandButtonState(Bool)
        case setPostButtonState(Bool)
        case setHpediaButtonState(Bool)
    }
    
    struct State {
        var Content: String = ""
        var isPopVC: Bool = false
        var isChangeTextField: Bool = false
        var isEndTextField: Bool = false
        var keywords: [String] = []
        var lists: [String] = [] // 연관 검색어 리스트
        var resultProduct: [Product] = []
        var nowPage: Int = 1 // 현재 보여지고 있는 페이지
        var prePage: Int = 0 // 이전 페이지
        var isSelectedProductButton: Bool = true
        var isSelectedBrandButton: Bool = false
        var isSelectedPostButton: Bool = false
        var isSelectedHpediaButton: Bool = false
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .keywordViewDidLoad:
            return requestKeyword()
        case .didTapBackButton:
            return .concat([
                .just(.isPopVC(true)),
                .just(.isPopVC(false))
            ])
        case .didChangeTextField:
            return .concat([
                .just(.isChangeToListVC(true, 2)),
                reqeustList(),
                .just(.isChangeToListVC(false, nil))
            ])
        case .didEndTextField:
            return .concat([
                .just(.isChangeToResultVC(true, 3)),
                requestResult(),
                .just(.isChangeToResultVC(false, nil))
            ])
        case .didTapProductButton:
            return .just(.setProductButtonState(true))

        case .didTapBrandButton:
            return .just(.setBrandButtonState(true))

        case .didTapPostButton:
            return .just(.setPostButtonState(true))

        case .didTapHpediaButton:
            return .just(.setHpediaButtonState(true))
        
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setKeyword(let keywords):
            state.keywords = keywords
        case .setList(let lists):
            state.lists = lists
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
            
        case .setProductButtonState(let isSelected):
            state.isSelectedProductButton = isSelected
            state.isSelectedBrandButton = false
            state.isSelectedPostButton = false
            state.isSelectedHpediaButton = false
            
        case .setBrandButtonState(let isSelected):
            state.isSelectedBrandButton = isSelected
            state.isSelectedProductButton = false
            state.isSelectedPostButton = false
            state.isSelectedHpediaButton = false
            
        case .setPostButtonState(let isSelected):
            state.isSelectedPostButton = isSelected
            state.isSelectedBrandButton = false
            state.isSelectedProductButton = false
            state.isSelectedHpediaButton = false
            
        case .setHpediaButtonState(let isSelected):
            state.isSelectedHpediaButton = isSelected
            state.isSelectedBrandButton = false
            state.isSelectedPostButton = false
            state.isSelectedProductButton = false
        }
        
        return state
    }
}

extension SearchReactor {
    
    func requestKeyword() -> Observable<Mutation> {
        
        // TODO: - 서버 통신해서 키워드 받아오기
        
        let data = ["자연", "도손", "오프레옹", "롬브로단로", "우드앤세이지", "딥티크", "르라보", "선물", "크리스찬디올", "존바바토스", "30대"]
        
        return .concat([
            .just(.setKeyword(data))
        ])
    }
    
    func reqeustList() -> Observable<Mutation> {
        
        // TODO: - 서버 통신해서 검색어 받아오기
        
        let data =  ["랑방 모던 프린세스",
                     "랑방 블루 오키드",
                     "랑방 워터 릴리",
                     "랑방 잔느",
                     "랑방 블루 오키드",
                     "랑방 워터 릴리",
                     "랑방 잔느",
                     "랑방 블루 오키드",
                     "랑방 워터 릴리",
                     "랑방 잔느"]
        
        return .just(.setList(data))
    }
    
    func requestResult() -> Observable<Mutation> {
        
        let data: [Product] = [Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛")]
        
        return .just(.setResultProduct(data))
    }
}
