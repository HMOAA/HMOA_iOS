//
//  ChangeProfileImageReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/07/02.
//

import ReactorKit

class ChangeProfileImageReactor: Reactor {
    
    var initialState: State
    var service: UserServiceProtocol
    
    enum Action {
        case viewDidLoad
        case didTapShowAlbumButton
        case didSelectedImage(UIImage)
        case didTapChangeButton(UIImage)
    }
    
    enum Mutation {
        case setProfileImageForUIImage(UIImage)
        case showAlbum(Bool)
        case dismiss(Bool)
    }
    
    init(service: UserServiceProtocol, currentImage: UIImage?) {
        self.initialState = State(profileImage: currentImage)
        self.service = service
    }
    
    struct State {
        var profileImage: UIImage? = nil
        var isShowAlbum: Bool = false
        var isDismiss: Bool = false
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
            
        case .didTapChangeButton(let image):
            return .concat([
                ChangeProfileImageReactor.uploadProfileImage(image),
                service.updateUserImage(to: image).map { _ in .dismiss(false)}
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .setProfileImageForUIImage(let image):
            newState.profileImage = image
            
        case .showAlbum(let isShow):
            newState.isShowAlbum = isShow
            
        case .dismiss(let isDismiss):
            newState.isDismiss = isDismiss
        }
        
        return newState
    }
}

extension ChangeProfileImageReactor {
 
    static func uploadProfileImage(_ image: UIImage) -> Observable<Mutation> {
        return MemberAPI.uploadImage(image: image)
            .catch { _ in .empty() }
            .flatMap { response -> Observable<Mutation> in
                return .just(.dismiss(true))
            }
    }
}
