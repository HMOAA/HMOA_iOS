//
//  HBTIHomeSurveyCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/23/24.
//

import UIKit

import Then
import SnapKit

final class HBTIHomeSurveyCell: UICollectionViewCell {
    
    static let identifier = "HBTIHomeSurveyCell"
    
    // MARK: - UI Components
    
    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 16, color: .black)
        $0.setTextWithLineHeight(text: "제목", lineHeight: 18)
        $0.numberOfLines = 2
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
    
    // MARK: - Function
    
    private func setAddView() {
        [
            backgroundImageView,
            titleLabel
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
    }
    
    func configureCell(survey: HBTIHomeSurvey) {
        titleLabel.text = survey.title
        backgroundImageView.image = UIImage(named: survey.imageName)
    }
}

