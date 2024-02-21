//
//  CommunityPostHeaderView.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import UIKit

import Then
import SnapKit

class CommunityPostHeaderView: UICollectionReusableView {
    static let identifier = "CommunityPostHeaderView"
    
    //MARK: - UI Component
    let recommendLabel = UILabel().then {
        $0.setLabelUI("추천해주세요", font: .pretendard_medium, size: 14, color: .gray2)
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAddView() {
        addSubview(recommendLabel)
    }
    
    private func setConstraints() {
        recommendLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
