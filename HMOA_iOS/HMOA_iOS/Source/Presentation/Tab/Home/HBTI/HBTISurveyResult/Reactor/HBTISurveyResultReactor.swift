//
//  HBTISurveyResultReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/12/24.
//
import ReactorKit
import RxSwift

final class HBTISurveyResultReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case isTapNextButton
    }
    
    enum Mutation {
        case setNoteItemList([HBTISurveyResultItem])
        case setResultInfo(String)
        case setIsPushNextVC
    }
    
    struct State {
        var selectedIDList: [Int]
        var noteItemList: [HBTISurveyResultItem] = []
        var resultInfo: [String: String] = [:]
        var isPushNextVC: Bool = false
    }
    
    var initialState: State
    
    init(_ selectedIDList: [Int]) {
        self.initialState = State(selectedIDList: selectedIDList)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                setNoteItemList(),
                setResultInfo()
            ])
        case .isTapNextButton:
            return .just(.setIsPushNextVC)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setNoteItemList(let item):
            state.noteItemList = item
        case .setResultInfo(let nickname):
            let noteList = currentState.noteItemList.map { $0.note!.name }
            let resultInfo = [
                "nickname": nickname,
                "best": noteList.first!,
                "second": noteList[1],
                "third": noteList[2]
            ]
            state.resultInfo = resultInfo
            
        case .setIsPushNextVC:
            state.isPushNextVC = true
        }
        
        return state
    }
}

extension HBTISurveyResultReactor {
    func setNoteItemList() -> Observable<Mutation> {
        let selectedIDList = currentState.selectedIDList
        
        return HBTIAPI.postAnswers(params: ["optionIds": selectedIDList])
            .catch { _ in .empty() }
            .flatMap { recommendNoteListData -> Observable<Mutation> in
                let listData = recommendNoteListData.recommendNotes.map { noteData in
                    return HBTISurveyResultItem.recommand(noteData)
                }
                return .just(.setNoteItemList(listData))
            }
    }
    
    func setResultInfo() -> Observable<Mutation> {
        return MemberAPI.getMember()
            .catch { _ in .empty() }
            .flatMap { member -> Observable<Mutation> in
                guard let member = member else { return .empty() }
                let nickname = member.nickname
                return .just(.setResultInfo(nickname))
            }
    }
}
