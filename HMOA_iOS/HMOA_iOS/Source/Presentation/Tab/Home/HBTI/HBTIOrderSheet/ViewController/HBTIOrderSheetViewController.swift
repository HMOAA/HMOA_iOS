//
//  HBTIOrderSheetViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/25/24.
//

import UIKit
import SnapKit
import Then
import Bootpay
import RxSwift
import RxCocoa
import ReactorKit

final class HBTIOrderSheetViewController: UIViewController, View, HBTIProductInfoViewDelegate {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let orderScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
    }
    
    private let orderContentView = UIView()
    
    private let memberInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
    }
    
    private let ordererInfoView = HBTIOrdererInfoView()
    
    private let dividingLineView1 = HBTIOrderDividingLineView(color: .black)
    
    private let addressView = HBTIAddressView()
    
    private let dividingLineView2 = HBTIOrderDividingLineView(color: .black)
    
    private lazy var productInfoView = HBTIProductInfoView().then {
        $0.delegate = self
    }
    
    private let dividingLineView3 = HBTIOrderDividingLineView(color: .black)

    private let totalPaymentView = HBTITotalPaymentView()
    
    private let dividingLineView4 = HBTIOrderDividingLineView(color: .black)
    
    private let agreementView = HBTIAgreementView()
    
    private let payButton = UIButton().then {
        $0.setTitle("결제하기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 15)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .customColor(.gray3)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        dismissKeyboard()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIOrderReactor) {
        
        // MARK: Action
        
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ordererInfoView.saveInfoButton.rx.tap
            .map { Reactor.Action.didTapEnterAddressButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ordererInfoView.modifyInfoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let orderId = self?.reactor?.currentState.orderId ?? 0
                let selectedNoteList = self?.reactor?.currentState.selectedNoteList ?? []
                
                self?.presentHBTIAddFixAddressViewController(title: "주소 변경", orderId: orderId, selectedNoteList: selectedNoteList)
            })
            .disposed(by: disposeBag)
        
        ordererInfoView.nameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.didChangeName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 3개의 전화번호 텍스트 필드 통합 관리
        Observable
            .combineLatest(
                ordererInfoView.contactTextField.contactTextFieldFirst.rx.text.orEmpty,
                ordererInfoView.contactTextField.contactTextFieldSecond.rx.text.orEmpty,
                ordererInfoView.contactTextField.contactTextFieldThird.rx.text.orEmpty
            )
            .map { first, second, third in "\(first)-\(second)-\(third)" }
            .distinctUntilChanged()
            .map { Reactor.Action.didChangePhoneNumber($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addressView.saveDeliveryInfoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let orderId = self?.reactor?.currentState.orderId ?? 0
                let selectedNoteList = self?.reactor?.currentState.selectedNoteList ?? []
                
                self?.presentHBTIAddFixAddressViewController(title: "주소 추가", orderId: orderId, selectedNoteList: selectedNoteList)
            })
            .disposed(by: disposeBag)
                
        productInfoView.productCollectionView.rx.itemSelected
            .compactMap { [weak self] indexPath -> (HBTIProductInfoCell, Int)? in
                guard let cell = self?.productInfoView.productCollectionView.cellForItem(at: indexPath) as? HBTIProductInfoCell else {
                    return nil
                }
                return (cell, indexPath.item)
            }
            .flatMap { cell, itemIndex in
                cell.removeProductButton.rx.tap
                    .map { itemIndex }
            }
            .map { Reactor.Action.didTapRemoveItemButton($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        agreementView.allAgreementButton.rx.tap
            .map { Reactor.Action.didTapAllAgree }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        agreementView.agreementTableView.rx.itemSelected
            .map { indexPath -> Reactor.Action in
                switch indexPath.row {
                case 0:
                    return Reactor.Action.didTapPolicyAgree
                case 1:
                    return Reactor.Action.didTapPersonalInfoAgree
                default:
                    fatalError("Unexpected row index")
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        payButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let totalPrice = self?.reactor?.currentState.totalPrice,
                      let orderId = self?.reactor?.currentState.orderId else { return }
                
                self?.bootpayStart(totalPrice: Double(totalPrice), orderId: String(orderId))
            })
            .disposed(by: disposeBag)
        
        // MARK: State

        reactor.state
            .map { $0.isSavedAddress }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, isSavedAddress in
                let addressName = owner.reactor?.currentState.addressName ?? ""
                let memberName = owner.reactor?.currentState.name ?? ""
                let phoneNumber = owner.reactor?.currentState.phoneNumber ?? ""
                let address = owner.reactor?.currentState.address ?? ""
                
                owner.ordererInfoView.setMemberInfoViewVisible(isSavedAddress: isSavedAddress, addressName: addressName, memberName: memberName, phoneNumber: phoneNumber, address: address)
                owner.addressView.isHidden = isSavedAddress
                owner.dividingLineView1.isHidden = isSavedAddress
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.productList }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                owner.productInfoView.updateSnapshot(forSection: .order, withItems: items)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.totalPrice }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                let totalPrice = owner.reactor?.currentState.totalPrice ?? 0
                let productPrice = owner.reactor?.currentState.productPrice ?? 0
                let shippingPrice = owner.reactor?.currentState.shippingPrice ?? 0
                
                owner.totalPaymentView.setPriceLabelText(totalPrice: totalPrice, productPrice: productPrice, shippingPrice: shippingPrice)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isAllAgree }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isAllAgree in
                guard let self = self else { return }
                
                let image = isAllAgree
                    ? UIImage(named: "checkBoxSelectedSvg")
                    : UIImage(named: "checkBoxNotSelectedSvg")
                
                self.agreementView.allAgreementButton.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .subscribe(onNext: { [weak self] state in
                let policyAgreeIndexPath = IndexPath(row: 0, section: 0)
                let personalInfoIndexPath = IndexPath(row: 1, section: 0)
                
                if let policyAgreeCell = self?.agreementView.agreementTableView.cellForRow(at: policyAgreeIndexPath) as? HBTIAgreementCell {
                    policyAgreeCell.isSelected = state.isPolicyAgree
                }
                
                if let personalInfoCell = self?.agreementView.agreementTableView.cellForRow(at: personalInfoIndexPath) as? HBTIAgreementCell {
                    personalInfoCell.isSelected = state.isPersonalInfoAgree
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPayValid }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isValid in
                self?.payButton.isEnabled = isValid
                self?.payButton.backgroundColor = isValid ? .black : .customColor(.gray3)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Set UI
   
    private func setUI() {
        view.backgroundColor = .white
        setBackToHBTIVCNaviBar("주문서 작성")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         orderScrollView,
         payButton
        ].forEach(view.addSubview)
        
        orderScrollView.addSubview(orderContentView)
        
        [
         memberInfoStackView,
         dividingLineView2,
         productInfoView,
         dividingLineView3,
         totalPaymentView,
         dividingLineView4,
         agreementView
        ].forEach(orderContentView.addSubview)
        
        [
         ordererInfoView,
         dividingLineView1,
         addressView,
        ].forEach(memberInfoStackView.addArrangedSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        orderScrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(payButton.snp.top).offset(-27)
        }
     
        orderContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        memberInfoStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        dividingLineView1.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        dividingLineView2.snp.makeConstraints {
            $0.top.equalTo(memberInfoStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        productInfoView.snp.makeConstraints {
            $0.top.equalTo(dividingLineView2.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        dividingLineView3.snp.makeConstraints {
            $0.top.equalTo(productInfoView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        totalPaymentView.snp.makeConstraints {
            $0.top.equalTo(dividingLineView3.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        dividingLineView4.snp.makeConstraints {
            $0.top.equalTo(totalPaymentView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        agreementView.snp.makeConstraints {
            $0.top.equalTo(dividingLineView4.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        payButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(52)
        }
    }
    
    // MARK: - Other Functions
    
    func productInfoView(_ view: HBTIProductInfoView, didRemoveItemAt index: Int) {
        reactor?.action.onNext(.didTapRemoveItemButton(index))
    }
    
    func bootpayStart(totalPrice: Double, orderId: String) {
        let payload = self.generatePayload(totalPrice: totalPrice, orderId: orderId)
        payload.extra?.separatelyConfirmed = true
        
        Bootpay.requestPayment(
            viewController: self,
            payload: payload,
            isModal: true,
            modalPresentationStyle: .fullScreen,
            animated: true
        )
        .onCancel { data in
            print("-- cancel: \(data)")
        }
        .onIssued { data in
            print("-- issued: \(data)")
        }
        .onConfirm { data in
            print("-- confirm: \(data)")
            
            if let receiptId = data["receipt_id"] as? String {
                let receiptData: [String: String] = [
                    "receiptId": receiptId
                ]
                
                // 서버로 receiptId 전송 및 응답을 받은 후 결제 승인
                HBTIAPI.postPurchaseResult(params: receiptData)
                    .subscribe(onNext: { response in
                        print("==========\n 서버 응답 성공: \(response) \n=========")
                        
                        Bootpay.transactionConfirm() // 결제를 승인
                        
                    }, onError: { error in  // 오류 발생 시 결제를 승인하지 않음
                        print("===========\n 서버 전송 오류: \(error) \n===========")
                    })
                    .disposed(by: self.disposeBag)
            } else {
                print("========\n receiptId를 찾을 수 없습니다. \n========")
            }
            return false // 서버 응답 전까지는 결제를 승인하지 않음
        }
        .onDone { data in
            // 서버 응답 후 결제 승인
            print("-- done: \(data)")
            
            self.presentHBTIOrderResultViewController()
        }
        .onError { data in
            print("-- error: \(data)")
        }
        .onClose {
            print("-- close")
        }
    }
    
    func generatePayload(totalPrice: Double, orderId: String) -> Payload {
        let payload = Payload()
        
        payload.applicationId = Key.BOOTPAY_APP_ID
        payload.orderName = "시향카드 구매"
        payload.price = totalPrice
        payload.orderId = orderId
        
        let extra = BootExtra()
        extra.separatelyConfirmed = true
        
        payload.extra = extra
        
        return payload
    }
    
    private func dismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addDismissKeyboardGesture))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func addDismissKeyboardGesture() {
        self.view.endEditing(true)
    }
}
