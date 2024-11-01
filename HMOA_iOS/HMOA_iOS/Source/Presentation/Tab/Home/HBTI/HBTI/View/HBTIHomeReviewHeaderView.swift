//
//  HBTIHomeBottomView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/11/24.
//

import UIKit

import Then
import SnapKit
import RxSwift

final class HBTIHomeReviewHeaderView: UICollectionReusableView {
    
    static let identifier = "HBTIHomeReviewHeaderView"
    var disposeBag = DisposeBag()

    // MARK: - UI Components
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "whiteLogo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("향BTI 후기", font: .pretendard_bold, size: 20, color: .white)
    }
    
    let seeAllButton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_bold, 12)
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
            titleLabel,
            seeAllButton
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(9)
            make.centerY.equalTo(logoImageView.snp.centerY)
        }
        
        seeAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(logoImageView.snp.bottom).offset(10)
        }
    }
}
