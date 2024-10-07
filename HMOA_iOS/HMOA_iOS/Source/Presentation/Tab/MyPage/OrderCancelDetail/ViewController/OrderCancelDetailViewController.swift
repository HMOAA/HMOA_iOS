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
    
    private let containerView = UIView()
    
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
    
    private var totalAmountValueLabel = UILabel().then {
        $0.setLabelUI("15,000원", font: .pretendard_bold, size: 20, color: .red)
    }
    
    private let paymentInfoView = UIView()
    
    private let decoLineView1 = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
    }
    
    private var productPriceView = ProductPriceView()
    
    private var shippingPriceView = ProductPriceView()
    
    private var decoLineView2 = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
    }
    
    private let totalRefundPriceView = ProductPriceView()
    
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
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        
        reactor.state
            .map { $0.requestKind }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, requestKind in
                owner.paymentInfoView.isHidden = requestKind == .returnRequest
                owner.setCancelButtonTitleLabel(requestKind)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.order }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, order in
                let categoryList = order.order!.products.categoryListInfo.categoryList
                owner.addItemToCategoryStackView(item: categoryList)
                let orderInfo = order.order!.products
                owner.setPriceLabels(orderInfo)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    
    private func setUI() {
        setClearBackNaviBar("", .black)
        view.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
    }
    
    // MARK: Add Views
    private func setAddView() {
        [
            scrollView,
            cancelButton
        ]   .forEach { view.addSubview($0) }
        scrollView.addSubview(containerView)
        
        [
            categoryStackView,
            separatorLineView,
            totalAmountTitleLabel,
            totalAmountValueLabel,
            paymentInfoView
        ]   .forEach { containerView.addSubview($0) }
        
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
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(cancelButton.snp.top).offset(-5)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalToSuperview().inset(100)
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
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
            make.bottom.equalToSuperview()
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
            make.bottom.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(categoryStackView.snp.horizontalEdges)
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(52)
        }
    }
}

extension OrderCancelDetailViewController {
    private func setCancelButtonTitleLabel(_ requestKind: OrderCancelRequestKind) {
        if requestKind == .refundRequest {
            cancelButton.setTitle("환불 신청", for: .normal)
        } else {
            cancelButton.setTitle("반품 신청(1대 1 문의)", for: .normal)
        }
    }
    
    private func addItemToCategoryStackView(item: [HBTICategory]) {
        item.map { category in
            let view = OrderCancelCategoryView()
            view.configureView(category: category)
            return view
        }.forEach { view in
            view.snp.makeConstraints { make in
                make.height.greaterThanOrEqualTo(60)
            }
            categoryStackView.addArrangedSubview(view)
        }
    }
    
    private func setPriceLabels(_ order: OrderInfo) {
        totalAmountValueLabel.text = order.totalAmount.numberFormatterToHangulWon()
        productPriceView.configureView(title: "총 상품금액", price: order.paymentAmount, color: .gray3)
        shippingPriceView.configureView(title: "배송비", price: order.shippingFee, color: .gray3)
        totalRefundPriceView.configureView(title: "총 환불금액", price: order.totalAmount, color: .black)
    }
}
