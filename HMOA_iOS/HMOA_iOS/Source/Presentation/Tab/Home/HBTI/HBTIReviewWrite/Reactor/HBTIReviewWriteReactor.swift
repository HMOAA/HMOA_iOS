//
//  HBTIReviewWriteReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/21/24.
//
import ReactorKit
import RxSwift

final class HBTIReviewWriteReactor: Reactor {
    
    enum Action {
        case didTapAddPhotoButton
        case didSelectedImage([WritePhoto])
        case didTapXButton
        case didChangePage(Int)
    }
    
    enum Mutation {
        case setIsPresentToAlbum(Bool)
        case setImages([WritePhoto])
        case setDeletePhotoIds
        case setIsDeletedLast(Bool)
        case setCurrentPage(Int)
    }
    
    struct State {
        var isPresentToAlbum: Bool = false
        var photoCount: Int = 0
        var images: [WritePhoto] = []
        var currentPage: Int = 0
        var deletePhotoIds: [Int] = []
        var isDeletedLast: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapAddPhotoButton:
            return .concat([
                .just(.setIsPresentToAlbum(true)),
                .just(.setIsPresentToAlbum(false))
            ])
            
        case .didSelectedImage(let image):
            return .just(.setImages(image))
            
        case .didTapXButton:
            if currentState.currentPage == currentState.photoCount - 1 {
                return .concat([
                    .just(.setDeletePhotoIds),
                    .just(.setIsDeletedLast(true)),
                    .just(.setIsDeletedLast(false))
                ])
            } else {
                return .just(.setDeletePhotoIds)
            }
            
        case .didChangePage(let page):
            if currentState.currentPage != page {
                return .just(.setCurrentPage(page))
            } else { return .empty() }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsPresentToAlbum(let isPresent):
            state.isPresentToAlbum = isPresent
            
        case .setImages(let image):
            state.images.append(contentsOf: image)
            state.photoCount = state.images.count
            
        case .setDeletePhotoIds:
            let page = state.currentPage
            if let id = currentState.images[page].photoId {
                state.deletePhotoIds.append(id)
            }
            
            state.images.remove(at: page)
            state.photoCount -= 1
            
        case .setIsDeletedLast(let isDeleted):
            state.isDeletedLast = isDeleted
            
        case .setCurrentPage(let page):
            state.currentPage = page
        }
        
        return state
    }
}
