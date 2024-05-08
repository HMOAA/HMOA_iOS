//
//  MagazineDetailHeaderView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/7/24.
//

import UIKit
import SnapKit
import Then

class MagazineDetailHeaderView: UICollectionReusableView {
    
    static let identifier = "MagazineDetailHeaderView"
    
    // 화면 스케일에 따른 1픽셀 라인 높이 계산
    private let lineHeight = 1 / UIScreen.main.scale
    
    
    // MARK: - UI Components
    
    // 헤더 제목 라벨
    private let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 20, color: .white)
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
        [titleLabel, lineView].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.trailing.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(lineHeight)
        }
    }
    
    func configureHeader(_ title: String) {
        titleLabel.text = title
    }
}
