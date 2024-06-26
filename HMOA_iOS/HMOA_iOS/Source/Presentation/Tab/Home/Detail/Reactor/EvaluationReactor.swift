//
//  EvaluationReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/14.
//

import Foundation

import RxSwift
import ReactorKit

class EvaluationReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case viewDidLoad
        case isChangingAgeSlider(Float)
        case didTapSeasonButton(Int)
        case didTapGenderButton(Int)
        case didChangeAgeSlider(Float)
        case didTapAgeResetButton
    }
    
    enum Mutation {
        case setSliderStep(Float)
        case setWeather(Weather)
        case setGender(Gender)
        case setAge(Age?)
        case setIsTap(Bool)
        case setIsTapAgeReset(Bool)
    }
    
    struct State {
        var evaluation: Evaluation?
        var id: Int
        var weather: Weather? = nil
        var gender: Gender? = nil
        var age: Age? = nil
        var sliderStep: Float = 0
        var isLogin: Bool
        var isTapWhenNotLogin: Bool = false
        var isTapAgeReset: Bool = false
    }
    
    init(_ evaluationData: Evaluation?, _ id: Int, isLogin: Bool) {
        initialState = State(evaluation: evaluationData, id: id, isLogin: isLogin)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .didTapSeasonButton(let season):
            return setSeasonEvaluation(season)
            
        case .didTapGenderButton(let gender):
            return setGenderEvaluation(gender)
            
        case .isChangingAgeSlider(let value):
            return .just(.setSliderStep(value))
            
        case .didChangeAgeSlider(let value):
            return setAgeEvaluation(Int(value / 10))
            
        case .viewDidLoad:
            return setValue()
            
        case .didTapAgeResetButton:
            return deleteAge()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
            
        case .setWeather(let weather):
            state.weather = weather
            
        case .setGender(let gender):
            state.gender = gender
            
        case .setSliderStep(let value):
            let roundValue = round(value / 10) * 10
            state.sliderStep = roundValue
            
        case .setAge(let age):
            state.age = age
            
        case .setIsTap(let isTap):
            state.isTapWhenNotLogin = isTap
            
        case .setIsTapAgeReset(let isTap):
            state.isTapAgeReset = isTap
        }
        
        return state
    }
}

extension EvaluationReactor {
    
    func setSeasonEvaluation(_ season: Int) -> Observable<Mutation> {
        var params: [String: Int]? = ["weather": season]
        
        if currentState.weather?.selected == season  {
            params = nil
        }
        if currentState.isLogin {
            return EvaluationAPI.postOrDeleteSeason(
                id: "\(currentState.id)",
                weather: params)
            .catch { _ in .empty()}
            .flatMap { data -> Observable<Mutation> in
                return .just(.setWeather(data))
            }
        } else {
            return returnIsTap()
        }
    }
    
    func setGenderEvaluation(_ gender: Int) -> Observable<Mutation> {
        var params: [String: Int]? = ["gender": gender]
        
        if currentState.gender?.selected == gender {
            params = nil
        }
        if currentState.isLogin {
            return EvaluationAPI.postOrDeleteGender(
                id: "\(currentState.id)",
                gender: params
            )
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .just(.setGender(data))
            }
        } else {
           return returnIsTap()
        }
    }
    
    func setAgeEvaluation(_ age: Int) -> Observable<Mutation> {
        
        if currentState.isLogin {
            if age != 0 {
                return EvaluationAPI.postOrDeleteAge(
                    id: "\(currentState.id)",
                    age: ["age": age])
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    return .just(.setAge(data))
                }
            } else {
                return .empty()
            }
        } else {
            return returnIsTap()
        }
    }
    
    func setValue() -> Observable<Mutation> {
        guard let data = currentState.evaluation else { return .empty() }
        
        var observables: [Observable<Mutation>] = []
        
        if data.age.writed {
            observables.append(Observable.just(.setAge(data.age)))
        }
        observables.append(Observable.just(.setGender(data.gender)))
        observables.append(Observable.just(.setWeather(data.weather)))
        
        return Observable.merge(observables)
    }
    
    func deleteAge() -> Observable<Mutation> {
        return EvaluationAPI.postOrDeleteAge(id: "\(currentState.id)", age: nil)
            .catch { _ in .empty() }
            .flatMap { _ -> Observable<Mutation> in
                return .concat([
                    .just(.setAge(nil)),
                    .just(.setSliderStep(0)),
                    .just(.setIsTapAgeReset(true)),
                    .just(.setIsTapAgeReset(false))
                ])
            }
    }
    
    func returnIsTap() -> Observable<Mutation> {
        return .concat([
            .just(.setIsTap(true)),
            .just(.setIsTap(false))
        ])
    }
}

