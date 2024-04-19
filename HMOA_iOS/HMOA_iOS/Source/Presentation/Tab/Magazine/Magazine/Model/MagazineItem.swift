//
//  MagazineItem.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import Foundation

enum MagazineSection: Hashable {
    case mainBanner
    case newPerfume
    case topReview
    case allMagazine
}

enum MagazineItem: Hashable, Codable {
    case magazine(Magazine)
    case newPerfume(NewPerfume)
    case topReview(TopReview)
}

extension MagazineItem {
    var magazine: Magazine? {
        if case .magazine(let magazine) = self {
            return magazine
        } else {
            return nil
        }
    }
    
    var newPerfume: NewPerfume? {
        if case .newPerfume(let newPerfume) = self {
            return newPerfume
        } else {
            return nil
        }
    }
    
    var topReview: TopReview? {
        if case .topReview(let topReview) = self {
            return topReview
        } else {
            return nil
        }
    }
    
    // initial snapshot items
    static let mainMagazines: [MagazineItem] = [
        .magazine(Magazine(magazineID: 1, title: "제목1", description: "소개1", previewImageURL: "이미지 url1")),
        .magazine(Magazine(magazineID: 2, title: "제목2", description: "소개2", previewImageURL: "이미지 url2")),
        .magazine(Magazine(magazineID: 3, title: "제목3", description: "소개3", previewImageURL: "이미지 url3")),
        .magazine(Magazine(magazineID: 4, title: "제목4", description: "소개4", previewImageURL: "이미지 url4"))
    ]
    
    static let newPerfumes: [MagazineItem] = [
        .newPerfume(NewPerfume(perfumeID: 1, name: "이더 시스 오드 드 퍼퓸", brand: "이솝", releaseDate: "2024.02.12", perfumeImageURL: "https://hmoa-perfume.s3.ap-northeast-2.amazonaws.com/%EB%8F%84%20%EC%86%90%20%EC%98%A4%20%EB%93%9C%20%EB%9A%9C%EC%99%88%EB%A0%9B/perfume-70/aa806ac9-16ac-4d86-8e90-1a99997e345f.png")),
        .newPerfume(NewPerfume(perfumeID: 2,name: "카모", brand: "탬버린즈", releaseDate: "2024.02.12", perfumeImageURL: "https://hmoa-perfume.s3.ap-northeast-2.amazonaws.com/%EB%8F%84%20%EC%86%90%20%EC%98%A4%20%EB%93%9C%20%EB%9A%9C%EC%99%88%EB%A0%9B/perfume-70/aa806ac9-16ac-4d86-8e90-1a99997e345f.png")),
        .newPerfume(NewPerfume(perfumeID: 3,name: "오드 롱 코롱", brand: "샤넬", releaseDate: "2024.02.12", perfumeImageURL: "https://hmoa-perfume.s3.ap-northeast-2.amazonaws.com/%EB%8F%84%20%EC%86%90%20%EC%98%A4%20%EB%93%9C%20%EB%9A%9C%EC%99%88%EB%A0%9B/perfume-70/aa806ac9-16ac-4d86-8e90-1a99997e345f.png")),
        .newPerfume(NewPerfume(perfumeID: 4,name: "오드 롱 코롱", brand: "샤넬", releaseDate: "2024.02.12", perfumeImageURL: "https://hmoa-perfume.s3.ap-northeast-2.amazonaws.com/%EB%8F%84%20%EC%86%90%20%EC%98%A4%20%EB%93%9C%20%EB%9A%9C%EC%99%88%EB%A0%9B/perfume-70/aa806ac9-16ac-4d86-8e90-1a99997e345f.png")),
        .newPerfume(NewPerfume(perfumeID: 5,name: "오드 롱 코롱", brand: "샤넬", releaseDate: "2024.02.12", perfumeImageURL: "https://hmoa-perfume.s3.ap-northeast-2.amazonaws.com/%EB%8F%84%20%EC%86%90%20%EC%98%A4%20%EB%93%9C%20%EB%9A%9C%EC%99%88%EB%A0%9B/perfume-70/aa806ac9-16ac-4d86-8e90-1a99997e345f.png"))
    ]
    
    static let top10Reviews: [MagazineItem] = [
        .topReview(TopReview(communityID: 1,title: "에르메스 머스크 시향기", userImageURL: "url", userName: "닉넴", content: "이 향수에선 전체적으로 굉장히 자연적인 향기를 느낄 수 있었다. 처음의 시트러스함 제외하곤 그 뒤로는 계속 그러했는데, \"마치 여름날, 강변에 잘 조성된 산책로를 걸으면 맡을 수 있을 것 같은 향들\"이었기 때문이다.")),
        .topReview(TopReview(communityID: 2,title: "에르메스 머스크 시향기", userImageURL: "url", userName: "닉넴", content: "이 향수에선 전체적으로 굉장히 자연적인 향기를 느낄 수 있었다. 처음의 시트러스함 제외하곤 그 뒤로는 계속 그러했는데, \"마치 여름날, 강변에 잘 조성된 산책로를 걸으면 맡을 수 있을 것 같은 향들\"이었기 때문이다.")),
        .topReview(TopReview(communityID: 3,title: "에르메스 머스크 시향기", userImageURL: "url", userName: "닉넴", content: "이 향수에선 전체적으로 굉장히 자연적인 향기를 느낄 수 있었다. 처음의 시트러스함 제외하곤 그 뒤로는 계속 그러했는데, \"마치 여름날, 강변에 잘 조성된 산책로를 걸으면 맡을 수 있을 것 같은 향들\"이었기 때문이다.")),
        .topReview(TopReview(communityID: 4,title: "에르메스 머스크 시향기", userImageURL: "url", userName: "닉넴", content: "이 향수에선 전체적으로 굉장히 자연적인 향기를 느낄 수 있었다. 처음의 시트러스함 제외하곤 그 뒤로는 계속 그러했는데, \"마치 여름날, 강변에 잘 조성된 산책로를 걸으면 맡을 수 있을 것 같은 향들\"이었기 때문이다.")),
        .topReview(TopReview(communityID: 5,title: "에르메스 머스크 시향기", userImageURL: "url", userName: "닉넴", content: "이 향수에선 전체적으로 굉장히 자연적인 향기를 느낄 수 있었다. 처음의 시트러스함 제외하곤 그 뒤로는 계속 그러했는데, \"마치 여름날, 강변에 잘 조성된 산책로를 걸으면 맡을 수 있을 것 같은 향들\"이었기 때문이다."))
    ]
    
    static let magazines: [MagazineItem] = [
        .magazine(Magazine(magazineID: 123, title: "제목1", description: "소개1", previewImageURL: "이미지 url1")),
        .magazine(Magazine(magazineID: 234, title: "제목2", description: "소개2", previewImageURL: "이미지 url2")),
        .magazine(Magazine(magazineID: 345, title: "제목3", description: "소개3", previewImageURL: "이미지 url3")),
        .magazine(Magazine(magazineID: 456, title: "제목4", description: "소개4", previewImageURL: "이미지 url4"))
    ]
}
