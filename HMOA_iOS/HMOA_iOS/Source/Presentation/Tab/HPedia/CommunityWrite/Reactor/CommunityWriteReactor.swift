//
//  CommunityWriteReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/01.
//

import Foundation

import ReactorKit
import RxSwift
import Kingfisher

class CommunityWriteReactor: Reactor {
    var initialState: State
    let service: CommunityListProtocol?
    
    enum Action {
        case didTapOkButton
        case didChangeTitle(String)
        case didChangeTextViewEditing(String)
        case didBeginEditing
        case didTapPhotoButton
        case didSelectedImage([WritePhoto])
        case viewDidLoad
        case didTapXButton
        case didChangePage(Int)
    }
    
    enum Mutation {
        case setTitle(String)
        case setContent(String)
        case setSucces
        case setIsPresentToAlbum(Bool)
        case setImages([WritePhoto])
        case setEditImages([WritePhoto])
        case setDeletePhotoIds
        case setCurrentPage(Int)
        case setIsDeletedLast(Bool)
        
    }
    
    struct State {
        var id: Int? = nil
        var isBeginEditing: Bool = false
        var content: String
        var title: String? = nil
        var category: String
        var okButtonEnable: Bool = false
        var isPresentToAlbum: Bool = false
        var images: [WritePhoto] = []
        var isEndWriting: Bool = false
        var deletePhotoIds: [Int] = []
        var communityPhotos: [CommunityPhoto] = []
        var photoCount: Int = 0
        var editImages: [WritePhoto] = []
        var isDeletedLast: Bool = false
        var currentPage: Int = 0
    }
    
    init(communityId: Int?, content: String = "내용을 입력해주세요", title: String?, category: String, photos: [CommunityPhoto], service: CommunityListProtocol?) {
        
        initialState = State(id: communityId,
                             content: content,
                             title: title,
                             category: category,
                             communityPhotos: photos,
                             photoCount: photos.count
        )
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapOkButton:
            if let id = currentState.id {
                return editCommunityPost(id)
            } else {
                return postCommunityPost()
            }
            
        case .didChangeTitle(let title):
            return .just(.setTitle(title))
            
        case .didBeginEditing:
            if currentState.content == "내용을 입력해주세요" {
                return .just(.setContent(""))
            } else {
                return .empty()
            }
            
        case .didChangeTextViewEditing(let content):
            return .just(.setContent(content))
            
        case .didTapPhotoButton:
            return .concat([
                .just(.setIsPresentToAlbum(true)),
                .just(.setIsPresentToAlbum(false))
            ])
            
        case .didSelectedImage(let image):
            return .just(.setImages(image))
            
        case .viewDidLoad:
            return CommunityWriteReactor.loadPhotos(currentState.communityPhotos)
                .flatMap { photos -> Observable<Mutation> in
                        .concat([
                            .just(.setImages(photos)),
                            .just(.setEditImages(photos))
                        ])
                }
        
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
            
        case .setTitle(let title):
            state.title = title
            state.okButtonEnable = isOkButtonEnabled(content: currentState.content,
                                                     title: title)
            
        case .setContent(let content):
            state.content = content
            state.okButtonEnable = isOkButtonEnabled(content: content,
                                                     title: currentState.title ?? "")
            
        case .setSucces:
            break
            
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
            
        case .setEditImages(let editImages):
            state.editImages = editImages
            
        case .setCurrentPage(let page):
            state.currentPage = page
            
        case .setIsDeletedLast(let isDeleted):
            state.isDeletedLast = isDeleted
        }
        
        return state
    }
}

extension CommunityWriteReactor {
    func postCommunityPost() -> Observable<Mutation> {
        
        let state = currentState
        
        guard let title = state.title else { return .empty() }
        if state.content.isEmpty || title.isEmpty {
            return .empty()
        }
        
        let params: [String: String] = [
            "category": state.category,
            "content": state.content,
            "title": title
        ]
        let images = state.images.map { $0.image }
        return CommunityAPI.postCommunityPost(params, images: images)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                guard let service = self.service else { return .empty() }
                return .concat([
                    service.updateCommunityList(to: CategoryList(
                        communityId: data.id,
                        category: data.category,
                        title: data.title,
                        commentCount: nil,
                        heartCount: 0,
                        liked: false
                    )).map { _ in .setSucces }
                ])
            }
    }
    
    func editCommunityPost(_ id: Int) -> Observable<Mutation> {
        guard let title = currentState.title else { return .empty() }
        
        var addImages: [UIImage] = []
        for item in currentState.images {
            if !currentState.editImages.contains(where: { $0 == item }) {
                addImages.append(item.image)
            }
        }
        let params: [String: Any] = [
            "deleteCommunityPhotoIds": currentState.deletePhotoIds,
            "content": currentState.content,
            "title": title
        ]
        return CommunityAPI.editCommunityPost(
            id,
            params,
            addImages
        )
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .concat([
                    self.service!.updateCommunityList(to: CategoryList(
                        communityId: data.id,
                        category: data.category,
                        title: data.title,
                        commentCount: 0,
                        heartCount: data.heartCount,
                        liked: data.liked
                        
                    )).map { _ in .setSucces },
                    self.service!.editCommunityDetail(to: data)
                        .map { _ in .setSucces }
                ])
            }
    }
    
    func isOkButtonEnabled(content: String, title: String ) -> Bool {
        
        let isContentEmpty = content.isEmpty
        let isContentInitValue = content == "내용을 입력해주세요"
        let isTitleEmpty = title.isEmpty
        
        return !(isContentEmpty || isTitleEmpty || isContentInitValue)
    }
    
    static func loadPhotos(_ photos: [CommunityPhoto]) -> Observable<[WritePhoto]> {
        let imageLoadObservables = photos.map { photo in
            Observable<WritePhoto>.create { observer in
                guard let url = URL(string: photo.photoUrl) else {
                    observer.onCompleted()
                    return Disposables.create()
                }
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        observer.onNext(WritePhoto(photoId: photo.photoId, image: value.image))
                        observer.onCompleted()
                    case .failure(_):
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }
        return Observable.zip(imageLoadObservables)
    }
}
