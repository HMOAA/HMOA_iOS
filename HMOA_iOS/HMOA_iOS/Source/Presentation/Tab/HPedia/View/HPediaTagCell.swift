//
//  TagCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import UIKit

class TagCell: UITableViewCell {

    let nameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 20, color: .black)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - SetUp
    private func setUpUI() {
        contentView.backgroundColor = .white
    }
    
    private func setAddView() {
        contentView.addSubview(nameLabel)
    }
    
    private func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

}
