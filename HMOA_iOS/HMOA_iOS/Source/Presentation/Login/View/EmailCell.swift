//
//  EmailCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/02/20.
//

import UIKit

import Then
import SnapKit

class EmailCell: UITableViewCell {
    
    static let identifier = "EmailCell"
    
    let emailLabel = UILabel().then {
        $0.setLabelUI("asdf", font: .pretendard_light, size: 14, color: .gray3)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        contentView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }
    }
    
}
