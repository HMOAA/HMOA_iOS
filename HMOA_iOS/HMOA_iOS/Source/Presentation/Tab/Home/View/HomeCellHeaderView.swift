//
//  HomeCellHeaderView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/16.
//

import UIKit
import SnapKit
import Then

class HomeCellHeaderView: UICollectionReusableView {
    
    // MARK: - identifier
    
    static let identifier = "HomeCellHeaderView"
    
    // MARK: - Properties
    let searchLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 14)
        $0.text = "시트러스"
    }
    
    let forYouLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 14)
        $0.text = "를 검색한 당신에게"
    }
    
    lazy var moreButton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.titleLabel!.font = .customFont(.pretendard, 12)
        $0.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeCellHeaderView {
    func configureUI() {
        [   searchLabel,
            forYouLabel,
            moreButton  ] .forEach { addSubview($0) }
        
        searchLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        forYouLabel.snp.makeConstraints {
            $0.leading.equalTo(searchLabel.snp.trailing)
            $0.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(forYouLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
