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
        case didChangeName(String)
        case didChangePhoneNumber(String)
        case didTapSaveInfoButton
        case didTapEnterAddressButton
        case didTapAllAgree
        case didTapPolicyAgree
        case didTapPersonalInfoAgree
    }
    
    enum Mutation {
        case setIsExistMemberAddress(Bool)
        case setIsExistMemberInfo(Bool)
        case setOrderId(Int)
        case setProductList([HBTIOrderSheetProductItem])
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
        let orderNoteList: [Int]
        var isExistMemberAddress: Bool = false
        var isExistMemberInfo: Bool = false
        var orderId: Int = 0
        var productList: [HBTIOrderSheetProductItem] = []
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
    
    init(_ orderNoteList: [Int]) {
        self.initialState = State(orderNoteList: orderNoteList)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                setOrderId(),
                setProductList()
            ])

        case .didChangeName(let name):
            return .just(.setName(name))
            
        case .didChangePhoneNumber(let phoneNumber):
            return .just(.setPhoneNumber(phoneNumber))
            
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
        case .setIsExistMemberAddress(let isExistAddress):
            state.isExistMemberAddress = isExistAddress
            
        case .setIsExistMemberInfo(let isExistInfo):
            state.isExistMemberInfo = isExistInfo
            
        case .setOrderId(let orderId):
            state.orderId = orderId
            
        case .setProductList(let productList):
            state.productList = productList
            
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
        
        state.isPayValid = isValid(state.name, state.phoneNumber, state.isAllAgree)
        
        return state
    }
}

extension HBTIOrderReactor {
    private func isValid(_ name: String, _ phoneNumber: String, _ isAllAgree: Bool) -> Bool {
        return !name.isEmpty
            && isValidPhoneNumber(phoneNumber)
            && isAllAgree
    }
    
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^(010)-\\d{4}-\\d{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            
        return predicate.evaluate(with: phoneNumber)
    }
}

extension HBTIOrderReactor {
    func setOrderId() -> Observable<Mutation> {
        let orderNoteList = currentState.orderNoteList
        
        return HBTIAPI.postOrderNoteList(params: ["productIds": orderNoteList])
            .catch{ _ in .empty() }
            .flatMap { orderResultData -> Observable<Mutation> in
                let isExistMemberAddress = orderResultData.isExistMemberAddress
                let isExistMemberInfo = orderResultData.isExistMemberInfo
                let orderId = orderResultData.orderId
                
                // TODO: 1. 주문자 정보, 배송지 정보 유무를 응답으로 받아옴
                // TODO: 2. 만약 true 라면 각각의 정보를 get해서 새로운 UI를 그림, false라면 기존 UI 그려줌 (true, false에 따라 다른 view를 import해줌.)
                // TODO: 3. 주문자 정보가 있다면, 주소 변경하기 view를 띄움.
                
                return .concat([
                    .just(.setIsExistMemberAddress(isExistMemberAddress)),
                    .just(.setIsExistMemberInfo(isExistMemberInfo)),
                    .just(.setOrderId(orderId))
                ])
            }
    }
    
    func setProductList() -> Observable<Mutation> {
        let orderId = currentState.orderId

        return HBTIAPI.fetchOrderInfo(orderId: orderId)
            .catch { _ in .empty() }
            .flatMap { productListData -> Observable<Mutation> in
                let listData = productListData.productInfo.categoryList.map { productData in
                    return HBTIOrderSheetProductItem.productInfo(
                        HBTICategory(
                            id: productData.id,
                            name: productData.name,
                            imageURL: productData.imageURL,
                            noteCount: productData.noteCount,
                            noteList: productData.noteList,
                            price: productData.price
                        )
                    )
                }

                return .just(.setProductList(listData))
            }
    }
}
