//
//  HPediaQnAHeaderView.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/06.
//

import UIKit

import Then
import SnapKit
import RxSwift

class HPediaQnAHeaderView: UICollectionReusableView {
    static let identifier = "HPediaQnAHeaderView"
    //MARK: - UI Components
    let titleLabel = UILabel().then {
        $0.setLabelUI("Community", font: .pretendard, size: 20, color: .black)
    }
    
    let allButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_light, 12)
        $0.setTitle("전체보기", for: .normal)
    }
    
    var disposeBag = DisposeBag()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    //MARK: - SetUp
    private func setAddView() {
        [
            titleLabel,
            allButton
        ]   .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        allButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
}
