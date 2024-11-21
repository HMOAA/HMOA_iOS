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
        case didChangeAddress(String)
        case didChangeZipCode(String)
        case didChangeDetailAddress(String)
        case didChangeOrderRequest(String)
        case didTapInvalidButton
        case didTapSaveButton
    }
    
    enum Mutation {
        case setName(String)
        case setAddressName(String)
        case setPhoneNumber(String)
        case setTelephoneNumber(String)
        case setAddress(String)
        case setZipCode(String)
        case setDetailAddress(String)
        case setOrderRequest(String)
        case setIsShowAlertLabel(Bool)
        case setIsEnabledSaveButton(Bool)
        case setIsPushVC(Bool)
    }
    
    struct State {
        var title: String
        var name: String = ""
        var addressName: String = ""
        var phoneNumber: String = ""
        var telephoneNumber: String = ""
        var zipCode: String = ""
        var address: String = ""
        var detailAddress: String = ""
        var orderRequest: String = ""
        var isShowAlertLabel: Bool = false
        var isEnabledSaveButton: Bool = false
        var isPushVC: Bool = false
        let orderId: Int
        let selectedNoteList: [Int]
    }
    
    var initialState: State
    
    init(title: String, orderId: Int, selectedNoteList: [Int]) {
        self.initialState = State(title: title, orderId: orderId, selectedNoteList: selectedNoteList)
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
            
        case .didChangeAddress(let address):
            return .just(.setAddress(address))
            
        case .didChangeZipCode(let zipCode):
            return .just(.setZipCode(zipCode))
            
        case .didChangeDetailAddress(let detailAddress):
            return .just(.setDetailAddress(detailAddress))
            
        case .didChangeOrderRequest(let orderRequest):
            return .just(.setOrderRequest(orderRequest))
            
        case .didTapInvalidButton:
            return .just(.setIsShowAlertLabel(true))
            
        case .didTapSaveButton:
            let isEnabled = currentState.isEnabledSaveButton

            return .concat([
                    .just(.setIsEnabledSaveButton(isEnabled)),
                    isEnabled ? postMemberAddressInfo() : .empty(),
                    .just(.setIsPushVC(isEnabled)),
                    .just(.setIsPushVC(false))
                ])
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
            
        case .setAddress(let address):
            state.address = address
            
        case .setZipCode(let zipCode):
            state.zipCode = zipCode
            
        case .setDetailAddress(let detailAddress):
            state.detailAddress = detailAddress
            
        case .setOrderRequest(let orderRequest):
            state.orderRequest = orderRequest
            
        case .setIsShowAlertLabel(let isShowAlertLabel):
            state.isShowAlertLabel = isShowAlertLabel
            
        case .setIsEnabledSaveButton(let isEnabled):
            state.isEnabledSaveButton = isEnabled
            
        case .setIsPushVC(let isPush):
            state.isPushVC = isPush
        }
        
        state.isEnabledSaveButton = isValid(name: state.name, phoneNumber: state.phoneNumber, zipCode: state.zipCode, address: state.address, detailAddress: state.detailAddress)
        
        return state
    }
}

extension HBTIAddFixReactor {
    func isValid(name: String, phoneNumber: String, zipCode: String, address: String, detailAddress: String) -> Bool {
        return !name.isEmpty
            && isValidPhoneNumber(phoneNumber)
            && !zipCode.isEmpty
            && !address.isEmpty
            && !detailAddress.isEmpty
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^(010)-\\d{4}-\\d{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            
        return predicate.evaluate(with: phoneNumber)
    }
}

extension HBTIAddFixReactor {
    func postMemberAddressInfo() -> Observable<Mutation> {
        let memberAddressInfo: [String: String] = [
            "addressName": currentState.addressName,
            "detailAddress": currentState.detailAddress,
            "landlineNumber": currentState.telephoneNumber,
            "name": currentState.name,
            "phoneNumber": currentState.phoneNumber,
            "request": currentState.orderRequest,
            "streetAddress": currentState.address,
            "zipCode": currentState.zipCode
        ]
        
        return MemberAPI.postMemberAddressInfo(params: memberAddressInfo)
            .catch { _ in .empty() }
            .flatMap { response -> Observable<Mutation> in
                return .empty()
            }
    }
}
