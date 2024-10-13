//
//  HBTIOrderReactor.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 10/9/24.
//

import RxSwift
import ReactorKit

final class HBTIOrderReactor: Reactor {
    
    enum Action {
        case didChangeName(String)
        case didChangePhoneNumber(String)
        case didTapSaveInfoButton
        case didTapEnterAddressButton
        case didTapPolicyAgree
    }
    
    enum Mutation {
        case setName(String)
        case setPhoneNumber(String)
        case setPayValid(Bool)
//        case setIsAddressSaved(Bool)
        case setPolicyAgree(Bool)
    }
    
    struct State {
        var name: String = ""
        var phoneNumber: String = ""
        var isAllAgree: Bool = false
        var isPolicyAgree: Bool = false
        var isPersonalInfoAgree: Bool = false
        var isPayValid: Bool = false
        // isAddressSaved는 서버에서 불러오는 것으로 변경 예정
//        var isAddressSaved: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didChangeName(let name):
            let isValid = isPayValid(name: name, phoneNumber: currentState.phoneNumber)
            
            return .concat([
                .just(.setName(name)),
                .just(.setPayValid(isValid))
            ])
            
        case .didChangePhoneNumber(let phoneNumber):
            let isValid = isPayValid(name: currentState.name, phoneNumber: phoneNumber)
            
            return .concat([
                .just(.setPhoneNumber(phoneNumber)),
                .just(.setPayValid(isValid))
            ])
            
        case .didTapSaveInfoButton:
            return .empty()
            
        case .didTapEnterAddressButton:
            return .empty()
            
        case .didTapPolicyAgree:
            let isPolicyAgree = !currentState.isPolicyAgree
            
            return .just(.setPolicyAgree(isPolicyAgree))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setName(let name):
            state.name = name
            
        case .setPhoneNumber(let phoneNumber):
            state.phoneNumber = phoneNumber
            
        case .setPayValid(let isValid):
            state.isPayValid = isValid
            
        case .setPolicyAgree(let isPolicyAgree):
            state.isPolicyAgree = isPolicyAgree
        }
        
        return state
    }
}

extension HBTIOrderReactor {
    // 주문자 정보 유효성 검사
    private func isPayValid(name: String, phoneNumber: String) -> Bool {
        return !name.isEmpty && phoneNumber.count == 13
    }
}
