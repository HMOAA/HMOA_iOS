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
        case viewDidLoad
        case didBeginEditing
        case didChangeTextViewEditing(String)
        case didTapAddPhotoButton
        case didSelectedImage([WritePhoto])
        case didTapXButton
        case didChangePage(Int)
        case didTapOkButton
    }
    
    enum Mutation {
        case setContent(String)
        case setIsPresentToAlbum(Bool)
        case setImages([WritePhoto])
        case setDeletePhotoIds
        case setIsDeletedLast(Bool)
        case setCurrentPage(Int)
        case setSuccess
        case setEditImages([WritePhoto])
    }
    
    struct State {
        let orderID: Int?
        let reviewID: Int?
        var content: String = "내용을 입력해주세요"
        var okButtonEnable: Bool = false
        var isPresentToAlbum: Bool = false
        var photoCount: Int = 0
        var images: [WritePhoto] = []
        var communityPhotos: [CommunityPhoto] = []
        var currentPage: Int = 0
        var deletePhotoIds: [Int] = []
        var isDeletedLast: Bool = false
        var editImages: [WritePhoto] = []
    }
    
    var initialState: State
    
    init(orderID: Int) {
        self.initialState = State(orderID: orderID, reviewID: nil)
    }
    
    init(reviewID: Int, content: String, photos: [CommunityPhoto]) {
        self.initialState = State(orderID: nil, reviewID: reviewID, content: content, photoCount: photos.count, communityPhotos: photos)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return CommunityWriteReactor.loadPhotos(currentState.communityPhotos)
                .flatMap { photos -> Observable<Mutation> in
                        .concat([
                            .just(.setImages(photos)),
                            .just(.setEditImages(photos))
                        ])
                }
            
        case .didBeginEditing:
            if currentState.content == "내용을 입력해주세요" {
                return .just(.setContent(""))
            } else {
                return .empty()
            }
            
        case .didChangeTextViewEditing(let content):
            return .just(.setContent(content))
            
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
            
        case .didTapOkButton:
            if initialState.orderID != nil {
                return postReviewPost()
            } else {
                return editReview()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setContent(let content):
            state.content = content
            state.okButtonEnable = isOkButtonEnabled(content: content)
            
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
            
        case .setSuccess:
            break
            
        case .setEditImages(let editImages):
            state.editImages = editImages
        }
        
        return state
    }
}

extension HBTIReviewWriteReactor {
    func isOkButtonEnabled(content: String) -> Bool {
        
        let isContentEmpty = content.isEmpty
        let isContentInitValue = content == "내용을 입력해주세요"
        
        return !(isContentEmpty || isContentInitValue)
    }
    
    func postReviewPost() -> Observable<Mutation> {
        let state = currentState
        
        if state.content.isEmpty {
            return .empty()
        }
        
        let params: [String: Any] = [
            "orderId": state.orderID!,
            "content": state.content
        ]
        let images = state.images.map { $0.image }
        return HBTIAPI.postReview(params, images: images)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .just(.setSuccess)
            }
    }
    
    func editReview() -> Observable<Mutation> {
        let state = currentState
        
        if state.content.isEmpty {
            return .empty()
        }
        var addImages: [UIImage] = []
        for item in currentState.images {
            if !currentState.editImages.contains(where: { $0 == item }) {
                addImages.append(item.image)
            }
        }
        let params: [String: Any] = [
            "reviewId": state.reviewID!,
            "content": state.content,
            "deleteReviewPhotoIds": state.deletePhotoIds
        ]
        return HBTIAPI.editReview(reviewID: state.reviewID!,params: params, images: addImages)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .just(.setSuccess)
            }
    }
}
