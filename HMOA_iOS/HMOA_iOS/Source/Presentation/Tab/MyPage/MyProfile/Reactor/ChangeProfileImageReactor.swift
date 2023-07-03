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
        case didTapShowAlbumButton
        case didSelectedImage(UIImage)
    }
    
    enum Mutation {
        case setProfileImageForUIImage(UIImage)
        case showAlbum(Bool)
    }
    
    init(service: UserServiceProtocol, currentImage: UIImage?) {
        self.initialState = State(profileImage: currentImage)
    }
    
    struct State {
        var profileImage: UIImage? = nil
        var isShowAlbum: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .viewDidLoad:
            return .empty()
            
        case .didTapShowAlbumButton:
            return .concat([
                .just(.showAlbum(true)),
                .just(.showAlbum(false))
            ])
            
        case .didSelectedImage(let image):
            return .just(.setProfileImageForUIImage(image))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .setProfileImageForUIImage(let image):
            newState.profileImage = image
            
        case .showAlbum(let isShow):
            newState.isShowAlbum = isShow
        }
        
        return newState
    }
}
