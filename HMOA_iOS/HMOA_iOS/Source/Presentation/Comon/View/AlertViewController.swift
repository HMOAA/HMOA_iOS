//
//  AlertView.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/17.
//

import UIKit

import Then
import SnapKit
import RxSwift

final class AlertViewController: UIViewController {
    
    // MARK: - Componenets
    let alertView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 14, color: .black)
    }
    
    let contentLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 12, color: .gray3)
    }
    
    let bottomButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 12)
        $0.backgroundColor = .customColor(.gray3)
    }

    var alertType: AlertType = .login
    
    // MARK: - Properties
    let confirmButtonTapped = PublishSubject<Void>()
    let disposeBag = DisposeBag()

    init(title: String, content: String, buttonTitle: String, type: AlertType? = nil) {
        super .init(nibName: nil, bundle: nil)
        self.updateAlertView(title: title, content: content, buttonTitle: buttonTitle, type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        bind()
    }
    
    private func setUpUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        alertView.layer.cornerRadius = 5
        alertView.clipsToBounds = true
    }
    
    private func setAddView() {
        [
            xButton,
            titleLabel,
            contentLabel,
            bottomButton
        ]   .forEach { alertView.addSubview($0) }
        
        view.addSubview(alertView)
    }
    
    private func setConstraints() {
        alertView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(141)
            make.width.equalTo(296)
        }
        
        xButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(44)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func bind() {
        xButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
        
        bottomButton.rx.tap
            .bind(with: self) { owner, _ in
                switch owner.alertType {
                case .login:
                    guard let presentingVC = owner.presentingViewController else { return }
                    let loginVC = LoginViewController()
                    loginVC.modalPresentationStyle = .fullScreen
                    loginVC.reactor = LoginReactor(.inApp)
                    owner.dismiss(animated: false) {
                        presentingVC.present(loginVC, animated: true)
                    }
                case .refund(let order):
                    if let order = order {
                        HBTIAPI.deletePurchase(orderId: order.id)
                            .subscribe()
                            .disposed(by: owner.disposeBag)
                        owner.updateAlertView(title: "환불이 완료되었습니다.",
                                              content: "환불은 환불 규정에 따라 진행됩니다.",
                                              buttonTitle: "확인",
                                              type: .refund(nil))
                    } else {
                        owner.confirmButtonTapped.onNext(())
                        owner.dismiss(animated: false)
                    }
                    
                case .none:
                    owner.dismiss(animated: false)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func updateAlertView(title: String, content: String, buttonTitle: String, type: AlertType?) {
        titleLabel.text = title
        contentLabel.text = content
        bottomButton.setTitle(buttonTitle, for: .normal)
        
        guard let type = type else { return }
        alertType = type
    }
}
