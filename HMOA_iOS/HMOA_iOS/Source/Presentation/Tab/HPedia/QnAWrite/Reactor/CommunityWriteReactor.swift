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
        case didSelectedImage([UIImage])
        case viewDidLoad
    }
    
    enum Mutation {
        case setTitle(String)
        case setContent(String)
        case setSucces
        case setIsPresentToAlbum(Bool)
        case setSelectedImages([UIImage])
        //case setPhotoIds([Int])
    }
    
    struct State {
        var id: Int? = nil
        var isBeginEditing: Bool = false
        var content: String
        var title: String? = nil
        var category: String
        var okButtonEnable: Bool = false
        var isPresentToAlbum: Bool = false
        var selectedImages: [UIImage] = []
        var isEndWriting: Bool = false
        var photoIds: [Int] = []
        var communityPhotos: [CommunityPhoto] = []
        var photoCount: Int = 0
    }
    
    init(communityId: Int?, content: String = "내용을 입력해주세요", title: String?, category: String, photos: [CommunityPhoto], service: CommunityListProtocol?) {
        
        initialState = State(id: communityId,
                             content: content,
                             title: title,
                             category: category,
                             photoIds: photos.map { $0.photoId },
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
            return .just(.setSelectedImages(image))
            
        case .viewDidLoad:
            return CommunityWriteReactor.loadPhotos(currentState.communityPhotos)
                .map { Mutation.setSelectedImages($0) }
            
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
            
        case .setSelectedImages(let image):
            state.selectedImages.append(contentsOf: image)
            state.photoCount = state.selectedImages.count
//        case .setPhotoIds():
//            <#code#>
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
        return CommunityAPI.postCommunityPost(params, images: state.selectedImages)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .concat([
                    self.service!.updateCommunityList(to: CategoryList(communityId: data.id, category: data.category, title: data.title)).map { _ in .setSucces }
                ])
            }
    }
    
    func editCommunityPost(_ id: Int) -> Observable<Mutation> {
        guard let title = currentState.title else { return .empty() }
        return CommunityAPI.editCommunityPost(
            id,
            [
                "content": currentState.content,
                "title": title
            ]
        )
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .concat([
                    self.service!.editCommunityList(to: CategoryList(
                        communityId: data.id,
                        category: data.category,
                        title: data.title
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
    
    static func loadPhotos(_ photos: [CommunityPhoto]) -> Observable<[UIImage]> {
        let imageLoadObservables = photos.map { photo in
            Observable<UIImage>.create { observer in
                guard let url = URL(string: photo.photoUrl) else {
                    observer.onCompleted()
                    return Disposables.create()
                }
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        observer.onNext(value.image)
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
