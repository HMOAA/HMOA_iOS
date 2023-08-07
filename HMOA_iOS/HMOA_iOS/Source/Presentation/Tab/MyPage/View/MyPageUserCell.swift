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
import RxCocoa
import Kingfisher

class MyPageUserCell: UITableViewCell, View {
    
    typealias Reactor = MemberCellReactor
    var disposeBag = DisposeBag()
    
    // MARK: - identifier
    static let identifier = "MyPageUserCell"
    
    // MARK: - Properties

    lazy var profileImage = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 22
    }
    
    lazy var nickNameLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 20)
    }
    
    lazy var loginTypeLabel = UILabel().then {
        $0.font = .customFont(.pretendard_light, 12)
    }
    
    lazy var editButton = UIButton().then {
        $0.tintColor = .customColor(.gray2)
        $0.setImage(UIImage(named: "edit"), for: .normal)
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
        //MARK: - Action
        print("34")
//        editButton.rx.tap
//            .map { Reactor.Action.didTapEditButton }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
    }
    
    func setupButtonTapHandling() {
        editButton.rx.tap
            .map { Reactor.Action.didTapEditButton } // 버튼 탭 이벤트를 리액터 액션으로 변환
            .bind(to: reactor!.action) // 리액터로 액션 전달
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    func configureUI() {
      
        [   profileImage,
            nickNameLabel,
            loginTypeLabel,
            editButton
        ]   .forEach { addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(44)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(profileImage.snp.trailing).offset(12)
        }
        
        loginTypeLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileImage.snp.bottom)
            $0.leading.equalTo(nickNameLabel)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(34)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(20)
        }
    }
    
    func updateCell(_ member: Member, _ image: UIImage?) {
        
        nickNameLabel.text = member.nickname
        loginTypeLabel.text = member.provider
        profileImage.image = image
    }
}
