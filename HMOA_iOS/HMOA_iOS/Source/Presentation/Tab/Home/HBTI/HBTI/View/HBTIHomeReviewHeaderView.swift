//
//  HBTIHomeBottomView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/11/24.
//

import UIKit

import Then
import SnapKit

final class HBTIHomeReviewHeaderView: UIView {

    // MARK: - UI Components
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "whiteLogo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let introTitleLabel = UILabel().then {
        $0.setLabelUI("향BTI 후기", font: .pretendard_bold, size: 20, color: .white)
    }
    
    private let seeAllLabel = UILabel().then {
        $0.setLabelUI("전체보기", font: .pretendard_bold, size: 12, color: .white)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setAddView() {
        [
            logoImageView,
            introTitleLabel,
            seeAllLabel
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(25)
        }
        
        introTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(9)
            make.centerY.equalTo(logoImageView.snp.centerY)
        }
        
        seeAllLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(logoImageView.snp.bottom)
        }
    }

}
