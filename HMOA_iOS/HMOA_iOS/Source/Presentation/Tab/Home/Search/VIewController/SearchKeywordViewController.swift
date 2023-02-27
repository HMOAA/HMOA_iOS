//
//  SearchKeywordViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/27.
//

import UIKit
import SnapKit
import Then
import TagListView

class SearchKeywordViewController: UIViewController {

    // MARK: - UI Component
    lazy var keywordList = TagListView().then {
        $0.marginY = 8
        $0.marginX = 4
        $0.borderColor = .white
        $0.cornerRadius = 12
        $0.tagBackgroundColor = .black
        $0.textColor = .white
        $0.alignment = .center
        $0.textFont = .customFont(.pretendard, 14)
        $0.paddingY = 5
        $0.paddingX = 12
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension SearchKeywordViewController {
    
    func configureUI() {
        
        view.addSubview(keywordList)
        
        keywordList.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
}
