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

final class HBTIOrderSheetViewController: UIViewController {
    
    // MARK: - Properties
    
    var appId = "5b8f6a4d396fa665fdc2b5e9"
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let orderScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
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
    
    private let paymentMethodView = HBTIPaymentMethodView()
    
    private let dividingLineView5 = HBTIOrderDividingLineView(color: .black)
    
    private let agreementView = HBTIAgreementView()
    
    private let payButton = UIButton().then {
        $0.setTitle("결제하기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 15)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .black
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        bind()
    }
    
    // MARK: - Bind
    
    func bind() {
        
        // MARK: Action
        
        payButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.bootpayStart()
            })
            .disposed(by: disposeBag)
        
        // MARK: State
        
    }
    
    // MARK: Set UI
   
    private func setUI() {
        setBackItemNaviBar("주문서 작성")
        
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
         paymentMethodView,
         dividingLineView5,
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
        
        paymentMethodView.snp.makeConstraints {
            $0.top.equalTo(dividingLineView4.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        dividingLineView5.snp.makeConstraints {
            $0.top.equalTo(paymentMethodView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        agreementView.snp.makeConstraints {
            $0.top.equalTo(dividingLineView5.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        payButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(52)
        }
    }
    
    // MARK: - Functions
    
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
}


// TODO: -
// 2. addAddressvc 스크롤뷰 추가
// 3. 프로덕트인포뷰 테이블뷰 높이?
// 4. 전화번호 텍스트필드 한글, 영문, 특수문자 입력 안되도록, 3글자 및 4글자 입력 제한
// 5. addVC를 addFixVC로 이름 변경
