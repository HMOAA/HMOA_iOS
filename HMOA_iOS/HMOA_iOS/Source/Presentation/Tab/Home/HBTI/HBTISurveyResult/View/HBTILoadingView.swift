//
//  HBTILoadingView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/12/24.
//

import UIKit

import Gifu
import SnapKit
import Then

class HBTILoadingView: UIView {

    // MARK: - UI Components
    
    private let loadingImage = GIFImageView().then {
        $0.animate(withGIFNamed: "loading")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = UIColor.random
    }
    
    private let waitLabel = UILabel().then {
        $0.setLabelUI("잠시만 기다려주세요...", font: .pretendard, size: 16, color: .black)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 22, color: .black)
        $0.setTextWithLineHeight(text: "OOO님에게 딱 맞는 \n향료를 추천하는 중입니다.", lineHeight: 28)
        $0.numberOfLines = 2
        $0.lineBreakStrategy = .hangulWordPriority
        $0.textAlignment = .center
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
            loadingImage,
            waitLabel,
            descriptionLabel
        ] .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        loadingImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.width.equalTo(110)
        }
        
        waitLabel.snp.makeConstraints { make in
            make.top.equalTo(loadingImage.snp.bottom).offset(28)
            make.centerX.equalTo(loadingImage.snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(waitLabel.snp.bottom).offset(15)
            make.centerX.bottom.equalToSuperview()
        }
    }
    
    func setDescriptionLabelText(with username: String) {
        descriptionLabel.text = "\(username)님에게 딱 맞는 \n향료를 추천하는 중입니다."
    }
}
