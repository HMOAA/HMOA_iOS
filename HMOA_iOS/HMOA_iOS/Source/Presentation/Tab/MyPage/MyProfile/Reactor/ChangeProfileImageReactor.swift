//
//  ChangeProfileImageReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/07/02.
//

import ReactorKit

class ChangeProfileImageReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setProfileImageForUrl(String)
        case setProfileImageForUIImage(UIImage)
    }
    
    init(service: UserServiceProtocol, currentImageUrl: String?) {
        self.initialState = State(profileImageUrl: currentImageUrl)
    }
    
    struct State {
        var profileImageUrl: String? = nil
        var profileImage: UIImage? = nil
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .viewDidLoad:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProfileImageForUrl(let url):
            newState.profileImageUrl = url
            
        case .setProfileImageForUIImage(let image):
            newState.profileImage = image
        }
        
        return newState
    }
}
