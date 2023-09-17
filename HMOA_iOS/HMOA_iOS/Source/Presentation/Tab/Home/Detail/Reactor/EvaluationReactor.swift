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
    }
    
    enum Mutation {
        case setSliderStep(Float)
        case setWeather(Weather)
        case setGender(Gender)
        case setAge(Age)
    }
    
    struct State {
        var evaluation: Evaluation?
        var id: Int
        var weather: Weather? = nil
        var gender: Gender? = nil
        var age: Age? = nil
        var sliderStep: Float = 0
    }
    
    init(_ evaluationData: Evaluation?, _ id: Int) {
        initialState = State(evaluation: evaluationData, id: id)
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
            return setValueInIsWrited()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
            
        case .setWeather(let weather):
            print(weather)
            state.weather = weather
            
        case .setGender(let gender):
            print(gender)
            state.gender = gender
            
        case .setSliderStep(let value):
            let roundValue = round(value / 10) * 10
            state.sliderStep = roundValue
            
        case .setAge(let age):
            print(age)
            state.age = age
        }
        
        return state
    }
}

extension EvaluationReactor {
    
    func setSeasonEvaluation(_ season: Int) -> Observable<Mutation> {
        return EvaluationAPI.postSeason(id: "\(currentState.id)",
                                        weather: ["weather": season])
        .catch { _ in .empty()}
        .flatMap { data -> Observable<Mutation> in
            return .just(.setWeather(data))
        }
    }
    
    func setGenderEvaluation(_ gender: Int) -> Observable<Mutation> {
        return EvaluationAPI.postGender(
            id: "\(currentState.id)",
            gender: ["gender": gender]
        )
        .catch { _ in .empty() }
        .flatMap { data -> Observable<Mutation> in
            return .just(.setGender(data))
        }
    }
    
    func setAgeEvaluation(_ age: Int) -> Observable<Mutation> {
        if age != 0 {
            return EvaluationAPI.postAge(
                id: "\(currentState.id)",
                age: ["age": age])
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .just(.setAge(data))
            }
        }
        return .empty()
    }
    
    func setValueInIsWrited() -> Observable<Mutation> {
        guard let data = currentState.evaluation else { return .empty() }
        
        var observables: [Observable<Mutation>] = []
        
        if data.age.writed {
            observables.append(Observable.just(.setAge(data.age)))
        }
        
        if data.gender.writed {
            observables.append(Observable.just(.setGender(data.gender)))
        }
        
        if data.weather.writed {
            observables.append(Observable.just(.setWeather(data.weather)))
        }
        
        return Observable.merge(observables)
    }
}

