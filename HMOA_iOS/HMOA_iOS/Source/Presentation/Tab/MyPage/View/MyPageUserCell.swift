//
//  MyPageTopView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/21.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import Kingfisher

class MyPageUserCell: UITableViewCell, View {
    
    typealias Reactor = MemberCellReactor
    var disposeBag = DisposeBag()
    
    // MARK: - identifier
    static let identifier = "MyPageUserCell"
    
    // MARK: - Properties

    lazy var profileImage = UIImageView().then {
        $0.layer.cornerRadius = 16
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var nickNameLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 20)
    }
    
    lazy var loginTypeLabel = UILabel().then {
        $0.font = .customFont(.pretendard_light, 12)
    }
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Functions

extension MyPageUserCell {
    
    func bind(reactor: MemberCellReactor) {
        
        // MARK: - state
        
        reactor.state
            .map { $0.member.nickname }
            .distinctUntilChanged()
            .bind(to: nickNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.profileImage }
            .distinctUntilChanged()
            .bind(to: profileImage.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.member.provider }
            .bind(to: loginTypeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    func configureUI() {
      
        [   profileImage,
            nickNameLabel,
            loginTypeLabel
        ]   .forEach { addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(32)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImage)
            $0.leading.equalTo(profileImage.snp.trailing).offset(12)
        }
        
        loginTypeLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(nickNameLabel)
        }
    }
    
    func updateCell(_ member: Member, _ image: UIImage?) {
        
        nickNameLabel.text = member.nickname
        loginTypeLabel.text = member.provider
        profileImage.image = image
    }
}
