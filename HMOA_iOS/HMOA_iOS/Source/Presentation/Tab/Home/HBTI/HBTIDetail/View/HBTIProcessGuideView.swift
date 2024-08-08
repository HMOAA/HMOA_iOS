//
//  HBTIProcessInnerView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 7/30/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class HBTIProcessGuideView: UIView {
    let nextButtonTapped = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let processFullStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 34
        $0.distribution = .equalSpacing
    }
    
    private var processPartStackViews: [UIStackView] = []
    private let nextButton = UIButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        let items = [
            ("향료 선택", "향BTI 검사 이후 추천하는 향료, 원하는 향료 선택\n(기격대 상이)"),
            ("배송", "결제 후 1-2일 내 배송 완료"),
            ("향수 추천", "시향 후 가장 좋았던 향료 선택, 향수 추천 받기")
        ]
        
        for (index, item) in items.enumerated() {
            let partStackView = createItemView(number: index + 1, title: item.0, description: item.1)
            processPartStackViews.append(partStackView)
        }
        
        makeHBTIButton(
            nextButton,
            withTitle: "다음",
            withState: .normal
        )
        
        bindButton()
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [processFullStackView,
         nextButton
        ].forEach { self.addSubview($0) }
        
        processPartStackViews.forEach {
            processFullStackView.addArrangedSubview($0)
        }
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        processFullStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(628)
            $0.width.equalTo(328)
            $0.height.equalTo(52)
        }
    }
    
    // MARK: - Make PartStackView
    
    private func createItemView(number: Int, title: String, description: String) -> UIStackView {
        let processPartStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .top
        }
        
        let processLeftStackView = UIStackView().then {
            $0.axis = .vertical
        }
        
        let processRightStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 5
        }
        
        let numberLabel = UILabel().then {
            $0.setLabelUI("\(number)", font: .pretendard, size: 12, color: .black)
            $0.textAlignment = .center
            $0.backgroundColor = UIColor.customColor(.searchBarColor)
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        let titleLabel = UILabel().then {
            $0.setLabelUI(title, font: .pretendard_bold, size: 16, color: .black)
        }
        
        let descriptionLabel = UILabel().then {
            $0.setLabelUI(description, font: .pretendard, size: 12, color: .gray5)
            $0.numberOfLines = 0
        }
        
        processLeftStackView.addArrangedSubview(numberLabel)
        [titleLabel, descriptionLabel].forEach { processRightStackView.addArrangedSubview($0) }
        
        [processLeftStackView, processRightStackView].forEach { processPartStackView.addArrangedSubview($0) }
        
        numberLabel.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        return processPartStackView
    }
    
    private func bindButton() {
        nextButton.rx.tap
            .bind(to: nextButtonTapped)
            .disposed(by: disposeBag)
    }
    
    func makeHBTIButton(_ button: UIButton, withTitle title: String, withState state: UIControl.State) {
        button.setTitle(title, for: state)
        button.setTitleColor(.white, for: state)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
    }
}
