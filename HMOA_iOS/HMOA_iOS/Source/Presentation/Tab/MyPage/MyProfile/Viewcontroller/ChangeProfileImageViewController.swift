//
//  ChangeProfileImageViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/07/02.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher

class ChangeProfileImageViewController: UIViewController, View {

    // MARK: - UI Component
    typealias Reactor = ChangeProfileImageReactor
    var disposeBag = DisposeBag()
    
    lazy var profileImageView: UIImageView = UIImageView().then {
        $0.backgroundColor = .customColor(.gray3)
        $0.layer.cornerRadius = 25
    }
    
    lazy var showAlbumButton: UIButton = UIButton().then {
        var configure = UIButton.Configuration.plain()
        var attributedString = AttributedString.init("사진 선택")
        attributedString.font = .customFont(.pretendard_light, 14)
        
        configure.baseForegroundColor = .white
        configure.attributedTitle = attributedString
        
        $0.configuration = configure
        $0.backgroundColor = .black
    }
    
    lazy var changeButton: UIButton = UIButton().then {
        $0.setProfileChangeBottomView()
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackItemNaviBar("프로필 이미지")
        configureUI()
    }
}

extension ChangeProfileImageViewController {
    
    
    // MARK: - bind
    
    func bind(reactor: ChangeProfileImageReactor) {
        
        reactor.state
            .map { $0.profileImageUrl }
            .compactMap { $0 }
            .map { URL(string: $0) }
            .bind(onNext: { url in
                self.profileImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    func configureUI() {
        
        view.backgroundColor = .white
        
        [
            profileImageView,
            showAlbumButton,
            changeButton
        ]   .forEach { view.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.width.height.equalTo(50)
        }
        
        showAlbumButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.width.equalTo(100)
        }
        
        changeButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
}
