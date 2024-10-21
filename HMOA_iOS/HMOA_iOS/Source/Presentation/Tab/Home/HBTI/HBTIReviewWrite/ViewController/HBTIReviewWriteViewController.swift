//
//  HBTIReviewWriteViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/21/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HBTIReviewWriteViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    // Navigation bar items
    private let okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
    }
    
    private let titleNaviLabel = UILabel().then {
        $0.setLabelUI("향BTI 후기", font: .pretendard_medium, size: 20, color: .white)
        $0.font = .customFont(.pretendard_medium, 20)
    }
    
    private let cancleButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
        $0.setTitleColor(.white, for: .normal)
    }
    
    // writing area items
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIStackView()
    
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
    
    func bind(reactor: HBTIReviewWriteReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        setOkCancleNavigationBar(okButton: okButton, cancleButton: cancleButton, titleLabel: titleNaviLabel)
        navigationController?.navigationBar.backgroundColor = .customColor(.gray4)
        navigationController?.navigationBar.standardAppearance.backgroundColor = .customColor(.gray4)
        view.backgroundColor = .customColor(.gray4)
    }
    
    // MARK: Add Views
    private func setAddView() {
        [
            backgroundView
        ].forEach { view.addSubview($0) }
        
        [
            scrollView
        ].forEach { backgroundView.addSubview($0) }
        
        [
            contentView
        ].forEach { scrollView.addSubview($0) }
        
        [
            
        ].forEach { contentView.addArrangedSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(24)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(32)
        }
    }
}

