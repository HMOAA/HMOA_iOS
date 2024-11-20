//
//  PushAlarmCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 6/27/24.
//

import UIKit
import Then
import Kingfisher
import SnapKit

class PushAlarmCell: UITableViewCell {
    
    // MARK: - identifier
    
    static let identifier = "PushAlarmCell"
    
    // MARK: - Properties
    
    private let iconImageView = UIImageView().then {
        $0.image = UIImage(named: "pushAlarmIcon")
    }
    
    private let infoView = UIView()
    
    private let categoryLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 12)
        $0.setTextWithLineHeight(text: "Category", lineHeight: 14)
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 14)
        $0.numberOfLines = 0
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 10)
        $0.setTextWithLineHeight(text: "Date", lineHeight: 14)
        $0.textColor = #colorLiteral(red: 0.3921568394, green: 0.3921568394, blue: 0.3921568394, alpha: 1)
    }
    
    // MARK: - Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddView()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func setAddView() {
        [categoryLabel, contentLabel, dateLabel].forEach {
            infoView.addSubview($0)
        }
        
        [iconImageView, infoView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraint() {
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.width.equalTo(32)
        }
        
        infoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureCell(_ pushAlarm: PushAlarm) {
        iconImageView.kf.setImage(with: URL(string: pushAlarm.senderProfileImage))
        categoryLabel.text = pushAlarm.category
        contentLabel.text = pushAlarm.content
        dateLabel.text = pushAlarm.pushDate
        backgroundColor = pushAlarm.isRead ? .customColor(.gray1) : .white
    }
}
