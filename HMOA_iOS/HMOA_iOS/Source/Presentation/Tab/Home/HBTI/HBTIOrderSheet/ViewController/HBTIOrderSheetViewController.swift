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

final class HBTIOrderSheetViewController: UIViewController, View {
    
    // MARK: - Properties
    
    var appId = "5b8f6a4d396fa665fdc2b5e9"
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let orderScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
    }
    
    private let orderContentView = UIView()
    
    private let ordererInfoView = HBTIOrdererInfoView()
    
    private let dividingLineView1 = HBTIOrderDividingLineView(color: .black)
    
    private let addressView = HBTIAddressView()
    
    private let dividingLineView2 = HBTIOrderDividingLineView(color: .black)
    
    private let productInfoView = HBTIProductInfoView()
    
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
                self?.presentHBTIAddFixAddressViewController(title: "주소 추가")
            })
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
                self?.bootpayStart()
            })
            .disposed(by: disposeBag)
        
        // MARK: State

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
        setBackItemNaviBar("주문서 작성")
        view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         orderScrollView,
         payButton
        ].forEach(view.addSubview)
        
        orderScrollView.addSubview(orderContentView)
        
        [
         ordererInfoView,
         dividingLineView1,
         addressView,
         dividingLineView2,
         productInfoView,
         dividingLineView3,
         totalPaymentView,
         dividingLineView4,
         agreementView
        ].forEach(orderContentView.addSubview)
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

        ordererInfoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        dividingLineView1.snp.makeConstraints {
            $0.top.equalTo(ordererInfoView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        addressView.snp.makeConstraints {
            $0.top.equalTo(dividingLineView1.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        dividingLineView2.snp.makeConstraints {
            $0.top.equalTo(addressView.snp.bottom)
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
    
    func bootpayStart() {
        let payload = generatePayload()
        
        Bootpay.requestPayment(viewController: self,
                               payload: payload,
                               isModal: true,
                               modalPresentationStyle: .fullScreen,
                               animated: true)
        
            .onCancel { data in
                print("-- cancel: \(data)")
            }
            .onIssued { data in
                print("-- issued: \(data)")
            }
            .onConfirm { data in
                print("-- confirm: \(data)")
                return true //재고가 있어서 결제를 최종 승인하려 할 경우
//                Bootpay.transactionConfirm()
//                return false //재고가 없어서 결제를 승인하지 않을때
            }
            .onDone { data in
                print("-- done: \(data)")
            }
            .onError { data in
                print("-- error: \(data)")
            }
            .onClose {
                print("-- close")
                self.presentHBTIOrderSheetViewController()
            }
    }
    
    func generatePayload() -> Payload {
        let payload = Payload()
        payload.applicationId = appId
        
        payload.price = 15600
        payload.orderId = String(NSTimeIntervalSince1970)
        payload.orderName = "시향카드 구매"
        
        let item1 = BootItem()
        item1.name = "프루트"
        item1.qty = 1
        item1.id = "3"
        item1.price = 4800

        let item2 = BootItem()
        item2.name = "플로럴"
        item2.qty = 1
        item2.id = "4"
        item2.price = 4800
        
        let item3 = BootItem()
        item3.name = "시트러스"
        item3.qty = 1
        item3.id = "1"
        item3.price = 6000
        
        payload.items = [item1, item2, item3]
        
        let testUser = BootUser()
        testUser.userId = "1"
        testUser.username = "Test1"
        testUser.phone = "01012345678"
        
        payload.user = testUser
        
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
