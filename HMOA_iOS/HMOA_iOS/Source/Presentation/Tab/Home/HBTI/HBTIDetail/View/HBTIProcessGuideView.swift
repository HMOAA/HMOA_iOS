//
//  HBTIProcessInnerView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 7/29/24.
//

import UIKit
import SnapKit
import Then

class HBTIProcessGuideView: UIView {
    // MARK: - UI Components
    
    private let processFullStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 34
        $0.distribution = .equalSpacing
    }
    
    private var processPartStackViews: [UIStackView] = []
    
    private let lineView = UIView().then {
        $0.backgroundColor = UIColor.customColor(.searchBarColor)
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.customFont(.pretendard_semibold, 18)
    }
    
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
        createPartStackView()
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
         processFullStackView,
         nextButton
        ].forEach(self.addSubview)
        
        processFullStackView.addSubview(lineView)
        processPartStackViews.forEach(processFullStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        processFullStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        lineView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.top.equalTo(processPartStackViews.first!.snp.top).offset(10)
            $0.bottom.equalTo(processPartStackViews.last!.snp.top)
            $0.leading.equalTo(processPartStackViews.first!).offset(9)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(52)
        }
    }
    
    // MARK: - Make PartStackView
    
    private func createPartStackView() {
        for data in HBTIProcessGuideData.data {
            let partStackView = createItemView(number: data.index, title: data.title, description: data.description)
            processPartStackViews.append(partStackView)
        }
    }
    
    private func createItemView(number: Int, title: String, description: String) -> UIStackView {
        let processPartStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.alignment = .top
        }
        
        let processLeftStackView = UIStackView().then {
            $0.axis = .vertical
        }
        
        let processRightStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 6
        }
        
        let numberLabel = UILabel().then {
            $0.setLabelUI("\(number)", font: .pretendard_medium, size: 12, color: .black)
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
        
        [
         titleLabel,
         descriptionLabel
        ].forEach(processRightStackView.addArrangedSubview)
        
        [
         processLeftStackView,
         processRightStackView
        ].forEach(processPartStackView.addArrangedSubview)
        
        numberLabel.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        return processPartStackView
    }
}
