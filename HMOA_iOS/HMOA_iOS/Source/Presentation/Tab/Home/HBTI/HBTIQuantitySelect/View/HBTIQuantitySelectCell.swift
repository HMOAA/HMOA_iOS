//
//  HBTIQuantitySelectBottomView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/17/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class HBTIQuantitySelectCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    let quantityButton = HBTIQuantitySelectButton()
    
    private let label1 = UILabel().then {
        $0.setLabelUI("8개", font: .pretendard, size: 14, color: .black)
    }
    
    private let label2 = UILabel().then {
        $0.setLabelUI("31,900원", font: .pretendard_semibold, size: 14, color: .black)
    }
    
    private let label3 = UILabel().then {
        $0.setLabelUI("33,000원", font: .pretendard_bold, size: 12, color: .gray3)
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "33,000원")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.red, range: NSRange(location: 0, length: attributeString.length))
        
        $0.attributedText = attributeString
    }
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddView()
        setConstraints()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: Set UI
    
    private func setUI() {
        selectionStyle = .none
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        contentView.addSubview(quantityButton)
        
        [
         label1,
         label2,
         label3
        ].forEach(quantityButton.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        quantityButton.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
            $0.height.equalTo(50)
        }
        
        label1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(52)
        }
        
        label2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(label1.snp.trailing).offset(4)
        }
        
        label3.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(label2.snp.trailing).offset(6)
        }
    }
    
    func configureCell(quantity: String, isThirdCell: Bool = false) {
        if isThirdCell {
            label1.text = "8개"
            label2.text = "31,900원"
            label3.text = "33,000원"
            label2.isHidden = false
            label3.isHidden = false
        } else {
            quantityButton.quantityLabel.setLabelUI(quantity, font: .pretendard, size: 14, color: .black)
            label1.isHidden = true
            label2.isHidden = true
            label3.isHidden = true
        }
    }
}
