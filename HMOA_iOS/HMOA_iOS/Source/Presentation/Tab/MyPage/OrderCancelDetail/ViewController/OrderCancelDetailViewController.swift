//
//  OrderCancelDetailViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/26/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class OrderCancelDetailViewController: UIViewController, View {

    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    
    private let categoryStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    private let separatorLineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let totalAmountTitleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 18, color: .black)
        $0.setTextWithLineHeight(text: "결제금액", lineHeight: 20)
    }
    
    private let totalAmountValueLabel = UILabel().then {
        $0.setLabelUI("15,000원", font: .pretendard_bold, size: 20, color: .red)
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
    
    func bind(reactor: OrderCancelDetailReactor) {
        
        // MARK: Action
        
        // MARK: State
    }
    
    // MARK: - Functions
    
    private func setUI() {
        setClearBackNaviBar("", .black)
        view.backgroundColor = .white
    }
    
    // MARK: Add Views
    private func setAddView() {
        view.addSubview(scrollView)
        
        [
            categoryStackView,
            separatorLineView,
            totalAmountTitleLabel,
            totalAmountValueLabel
        ]   .forEach { scrollView.addSubview($0) }
        
        [
            OrderCancelCategoryView(),
            OrderCancelCategoryView()
        ]   .forEach {
            $0.configureView()
            $0.snp.makeConstraints { make in
                make.height.greaterThanOrEqualTo(60)
            }
            categoryStackView.addArrangedSubview($0)
        }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.width.equalTo(scrollView.snp.width).offset(-32)
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.top.equalTo(categoryStackView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(categoryStackView.snp.horizontalEdges)
            make.height.equalTo(1)
        }
        
        totalAmountTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLineView.snp.bottom).offset(24)
            make.leading.equalTo(separatorLineView.snp.leading)
        }
        
        totalAmountValueLabel.snp.makeConstraints { make in
            make.top.equalTo(totalAmountTitleLabel.snp.top)
            make.trailing.equalTo(separatorLineView.snp.trailing)
        }
    }
}
