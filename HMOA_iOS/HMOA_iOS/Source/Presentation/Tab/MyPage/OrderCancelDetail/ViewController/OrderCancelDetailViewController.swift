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
    
    private let paymentInfoView = UIView()
    
    private let decoLineView1 = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
    }
    
    private let productPriceView = ProductPriceView().then {
        $0.configureView(title: "총 상품금액", price: 9999, color: .gray3)
    }
    
    private let shippingPriceView = ProductPriceView().then {
        $0.configureView(title: "배송비", price: 3333, color: .gray3)
    }
    
    private let decoLineView2 = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
    }
    
    private let totalRefundPriceView = ProductPriceView().then {
        $0.configureView(title: "총 환불금액", price: 11111, color: .black)
    }
    
    private let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 15)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .black
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
            totalAmountValueLabel,
            paymentInfoView,
            cancelButton
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
        
        [
            decoLineView1,
            productPriceView,
            shippingPriceView,
            decoLineView2,
            totalRefundPriceView
        ]   .forEach { paymentInfoView.addSubview($0) }
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
        
        paymentInfoView.snp.makeConstraints { make in
            make.top.equalTo(totalAmountTitleLabel.snp.bottom).offset(24)
            make.leading.equalTo(totalAmountTitleLabel.snp.leading)
            make.trailing.equalTo(totalAmountValueLabel.snp.trailing)
        }
        
        decoLineView1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        productPriceView.snp.makeConstraints { make in
            make.top.equalTo(decoLineView1.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
        
        shippingPriceView.snp.makeConstraints { make in
            make.top.equalTo(productPriceView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }
        
        decoLineView2.snp.makeConstraints { make in
            make.top.equalTo(shippingPriceView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        totalRefundPriceView.snp.makeConstraints { make in
            make.top.equalTo(decoLineView2.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(categoryStackView.snp.horizontalEdges)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
            make.height.equalTo(52)
        }
    }
}
