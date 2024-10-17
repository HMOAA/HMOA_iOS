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
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            checkImageView.image = isSelected
                ? UIImage(named: "checkSelected")
                : UIImage(named: "checkNotSelected")
        }
    }
    
    // MARK: - UI Components
    
    private let checkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    let viewButton = UIButton(type: .system).then {
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
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkImageView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
        
        viewButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func configureCell(with model: HBTIAgreementModel) {
        titleLabel.setLabelUI(model.agreementTitle, font: .pretendard_medium, size: 12, color: .gray3)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        // viewButton이 눌린 경우, 해당 이벤트는 viewButton에만 전달
        let pointInButton = viewButton.convert(point, from: self)
        if viewButton.bounds.contains(pointInButton) {
            return viewButton
        }
        
        // 그렇지 않으면 기본 동작 실행 (셀 선택 허용)
        return super.hitTest(point, with: event)
    }
}
