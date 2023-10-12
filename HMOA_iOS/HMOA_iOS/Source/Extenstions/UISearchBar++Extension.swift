//
//  UISearchBar++Extension.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/08.
//

import Foundation
import UIKit

extension UISearchBar {
    func configureHpediaSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(named: "clearButton"), for: .clear, state: .normal)
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.setImage(UIImage(named: "search")?.withTintColor(.customColor(.gray3)), for: .bookmark, state: .normal)
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textAlignment = .left
        searchBar.searchTextField.font = .customFont(.pretendard_light, 16)
        searchBar.placeholder = "키워드를 검색하세요"
        
        return searchBar
    }
}
