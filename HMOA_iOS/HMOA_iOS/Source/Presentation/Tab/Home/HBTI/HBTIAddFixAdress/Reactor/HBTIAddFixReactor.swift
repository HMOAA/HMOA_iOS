//
//  HBTIAddFixReactor.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 10/11/24.
//

import RxSwift
import ReactorKit

final class HBTIAddFixReactor: Reactor {
    
    enum Action {
        case didChangeName(String)
        case didChangeAddressName(String)
        case didChangePhoneNumber(String)
        case didChangeTelephoneNumber(String)
        case didChangeDetailAddress(String)
        case didChangeOrderRequest(String)
        case didTapSaveButton
    }
    
    enum Mutation {
        case setName(String)
        case setAddressName(String)
        case setPhoneNumber(String)
        case setTelephoneNumber(String)
        case setDetailAddress(String)
        case setOrderRequest(String)
        case setIsEnabledSaveButton(Bool)
        case setIsPushVC(Bool)
    }
    
    struct State {
        var title: String
        var name: String = ""
        var addressName: String = ""
        var phoneNumber: String = ""
        var telephoneNumber: String = ""
        var zipCode: String = "12345"
        var address: String = "인천 연수구"
        var detailAddress: String = ""
        var orderRequest: String = ""
        var isEnabledSaveButton: Bool = false
        var isPushVC: Bool = false
    }
    
    var initialState: State
    
    init(title: String) {
        self.initialState = State(title: title)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didChangeName(let name):
            return .just(.setName(name))
            
        case .didChangeAddressName(let addressName):
            return .just(.setAddressName(addressName))
            
        case .didChangePhoneNumber(let phoneNumber):
            return .just(.setPhoneNumber(phoneNumber))
            
        case .didChangeTelephoneNumber(let telephoneNumber):
            return .just(.setTelephoneNumber(telephoneNumber))
            
        case .didChangeDetailAddress(let detailAddress):
            return .just(.setDetailAddress(detailAddress))
            
        case .didChangeOrderRequest(let orderRequest):
            return .just(.setOrderRequest(orderRequest))
            
        case .didTapSaveButton:
            let isEnabled = currentState.isEnabledSaveButton
            
            return .just(.setIsPushVC(isEnabled))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setName(let name):
            state.name = name
            
        case .setAddressName(let addressName):
            state.addressName = addressName
            
        case .setPhoneNumber(let phoneNumber):
            state.phoneNumber = phoneNumber
            
        case .setTelephoneNumber(let telephoneNumber):
            state.telephoneNumber = telephoneNumber
            
        case .setDetailAddress(let detailAddress):
            state.detailAddress = detailAddress
            
        case .setOrderRequest(let orderRequest):
            state.orderRequest = orderRequest
            
        case .setIsEnabledSaveButton(let isEnabled):
            state.isEnabledSaveButton = isEnabled
            
        case .setIsPushVC(let isPush):
            state.isPushVC = isPush
        }
        
        state.isEnabledSaveButton = !state.name.isEmpty && !state.phoneNumber.isEmpty && !state.telephoneNumber.isEmpty && !state.zipCode.isEmpty && !state.address.isEmpty && !state.detailAddress.isEmpty
        
        return state
    }
}
