//
//  HBTIHomeTopView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/11/24.
//

import UIKit

import SnapKit
import Then

class HBTIHomeTopView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("당신의 향BTI는 무엇일까요?", font: .pretendard, size: 20, color: .white)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .white)
        $0.setTextWithLineHeight(text: "검사를 통해 좋아하는 향료와\n향수까지 알아보세요!", lineHeight: 17)
        $0.numberOfLines = 2
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    let goToSurveyButton = UIButton()
    
    let selectSpiceButton = UIButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        configureButton(
            goToSurveyButton,
            withTitle: "향BTI\n검사하러 가기",
            imageName: "goToSurvey"
        )
        
        configureButton(
            selectSpiceButton,
            withTitle: "향료 입력하기\n(주문 후)",
            imageName: "selectSpice"
        )
    }
    
    private func setAddView() {
        [titleLabel,
         descriptionLabel,
         buttonStackView
        ].forEach { self.addSubview($0) }
        
        [goToSurveyButton, selectSpiceButton
        ].forEach { buttonStackView.addArrangedSubview($0)}
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(107)
        }
    }
    
    private func configureButton(_ button: UIButton, withTitle title: String, imageName: String) {
        button.titleLabel?.numberOfLines = 0
        button.setTitleColor(.black, for: .normal)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.minimumLineHeight = 24
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customFont(.pretendard_bold, 16)
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .top
        button.titleEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0)
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setBackgroundImage(UIImage(named: imageName), for: .normal)
    }
}
