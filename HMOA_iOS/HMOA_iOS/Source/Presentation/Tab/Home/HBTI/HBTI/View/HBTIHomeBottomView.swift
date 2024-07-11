//
//  HBTIHomeBottomView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/11/24.
//

import UIKit

class HBTIHomeBottomView: UIView {

    // MARK: - UI Components
    
    private let introTitleView = UIView()
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "whiteLogo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let introTitleLabel = UILabel().then {
        $0.setLabelUI("향BTI란?", font: .pretendard, size: 20, color: .white)
    }
    
    private let introDesctiptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .white)
        $0.setTextWithLineHeight(text: "공감되는 상황을 통해 알아보는 기능", lineHeight: 17)
    }
    
    private let introStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let firstIntroView = UIIntroView(
        frame: .zero,
        title: "\"엇?! 저 향기 뭐지?\"",
        description: """
        했던 경험 많이들 있으시지 않나요?
        보통 우리는 특정 향수를 선호하기도 하지만, 그 향수를 구성하고 있는 ‘향료’에 이끌려 이런 현상을 경험하게 됩니다.
        """
    )
    
    private let secondIntroView = UIIntroView(
        frame: .zero,
        title: "\"하지만..이게 어떤 향이야?\"",
        description: """
        향료들은 시더우드, 피오니, 베르가못과 같이 우리에게 친숙하지 않은 단어들이 대부분입니다.
        향BTI는 향료들을 소비자에게 직접 배송해서 소비자가 선호하고 원하는 향료를 찾아낼 수 있도록 도움을 제공합니다.
        """
    )
    
    private let thirdIntroView = UIIntroView(
        frame: .zero,
        title: "\"그래서 이 향이 들어간 향수가 뭔데?\"",
        description: """
        소비자가 선호하는 향료 데이터를 수집한 후, 그 향료가 들어간 향수를 종합적으로 추천합니다.
        """
    )
    
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
        [introTitleView,
         introDesctiptionLabel,
         introStackView
        ].forEach{ self.addSubview($0) }
        
        [logoImageView, introTitleLabel
        ].forEach { introTitleView.addSubview($0) }
        
        [firstIntroView,
         secondIntroView,
         thirdIntroView
        ].forEach { introStackView.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
        introTitleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(25)
        }
        
        introTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7.35)
            make.leading.equalTo(logoImageView.snp.trailing).offset(9)
            make.trailing.bottom.equalToSuperview()
        }
        
        introDesctiptionLabel.snp.makeConstraints { make in
            make.top.equalTo(introTitleView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        introStackView.snp.makeConstraints { make in
            make.top.equalTo(introDesctiptionLabel.snp.bottom).offset(24)
            make.leading.trailing.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width - 32)
        }
    }

}

// MARK: UIIntroView
class UIIntroView: UIView {
    
    init(frame: CGRect, title: String, description: String) {
        super.init(frame: frame)
        
        titleLabel.text = title
        descriptionLabel.text = description
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let cellView = UIView().then {
        $0.backgroundColor = UIColor.customColor(.gray5)
        $0.layer.cornerRadius = 5
    }
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 16, color: .white)
        $0.numberOfLines = 0
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .white)
        $0.setTextWithLineHeight(text: "본문", lineHeight: 17)
        $0.numberOfLines = 0
    }
    
    private func setAddView() {
        self.addSubview(cellView)
        
        [titleLabel,
         descriptionLabel
        ].forEach { cellView.addSubview($0) }
    }
    
    private func setConstraints() {
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configureView(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
