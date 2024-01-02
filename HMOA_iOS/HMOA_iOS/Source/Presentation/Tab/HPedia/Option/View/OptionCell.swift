//
//  OptionCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/09.
//

import UIKit

class OptionCell: UITableViewCell {

    static let identifer = "OptionCell"
    private let contentLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 20)
        $0.textColor = .systemBlue
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
        selectionStyle = .none
    }
    private func setAddView() {
        addSubview(contentLabel)
    }
    
    private func setConstraints() {
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
 
    func updateCell(content: String) {
        contentLabel.text = content
    }
}
