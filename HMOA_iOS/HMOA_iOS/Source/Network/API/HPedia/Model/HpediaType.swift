//
//  HpediaType.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/23/23.
//

import Foundation

import RxSwift

enum HpediaType {
    case term
    case note
    case perfumer
    case brand
}

extension HpediaType {
    
    var title: String {
        switch self {
        case .term:
            return "용어"
        case .note:
            return "노트"
        case .perfumer:
            return "조향사"
        case .brand:
            return "brand"
        }
    }
    
    
    func listApi(_ query: [String: Int]) -> Observable<[HPediaItem]> {
        switch self {
        case .term:
            return HPediaAPI.fetchTermList(query)
                .catch { _ in .empty() }
                .map { $0.data.map { $0.toHPediaItem() } }
            
        case .note:
            return HPediaAPI.fetchNoteList(query)
                .catch { _ in .empty() }
                .map { $0.data.map { $0.toHPediaItem() } }
            
        case .perfumer:
            return HPediaAPI.fetchPerfumerList(query)
                .catch { _ in .empty() }
                .map { $0.data.map { $0.toHPediaItem() } }
            
        case .brand:
            return HPediaAPI.fetchBrandList(query)
                .catch { _ in .empty() }
                .map { $0.data.map { $0.toHPediaItem() } }
        }
    }
    
    func searchApi(_ query: [String: Any]) -> Observable<[HPediaItem]> {
        switch self {
        case .term:
            return SearchAPI.fetchSearchedHPediaTerm(query: query)
                .catch { _ in .empty() }
                .map { $0.map { $0.toHPediaItem() } }
            
        case .note:
            return SearchAPI.fetchSearchedHPediaNote(query: query)
                .catch { _ in .empty() }
                .map { $0.map { $0.toHPediaItem() } }
            
        case .perfumer:
            return SearchAPI.fetchSearchedHPediaPerfumer(query: query)
                .catch { _ in .empty() }
                .map { $0.map { $0.toHPediaItem() } }
            
        case .brand:
            return SearchAPI.fetchSearchedHPediaBrand(query: query)
                .catch { _ in .empty() }
                .map { $0.map { $0.toHPediaItem() } }
        }
    }
}
