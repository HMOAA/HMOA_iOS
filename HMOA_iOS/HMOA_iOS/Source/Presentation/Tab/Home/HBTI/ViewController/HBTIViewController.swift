//
//  HBTIViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/11/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class HBTIViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView().then{
        $0.backgroundColor = .black
    }
    
    private let yourHBTIView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("당신의 향BTI는 무엇일까요?", font: .pretendard, size: 20, color: .white)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .white)
        $0.setTextWithLineHeight(text: "검사를 통해 좋아하는 향료와\n향수까지 알아보세요!", lineHeight: 17)
        $0.numberOfLines = 2
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    private let goToSurveyButton = UIButton().then {
        $0.setTitle("향BTI\n검사하러 가기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
        $0.setBackgroundImage(UIImage(named: "goToSurvey"), for: .normal)
    }
    
    private let selectSpiceButton = UIButton().then {
        $0.setTitle("향료 입력하기\n(주문 후)", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
        $0.setBackgroundImage(UIImage(named: "selectSpice"), for: .normal)
    }
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    private func setUI() {
        view.backgroundColor = .black
    }
    
    private func setAddView() {
        [titleLabel,
         descriptionLabel,
         buttonStackView
        ].forEach { yourHBTIView.addSubview($0) }
        
        [goToSurveyButton, selectSpiceButton
        ].forEach { buttonStackView.addArrangedSubview($0)}
        
        [yourHBTIView
        ].forEach { scrollView.addSubview($0) }
        
        view.addSubview(scrollView)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        yourHBTIView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(107)
        }
    }
}
