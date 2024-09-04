//
//  HBTIAgreementCell.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/1/24.
//

import UIKit
import SnapKit
import Then

final class HBTIAgreementCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let checkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    private let viewButton = UIButton(type: .system).then {
        let text = "보기"
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.customFont(.pretendard_medium, 12),
                .foregroundColor: UIColor.customColor(.gray3),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        $0.setAttributedTitle(attributedString, for: .normal)
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
         checkImageView,
         titleLabel,
         viewButton
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        checkImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkImageView.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
        }
        
        viewButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func configureCell(with model: HBTIAgreementModel) {
        switch model.agreementType {
        case .allAgree:
            checkImageView.image = UIImage(named: "checkBoxSelected")
            titleLabel.setLabelUI(model.agreeTitle, font: .pretendard_bold, size: 14, color: .black)
            viewButton.isHidden = true
            
        case .partialAgree:
            checkImageView.image = UIImage(named: "checkNotSelected")
            titleLabel.setLabelUI(model.agreeTitle, font: .pretendard_medium, size: 12, color: .gray3)
            viewButton.isHidden = false
        }
    }
}
