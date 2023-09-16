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
        case didTapSeasonButton(Int)
        case didTapGenderButton(Int)
    }
    
    enum Mutation {
        case setWeather(Weather)
        case setGender(Gender)
    }
    
    struct State {
        var id: Int
        var weather: Weather? = nil
        var gender: Gender? = nil
    }
    
    init(_ id: Int) {
        initialState = State(id: id)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .didTapSeasonButton(let season):
            return setSeasonEvaluation(season)
            
        case .didTapGenderButton(let gender):
            return setGenderEvaluation(gender)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
            
        case .setWeather(let weather):
            state.weather = weather
            
        case .setGender(let gender):
            state.gender = gender
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
}
