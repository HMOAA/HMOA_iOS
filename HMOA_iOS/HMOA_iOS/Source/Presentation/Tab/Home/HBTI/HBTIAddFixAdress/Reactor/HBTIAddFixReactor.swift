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
        
        state.isEnabledSaveButton = isValid(state.name, state.phoneNumber, state.telephoneNumber, state.zipCode, state.address, state.detailAddress)

        return state
    }
}

extension HBTIAddFixReactor {
    func isValid(_ name: String, _ phoneNumber: String, _ telephoneNumber: String, _ zipCode: String, _ address: String, _ detailAddress: String) -> Bool {
        return !name.isEmpty
            && isValidPhoneNumber(phoneNumber)
            && isValidTelephoneNumber(telephoneNumber)
            && !zipCode.isEmpty
            && !address.isEmpty
            && !detailAddress.isEmpty
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^(010)-\\d{4}-\\d{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            
        return predicate.evaluate(with: phoneNumber)
    }
    
    func isValidTelephoneNumber(_ telephoneNumber: String) -> Bool {
        let telephoneRegex = "^(02|031|032|033|041|042|043|044|051|052|053|054|055|061|062|063|064)-\\d{3}-\\d{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", telephoneRegex)
            
        return predicate.evaluate(with: telephoneNumber)
    }
}
