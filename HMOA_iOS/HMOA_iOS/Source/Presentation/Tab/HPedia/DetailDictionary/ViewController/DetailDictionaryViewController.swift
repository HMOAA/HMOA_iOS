//
//  DetailDictionaryViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/06.
//

import UIKit

import ReactorKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class DetailDictionaryViewController: UIViewController, View {

    var disposeBag = DisposeBag()
    
    
    //MARK: - UI Components
    private let titleEnglishLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 30, color: .black)
    }
    
    private let titleKoreanLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 20, color: .black)
    }
    
    private let explainLabel = UILabel().then {
        $0.setLabelUI("내용", font: .pretendard_semibold, size: 16, color: .black)
    }
    
    private let contentLabel = UILabel().then {
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
        $0.setLabelUI("", font: .pretendard, size: 16, color: .black)
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()

    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        [
            titleEnglishLabel,
            titleKoreanLabel,
            explainLabel,
            contentLabel
        ]   .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        titleEnglishLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        titleKoreanLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleEnglishLabel.snp.bottom).offset(12)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleKoreanLabel.snp.bottom).offset(60)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.equalTo(explainLabel.snp.bottom).offset(19)
        }
    }
    
    // MARK: - Bind
    
    func bind(reactor: DetailDictionaryReactor) {
        
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.type.title }
            .bind(onNext: setBackItemNaviBar)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.item }
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, item in
                owner.titleKoreanLabel.text = ": \(item.title)"
                owner.titleEnglishLabel.text = item.subTitle
                owner.contentLabel.text = item.content
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.type }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, type in
                if type == .brand { owner.explainLabel.isHidden = true }
            })
            .disposed(by: disposeBag)
    }
    
    
}
