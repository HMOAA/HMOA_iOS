//
//  LoginStartVC.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/21.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

class LoginStartViewController: UIViewController {

    // MARK: - UIComponents
    
    private let welcomLabel = UILabel().then {
        $0.setLabelUI("환영합니다", font: .pretendard_medium, size: 30, color: .black)
    }
    
    private let explainLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.setLabelUI(
                        """
                        향모아를 시작하기 위해
                        간단한 몇가지 정보만 입력해주세요!
                        """,
                        font: .pretendard,
                        size: 16,
                        color: .black)
    }
    
    private let nextButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 16)
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setAddView()
        setConstraints()
        bind()
    }
    
    //MARK: - SetUp
    
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        [welcomLabel,
         explainLabel,
         nextButton].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        
        welcomLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(215)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(welcomLabel.snp.bottom).offset(12)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        nextButton.rx.tap
            .bind(onNext: {
                self.navigationController?.pushViewController(NicknameViewController(reactor: NicknameReactor()), animated: true)
            }).disposed(by: disposeBag)
    }
    
}
