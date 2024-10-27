//
//  HBTINotesCategoryButton.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/19/24.
//

import UIKit
import SnapKit
import Then

final class HBTINotesCategoryButton: UIButton {
    
    // MARK: - UI Components
    
    private let customImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 34
    }
    
    private let customTitleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_semibold, 14)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 10)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 3
    }
    
    private let overlayView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        $0.layer.cornerRadius = 34
    }
    
    private let overlayBigCircleView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 38
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    private let overlaySmallCircleView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 34
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    private let selectionIndexLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 14, color: .white)
        $0.textAlignment = .center
    }
    
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

    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         customImageView,
         customTitleLabel,
         descriptionLabel,
         overlayView,
         overlayBigCircleView,
         overlaySmallCircleView,
         selectionIndexLabel
        ].forEach(addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        customImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(68)
        }
        
        customTitleLabel.snp.makeConstraints {
            $0.top.equalTo(customImageView.snp.bottom).offset(12)
            $0.centerX.equalTo(customImageView)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(customTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints {
            $0.edges.equalTo(customImageView)
        }
        
        overlayBigCircleView.snp.makeConstraints {
            $0.center.equalTo(customImageView)
            $0.size.equalTo(76)
        }
        
        overlaySmallCircleView.snp.makeConstraints {
            $0.center.equalTo(customImageView)
            $0.size.equalTo(68)
        }
        
        selectionIndexLabel.snp.makeConstraints {
            $0.center.equalTo(overlayView)
        }
    }
    
    func configureButton(with category: HBTINotesCategoryData) {
        customImageView.image = UIImage(named: category.image)?.resize(targetSize: CGSize(width: 68, height: 68))
        customTitleLabel.text = category.title
        descriptionLabel.text = category.description
    }
    
    func setOverlayVisible(_ isVisible: Bool) {
        overlayView.isHidden = !isVisible
        overlayBigCircleView.isHidden = !isVisible
        overlaySmallCircleView.isHidden = !isVisible
    }
    
    func setSelectionIndexLabel(index: Int?, isVisible: Bool, text: String?, isSelected: Bool) {
        selectionIndexLabel.isHidden = !isVisible
        selectionIndexLabel.text = text ?? index.map { "\($0 + 1)" } ?? ""
        selectionIndexLabel.textColor = isSelected ? .white : .black
    }
}
