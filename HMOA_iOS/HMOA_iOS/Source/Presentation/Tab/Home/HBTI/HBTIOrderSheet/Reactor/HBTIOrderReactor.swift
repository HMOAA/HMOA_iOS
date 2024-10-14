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
        case didTapAllAgree
        case didTapPolicyAgree
        case didTapPersonalInfoAgree
    }
    
    enum Mutation {
        case setName(String)
        case setPhoneNumber(String)
        case setPayValid(Bool)
        case setIsFormValid(Bool)
//        case setIsAddressSaved(Bool)
        case setAllAgree(Bool)
        case setPolicyAgree(Bool)
        case setPersonalInfoAgree(Bool)
    }
    
    struct State {
        var name: String = ""
        var phoneNumber: String = ""
        var isAllAgree: Bool = false
        var isPolicyAgree: Bool = false
        var isPersonalInfoAgree: Bool = false
        var isFormValid: Bool = false
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
            let isValid = isFormValid(name: name, phoneNumber: currentState.phoneNumber)
            
            return .concat([
                .just(.setName(name)),
                .just(.setIsFormValid(isValid))
            ])
            
        case .didChangePhoneNumber(let phoneNumber):
            let isValid = isFormValid(name: currentState.name, phoneNumber: phoneNumber)
            
            return .concat([
                .just(.setPhoneNumber(phoneNumber)),
                .just(.setIsFormValid(isValid))
            ])
            
        case .didTapSaveInfoButton:
            return .empty()
            
        case .didTapEnterAddressButton:
            return .empty()
            
        case .didTapAllAgree:
            let isAllAgree = !currentState.isAllAgree
            
            return .concat([
                .just(.setAllAgree(isAllAgree)),
                .just(.setPolicyAgree(isAllAgree)),
                .just(.setPersonalInfoAgree(isAllAgree))
            ])
            
        case .didTapPolicyAgree:
            let isPolicyAgree = !currentState.isPolicyAgree
            let isAllAgree = isPolicyAgree && currentState.isPersonalInfoAgree
            
            return .concat([
                .just(.setPolicyAgree(isPolicyAgree)),
                .just(.setAllAgree(isAllAgree))
            ])
            
        case .didTapPersonalInfoAgree:
            let isPersonalInfoAgree = !currentState.isPersonalInfoAgree
            let isAllAgree = currentState.isPolicyAgree && isPersonalInfoAgree
            
            return .concat([
                .just(.setPersonalInfoAgree(isPersonalInfoAgree)),
                .just(.setAllAgree(isAllAgree))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setName(let name):
            state.name = name
            
        case .setPhoneNumber(let phoneNumber):
            state.phoneNumber = phoneNumber
            
        case .setIsFormValid(let isValid):
            state.isFormValid = isValid
            
        case .setPayValid(let isValid):
            state.isPayValid = isValid
            
        case .setAllAgree(let isAllAgree):
            state.isAllAgree = isAllAgree
            
        case .setPolicyAgree(let isPolicyAgree):
            state.isPolicyAgree = isPolicyAgree
            
        case .setPersonalInfoAgree(let isPersonalInfoAgree):
            state.isPersonalInfoAgree = isPersonalInfoAgree
        }
        
        state.isPayValid = state.isFormValid && state.isAllAgree
        
        return state
    }
}

extension HBTIOrderReactor {
    // 주문자 정보 유효성 검사
    private func isFormValid(name: String, phoneNumber: String) -> Bool {
        return !name.isEmpty && phoneNumber.count == 13
    }
}
