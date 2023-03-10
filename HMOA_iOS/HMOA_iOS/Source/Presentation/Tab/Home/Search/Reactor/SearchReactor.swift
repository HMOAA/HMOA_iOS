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
        case didTapBrandButton
        case didTapPostButton
        case didTapHpediaButton
        case didTapSearchListCell(IndexPath)
        case didClearTextField
    }
    
    enum Mutation {
        case isPopVC(Bool)
        case isChangeToResultVC(Bool, Int?)
        case isChangeToListVC(Bool, Int?)
        case isChangeToDefaultVC(Int?)
        case isTapSearchListCell(String?)
        case setKeyword([String])
        case setList([String])
        case setContent(String)
        case setResultProduct([Product])
        case setProductButtonState(Bool)
        case setBrandButtonState(Bool)
        case setPostButtonState(Bool)
        case setHpediaButtonState(Bool)
    }
    
    struct State {
        var content: String = "" // textField에 입력된 값
        var listContent: String = "" // 연관 검색어 List 클릭한 값
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

        case .didTapBrandButton:
            return .just(.setBrandButtonState(true))

        case .didTapPostButton:
            return .just(.setPostButtonState(true))

        case .didTapHpediaButton:
            return .just(.setHpediaButtonState(true))
            
        case .didTapSearchListCell(let indexPath):
            return .concat([
                .just(.isChangeToResultVC(true, 3)),
                .just(.isTapSearchListCell(currentState.lists[indexPath.item])),
                requestResult(currentState.lists[indexPath.item]),
                .just(.isChangeToResultVC(false, nil)),
                .just(.isTapSearchListCell(nil))
            ])
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
            
        case .isTapSearchListCell(let content):
            if let content = content {
                state.listContent = content
            }
        }
        
        return state
    }
}

extension SearchReactor {
    
    func reqeustList(_ content: String) -> Observable<Mutation> {
        
        // TODO: - content값으로 서버 통신해서 검색어 받아오기
        print("입력한 값:", content)

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
        
        return .concat([
            .just(.setList(data)),
            .just(.setContent(content))
        ])
    }
    
    func requestResult(_ content: String) -> Observable<Mutation> {
        
        // TODO: - 입력받은 content값으로 서버 통신해서 결과값 받아오기
        print("검색하는 값:", content)
        
        let data: [Product] = [Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛"), Product(image: UIImage(named: "jomalon")!, title: "랑방", content: "랑방 모던프린세스 불루밍 오 드 뚜왈렛")]
        
        return .just(.setResultProduct(data))
    }
}
