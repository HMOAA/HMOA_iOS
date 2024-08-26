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

class HBTIOrderSheetViewController: UIViewController {
    
    // MARK: - Properties
    
    var appId = "5b8f6a4d396fa665fdc2b5e9"
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
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
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         payButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
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
