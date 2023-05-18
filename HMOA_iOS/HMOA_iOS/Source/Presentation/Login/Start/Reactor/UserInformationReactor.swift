//
//  StartReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/10.
//

import UIKit

import ReactorKit
import RxCocoa

class UserInformationReactor: Reactor {
    var initialState: State
    var service: UserYearServiceProtocol
    
    enum Action {
        case didTapChoiceYearButton
        case didTapWomanButton
        case didTapManButton
        case didTapStartButton(String)
        case didChangeSelectedYear(String)
    }
    
    enum Mutation {
        case setPresentChoiceYearVC(Bool)
        case setCheckWoman(Bool)
        case setCheckMan(Bool)
        case setSelectedYear(String?)
        case setJoinResponse(JoinResponse?)
    }
    
    struct State {
        var isPresentChoiceYearVC: Bool = false
        var isCheckedWoman: Bool = false
        var isCheckedMan: Bool = false
        var isSexCheck: Bool = false
        var selectedYear: String? = nil
        var joinResponse: JoinResponse? = nil
        var isStartEnable: Bool = false
        var nickname: String = ""
    }
    
    init(service: UserYearServiceProtocol) {
        self.initialState = State()
        self.service = service
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let event = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .selectedYear(content: let year):
                return .just(.setSelectedYear(year))
            }
        }
        
        return .merge(mutation, event)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapChoiceYearButton:
            return .concat([
                .just(.setPresentChoiceYearVC(true)),
                .just(.setPresentChoiceYearVC(false))
            ])
        case .didTapManButton:
            return .just(.setCheckMan(true))
        case .didTapWomanButton:
            return .just(.setCheckWoman(true))
        case .didChangeSelectedYear(let year):
            return .concat([
                .just(.setSelectedYear(year)),
                .just(.setSelectedYear(nil))
            ])
        case .didTapStartButton(let nickname):
            guard let year = currentState.selectedYear else {return .empty()}
            return combineAPIObseverble(year, nickname)
                .map { .setJoinResponse($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
        case .setPresentChoiceYearVC(let isPresent):
            state.isPresentChoiceYearVC = isPresent
        case .setCheckMan(let isChecked):
            state.isCheckedMan = isChecked
            state.isCheckedWoman = !isChecked
            state.isSexCheck = true
            state.isStartEnable = setStartButtonEnable()
        case .setCheckWoman(let isChecked):
            state.isCheckedWoman = isChecked
            state.isCheckedMan = !isChecked
            state.isSexCheck = true
            state.isStartEnable = setStartButtonEnable()
        case .setJoinResponse(let joinResponse):
            state.joinResponse = joinResponse
        case .setSelectedYear(let year):
            state.selectedYear = year
            state.isStartEnable = year != nil && year != "선택" && currentState.isSexCheck
        }
        
        return state 
    }
}
        
extension UserInformationReactor {
    
    func reactorForChoiceYear() -> ChoiceYearReactor {
        return ChoiceYearReactor(service: service)
    }
    
    func setStartButtonEnable() -> Bool {
        return currentState.selectedYear != nil && currentState.selectedYear != "선택"
    }
    
    //회원가입 parameter 설정
    func setJoinParams(_ age: Int, _ nickname: String) -> [String: Any] {
        return [
            "age": age,
            "nickname": nickname,
            "sex": true
        ]
    }
    
    //나이, 성별 회원가입 api 묶기
    func combineAPIObseverble(_ year: String, _ nickname: String) -> Observable<JoinResponse> {
        let age = getAge(year)
        
        let ageOb = MemberAPI.updateAge(params: ["age": age])
        let sexOb = MemberAPI.updateSex(params: ["sex": true])
        let joinOb = MemberAPI.join(params: setJoinParams(age, nickname))
        
        return joinOb
        
    }
    
    func getAge(_ year: String) -> Int {
        var formatter_year = DateFormatter()
        formatter_year.dateFormat = "yyyy"
        return Int(formatter_year.string(from: Date()))! - Int(year)!
    }
}
