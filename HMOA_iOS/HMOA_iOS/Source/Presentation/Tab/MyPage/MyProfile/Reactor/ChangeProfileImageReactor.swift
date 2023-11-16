//
//  ChangeProfileImageReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/07/02.
//

import ReactorKit
import RxSwift

class ChangeProfileImageReactor: Reactor {
    
    var initialState: State
    var service: UserServiceProtocol
    
    enum Action {
        case viewDidLoad
        case didTapChangeProfileImageButton
        case didSelectedImage(UIImage)
        case didTapChangeButton(UIImage)
        case didTapDuplicateButton(String?)
        case didTapTextFieldReturn
    }
    
    enum Mutation {
        case setProfileImageForUIImage(UIImage)
        case showAlbum(Bool)
        case dismiss(Bool)
        case setNickNameResponse(Response?)
        case setNickname(String)
        case setIsDuplicate(Bool)
        case setIsTapReturn(Bool)
    }
    
    init(service: UserServiceProtocol, currentImage: UIImage?) {
        self.initialState = State(profileImage: currentImage, currentNickname: "")
        self.service = service
    }
    
    struct State {
        var profileImage: UIImage? = nil
        var isShowAlbum: Bool = false
        var isDismiss: Bool = false
        var isDuplicate: Bool? = nil
        var isEnable: Bool = false
        var isTapReturn: Bool = false
        var currentNickname: String
        var nickname: String? = nil
        var nicknameResponse: Response? = nil
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .viewDidLoad:
            return .empty()
            
        case .didTapChangeProfileImageButton:
            return .concat([
                .just(.showAlbum(true)),
                .just(.showAlbum(false))
            ])
            
        case .didSelectedImage(let image):
            return .just(.setProfileImageForUIImage(image))
            
        case .didTapChangeButton(let image):
            guard let nickname = currentState.nickname
            else { return .just(.setNickNameResponse(nil)) }
            return .concat([
                ChangeProfileImageReactor.uploadProfileImage(image),
                service.updateUserImage(to: image).map { _ in .dismiss(false) },
                MemberAPI.updateNickname(params: ["nickname": nickname])
                .map { .setNickNameResponse($0) },
                service.updateUserNickname(to: nickname).map { _ in .dismiss(true) },
                .just(.setNickNameResponse(nil))
            ])
            
        case .didTapDuplicateButton(let nickname):
            guard let nickname = nickname
            else { return .just(.setIsDuplicate(true))}
            
            if nickname.isEmpty { return .just(.setIsDuplicate(true))}
            
            return .concat([
                MemberAPI.checkDuplicateNickname(params: ["nickname": nickname])
                .map { .setIsDuplicate($0) },
                .just(.setNickname(nickname))
            ])

        case .didTapTextFieldReturn:
            return .concat([
                .just(.setIsTapReturn(true)),
                .just(.setIsTapReturn(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .setProfileImageForUIImage(let image):
            newState.profileImage = image
            newState.isEnable = true
            
        case .showAlbum(let isShow):
            newState.isShowAlbum = isShow
            
        case .dismiss(let isDismiss):
            newState.isDismiss = isDismiss
            
        case .setIsDuplicate(let isDuplicate):
            newState.isDuplicate = isDuplicate
            newState.isEnable = isDuplicate == false
            
        case .setIsTapReturn(let isTapReturn):
            newState.isTapReturn = isTapReturn
            
        case .setNickname(let nickname):
            newState.nickname = nickname
            
        case .setNickNameResponse(let response):
            newState.nicknameResponse = response
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
