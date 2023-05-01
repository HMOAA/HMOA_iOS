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
    let initialState: State
    
    enum Action {
        case didTapChoiceYearButton
        case didTapWomanButton
        case didTapManButton
        case didTapStartButton(String, String)
    }
    
    enum Mutation {
        case setPresentChoiceYearVC(Bool)
        case setCheckWoman(Bool)
        case setCheckMan(Bool)
        case setSelectedYear(Bool)
        case setJoinResponse(JoinResponse?)
    }
    
    struct State {
        var isPresentChoiceYearVC: Bool = false
        var isCheckedWoman: Bool = false
        var isCheckedMan: Bool = false
        var isSelectedYear: Bool = false
        var isSexCheck: Bool = false
        var joinResponse: JoinResponse? = nil
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapChoiceYearButton:
            return .concat([
                .just(.setPresentChoiceYearVC(true)),
                .just(.setSelectedYear(true)),
                .just(.setPresentChoiceYearVC(false))
            ])
        case .didTapManButton:
            return .just(.setCheckMan(true))
        case .didTapWomanButton:
            return .just(.setCheckWoman(true))
        case .didTapStartButton(let year, let nickname):
            let age = convertYearToAge(year)
            let sexString = checkedSexString()
            return combineAPIObseverble(age, nickname, sexString)
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
            state.isSexCheck = isChecked
        case .setCheckWoman(let isChecked):
            state.isCheckedWoman = isChecked
            state.isCheckedMan = !isChecked
            state.isSexCheck = isChecked
        case .setSelectedYear(let isSelectedYear):
            state.isSelectedYear = isSelectedYear
        case .setJoinResponse(let joinResponse):
            state.joinResponse = joinResponse
        }
        
        return state 
    }
}
        
extension UserInformationReactor {
    
    //연도 기준으로 나이 구하기
    func convertYearToAge(_ year: String) -> Int {
        return 2024 - Int(year)!
    }
    
    // 버튼 체크에 따른 남성, 여성 반환
    func checkedSexString() -> String {
        
        if currentState.isCheckedMan { return "남성" }
        else if currentState.isCheckedWoman { return "여성" }
        return ""
    }
    
    //회원가입 parameter 설정
    func setJoinParams(_ age: Int, _ nickname: String , _ sex: String) -> [String: Any] {
        return [
            "age": age,
            "nickname": nickname,
            "sex": sex
        ]
    }
    
    //나이, 성별 회원가입 api 묶기
    func combineAPIObseverble(_ age: Int, _ nickname: String , _ sex: String) -> Observable<JoinResponse?> {
        let ageOb = API.updateAge(params: ["age": age])
        let sexOb = API.updateSex(params: ["sex": sex])
        let joinOb = API.join(params: setJoinParams(age, nickname, sex))
        
        return Observable.combineLatest(ageOb, sexOb, joinOb,
                                 resultSelector: { ageResponse, sexResponse, joinResponse in
            //api통신 실패 시 ErrorResponse로 decoding되는데 성공하면 각자의 모델로 디코딩 되니 그 해당 값이 있으면 api통신 성공
            if  !ageResponse.message.isEmpty &&
                !sexResponse.message.isEmpty &&
                !joinResponse.nickname.isEmpty {
                    return joinResponse
            }
            return nil
        })
        
    }
}
