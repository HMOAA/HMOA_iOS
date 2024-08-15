//
//  HBTINotesCategoryView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 7/30/24.


import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class HBTINotesCategoryView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let categoryTitleLabel = UILabel().then {
        $0.text = HBTINotesCategoryData.titleText
        $0.font = .customFont(.pretendard_bold, 20)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private let categoryDescriptionLabel = UILabel().then {
        $0.text = HBTINotesCategoryData.descriptionText
        $0.font = .customFont(.pretendard, 14)
        $0.textColor = .customColor(.gray5)
    }
    
    private let gridStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 16
    }
    
    private let row1 = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
    }

    private let row2 = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
    }

    private let row3 = UIView()
    
    private var buttons: [UIView] = []
    
//    추후 선택된 버튼들을 위한 배열
//    private var selectedButtons: [UIView] = []
    
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .customColor(.gray3)
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 18)
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setMakeButtons()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAddView() {
        [
         categoryTitleLabel,
         categoryDescriptionLabel,
         scrollView,
         nextButton
        ].forEach(addSubview)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(gridStackView)
        
        [0, 1, 2].forEach { row1.addArrangedSubview(buttons[$0]) }
        [3, 4, 5].forEach { row2.addArrangedSubview(buttons[$0]) }
        row3.addSubview(buttons[6])
        
        [
         row1,
         row2,
         row3
        ].forEach(gridStackView.addArrangedSubview)
    }
    
    private func setConstraints() {
        categoryTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        categoryDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(220)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(categoryDescriptionLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        gridStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        buttons[6].snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo((UIScreen.main.bounds.width - 64) / 3)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
    }
    
    private func setMakeButtons() {
        for data in HBTINotesCategoryData.data {
            let button = createButton(title: data.title, imageName: data.image, description: data.description)
            buttons.append(button)
        }
    }
    
    private func createButton(title: String, imageName: String, description: String) -> UIView {
        let containerView = UIView()
        
        let imageButton = UIButton().then {
            $0.setImage(UIImage(named: imageName)?.resize(targetSize: CGSize(width: 68, height: 68)), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 34
            $0.clipsToBounds = true
        }
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.textAlignment = .center
            $0.font = .customFont(.pretendard_semibold, 14)
            $0.textColor = .black
        }
        
        let descriptionLabel = UILabel().then {
            $0.text = description
            $0.textAlignment = .center
            $0.font = .customFont(.pretendard, 10)
            $0.textColor = .black
            $0.numberOfLines = 3
        }
        
        [
         imageButton,
         titleLabel,
         descriptionLabel
        ].forEach(containerView.addSubview)
        
        imageButton.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(68)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageButton.snp.bottom).offset(12)
            $0.centerX.equalTo(imageButton)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(36)
        }
        
        return containerView
    }
}
