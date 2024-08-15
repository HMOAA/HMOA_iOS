//
//  HBTIQuantitySelctionView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 7/29/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class HBTIQuantitySelctionView: UIView {
    // MARK: - UI Components
    
    private let categoryTitleLabel = UILabel()
    
    private let checkVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.customFont(.pretendard_semibold, 18)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        makeCategoryTitleLabel()
        createCheckButtonView()
    }
    
    private func setAddView() {
        [
         categoryTitleLabel,
         checkVerticalStackView,
         nextButton
        ].forEach(self.addSubview)
    }
    
    private func setupConstraints() {
        categoryTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.leading.equalToSuperview().offset(16)
        }
        
        checkVerticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(240)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(248)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
    }
}

extension HBTIQuantitySelctionView {
    private func makeCategoryTitleLabel() {
        categoryTitleLabel.font = UIFont.customFont(.pretendard_bold, 20)
        categoryTitleLabel.textColor = .black
        categoryTitleLabel.attributedText = addAttributeTitleText(for: HBTIQuantitySelectionData.titleText)
        categoryTitleLabel.textAlignment = .left
        categoryTitleLabel.numberOfLines = 0
    }

    private func addAttributeTitleText(for text: String) -> NSAttributedString {
        let attributtedString = NSMutableAttributedString(string: text)
        let fontSize = UIFont.customFont(.pretendard, 12)
        let range = (text as NSString).range(of: "· 향료 1개 당 990원")
        attributtedString.addAttribute(.font, value: fontSize, range: range)
        
        return attributtedString
    }
    
    private func createCheckButtonView() {
        HBTIQuantitySelectionData.options.forEach { option in
            let checkButtonView = createCheckVerticalView(title: option.title, subtitle: option.subtitle)
            checkVerticalStackView.addArrangedSubview(checkButtonView)
        }
    }
    
    private func createCheckVerticalView(title: String, subtitle: String?) -> UIView {
        let containerView = UIView().then {
            $0.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
            $0.layer.cornerRadius = 5
        }
        
        let circleImage = UIImageView().then {
            $0.image = UIImage(systemName: "circle")
            $0.tintColor = UIColor.customColor(.searchBarColor)
        }
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 14)
            $0.textColor = .black
        }
        
        [
         circleImage,
         titleLabel
        ].forEach(containerView.addSubview)
        
        circleImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(52)
            $0.centerY.equalToSuperview()
        }

        if let subtitle = subtitle {
            let subtitleLabel = UILabel()
            let attributedString = NSMutableAttributedString(string: subtitle)
            
            if let range = subtitle.range(of: "31,900원") {
                let nsRange = NSRange(range, in: subtitle)
                attributedString.addAttributes([
                    .font: UIFont.customFont(.pretendard_semibold, 14),
                    .foregroundColor: UIColor.black
                ], range: nsRange)
            }
            
            if let range = subtitle.range(of: "33,000원") {
                let nsRange = NSRange(range, in: subtitle)
                attributedString.addAttributes([
                    .font: UIFont.customFont(.pretendard_bold, 12),
                    .foregroundColor: UIColor.customColor(.gray3),
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .strikethroughColor: UIColor.red
                ], range: nsRange)
            }
            
            subtitleLabel.attributedText = attributedString
            
            containerView.addSubview(subtitleLabel)
            
            subtitleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(77)
                $0.centerY.equalToSuperview()
            }
        }
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        return containerView
    }
}
