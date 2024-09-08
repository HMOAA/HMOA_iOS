//
//  HBTINoteCategoryHeaderView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/6/24.
//

import Foundation

import UIKit
import SnapKit
import Then

final class HBTINoteCategoryHeaderView: UICollectionReusableView {
    
    static let identifier = "HBTINoteCategoryHeaderView"
    
    // 화면 스케일에 따른 1픽셀 라인 높이 계산
    private let lineHeight = 1 / UIScreen.main.scale
    
    
    // MARK: - UI Components
    
    // 헤더 제목 라벨
    private let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 16, color: .black)
    }
    
    // 구분선 뷰
    private let lineView = UIView().then {
        $0.backgroundColor = .customColor(.gray2)
    }
    
    // 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setAddViews() {
        [lineView, titleLabel].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(lineHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureHeader(_ title: String) {
        titleLabel.text = title
    }
}
