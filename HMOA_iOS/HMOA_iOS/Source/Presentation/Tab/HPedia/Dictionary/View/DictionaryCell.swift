//
//  DictionaryCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/06.
//

import UIKit

class DictionaryCell: UITableViewCell {
    
    static let identifier = "DictionaryCell"
    
    let englishLabel = UILabel().then {
        $0.setLabelUI("탑", font: .pretendard_semibold, size: 22, color: .black)
    }
    
    let koreanLabel = UILabel().then {
        $0.setLabelUI("sdf", font: .pretendard_semibold, size: 16, color: .black)
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAddView() {
        [
            englishLabel,
            koreanLabel
        ]   .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        englishLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        koreanLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(englishLabel.snp.bottom)
        }
    }
}

extension DictionaryCell {
    func updateCell(_ data: DictionaryData) {
        englishLabel.text = data.englishName
        koreanLabel.text = data.koreanName
    }
}
