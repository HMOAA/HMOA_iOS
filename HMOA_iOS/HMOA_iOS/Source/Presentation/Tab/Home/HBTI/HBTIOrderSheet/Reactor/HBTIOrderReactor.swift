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
        case viewDidLoad
        case viewWillAppear
        case didChangeName(String)
        case didChangePhoneNumber(String)
        case didTapSaveInfoButton
        case didTapRemoveItemButton(Int)
        case didTapAllAgree
        case didTapPolicyAgree
        case didTapPersonalInfoAgree
    }
    
    enum Mutation {
        case setProductList([HBTIOrderSheetProductItem])
        case setProductPrice(Int)
        case setShippingPrice(Int)
        case setTotalPrice(Int)
        case setName(String)
        case setPhoneNumber(String)
        case setAddressName(String)
        case setAddress(String)
        case setTelephoneNumber(String)
        case setZipCode(String)
        case setIsSavedAddress(Bool)
        case setPayValid(Bool)
        case setIsFormValid(Bool)
        case setAllAgree(Bool)
        case setPolicyAgree(Bool)
        case setPersonalInfoAgree(Bool)
    }
    
    struct State {
        let orderId: Int
        let selectedNoteList: [Int]
        var productList: [HBTIOrderSheetProductItem] = []
        var productPrice: Int = 0
        var shippingPrice: Int = 0
        var totalPrice: Int = 0
        var name: String = ""
        var phoneNumber: String = ""
        var addressName: String = ""
        var address: String = ""
        var telephoneNumber: String = ""
        var zipCode: String = ""
        var isSavedAddress = false
        var isAllAgree: Bool = false
        var isPolicyAgree: Bool = false
        var isPersonalInfoAgree: Bool = false
        var isFormValid: Bool = false
        var isPayValid: Bool = false
    }
    
    var initialState: State
    
    init(orderId: Int, selectedNoteList: [Int]) {
        self.initialState = State(orderId: orderId, selectedNoteList: selectedNoteList)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setProductList()
            
        case .viewWillAppear:
            return getMemberAddressInfo()

        case .didChangeName(let name):
            return .just(.setName(name))
            
        case .didChangePhoneNumber(let phoneNumber):
            return .just(.setPhoneNumber(phoneNumber))
            
        case .didTapSaveInfoButton:
            guard isMemberOrderInfoValid(name: currentState.name, phoneNumber: currentState.phoneNumber) else { return .empty() }
            return setMemberOrderInfo()
            
        case .didTapRemoveItemButton(let index):
            let productId = currentState.selectedNoteList[index]
            return deleteOrderItem(productId: productId)

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
        case .setProductList(let productList):
            state.productList = productList
            
        case .setProductPrice(let productPrice):
            state.productPrice = productPrice
            
        case .setShippingPrice(let shippingPrice):
            state.shippingPrice = shippingPrice
            
        case .setTotalPrice(let totalPrice):
            state.totalPrice = totalPrice
            
        case .setName(let name):
            state.name = name
            
        case .setPhoneNumber(let phoneNumber):
            state.phoneNumber = phoneNumber
            
        case .setAddressName(let addressName):
            state.addressName = addressName
            
        case .setAddress(let address):
            state.address = address
            
        case .setTelephoneNumber(let telephoneNumber):
            state.telephoneNumber = telephoneNumber
            
        case .setZipCode(let zipCode):
            state.zipCode = zipCode
            
        case .setIsSavedAddress(let isSavedAddress):
            state.isSavedAddress = isSavedAddress
            
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
        
        state.isPayValid = isValid(state.name, state.phoneNumber, state.isAllAgree, state.address, state.zipCode)
        
        return state
    }
}

extension HBTIOrderReactor {
    private func isValid(_ name: String, _ phoneNumber: String, _ isAllAgree: Bool, _ address: String, _ zipCode: String) -> Bool {
        return !name.isEmpty
            && isValidPhoneNumber(phoneNumber)
            && isAllAgree
            && !address.isEmpty
            && !zipCode.isEmpty
    }
    
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^(010)-\\d{4}-\\d{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            
        return predicate.evaluate(with: phoneNumber)
    }
    
    private func isMemberOrderInfoValid(name: String, phoneNumber: String) -> Bool {
        return !name.isEmpty
            && isValidPhoneNumber(phoneNumber)
    }
}

extension HBTIOrderReactor {
    func setProductList() -> Observable<Mutation> {
        let orderId = currentState.orderId

        return HBTIAPI.fetchOrderInfo(orderId: orderId)
            .catch { _ in .empty() }
            .flatMap { productListData -> Observable<Mutation> in
                let productList = productListData.productInfo.categoryList.map { productData in
                    return HBTIOrderSheetProductItem.productInfo(productData)
                }
                let productPrice = productListData.productPrice
                let shippingPrice = productListData.shippingPrice
                let totalPrice = productListData.totalPrice
                
                return .concat([
                    .just(.setProductList(productList)),
                    .just(.setProductPrice(productPrice)),
                    .just(.setShippingPrice(shippingPrice)),
                    .just(.setTotalPrice(totalPrice))
                ])
            }
    }
    
    func setMemberOrderInfo() -> Observable<Mutation> {
        let memberInfo: [String: String] = [
            "name": currentState.name,
            "phoneNumber": currentState.phoneNumber
        ]
        
        return MemberAPI.postMemberOrderInfo(params: memberInfo)
            .catch { _ in .empty() }
            .flatMap { result -> Observable<Mutation> in
                return .empty()
            }
    }
    
    func getMemberAddressInfo() -> Observable<Mutation> {
        return MemberAPI.fetchMemberAddressInfo()
            .flatMap { memberAddress -> Observable<Mutation> in
                let memberName = memberAddress.memberName
                let phoneNumber = memberAddress.phoneNumber
                let addressName = memberAddress.addressName
                let address = "\(memberAddress.streetAddress) \(memberAddress.detailAddress)"
                let telephoneNumber = memberAddress.telephoneNumber
                let zipCode = memberAddress.zipCode
                let isSavedAddress = !memberName.isEmpty && !phoneNumber.isEmpty && !address.isEmpty
                
                return .concat([
                    .just(.setName(memberName)),
                    .just(.setPhoneNumber(phoneNumber)),
                    .just(.setAddressName(addressName)),
                    .just(.setAddress(address)),
                    .just(.setTelephoneNumber(telephoneNumber)),
                    .just(.setZipCode(zipCode)),
                    .just(.setIsSavedAddress(isSavedAddress))
                ])
            }
            .catch { error in
                if let urlError = error as? URLError, urlError.code == .fileDoesNotExist {
                    return .just(.setIsSavedAddress(false))
                } else {
                    return .empty()
                }
            }
    }
    
    func deleteOrderItem(productId: Int) -> Observable<Mutation> {
        let orderId = currentState.orderId
        
        return HBTIAPI.deleteOrderItem(orderId: orderId, productId: productId)
            .catch { _ in .empty() }
            .flatMap { _ -> Observable<Mutation> in
                return self.setProductList()
            }
    }
}
