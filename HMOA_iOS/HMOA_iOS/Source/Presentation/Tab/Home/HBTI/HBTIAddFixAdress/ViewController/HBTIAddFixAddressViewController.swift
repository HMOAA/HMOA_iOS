//
//  HBTIAddAddressViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/2/24.
//

import UIKit
import SnapKit
import Then
import ReactorKit

final class HBTIAddFixAddressViewController: UIViewController, View {

    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
    }
    
    private let contentView = UIView()

    private let receiverInfoLabel = UILabel().then {
        $0.setLabelUI("배송자 정보", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private let receiverNameLabel = UILabel().then {
        $0.setLabelUI("이름", font: .pretendard_medium, size: 12, color: .black)
    }
    
    lazy var receiverNameTextField = UITextField().then {
        $0.setTextFieldUI("수령인", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.delegate = self
        $0.returnKeyType = .next
    }
    
    lazy var receiverAddressNameLabel = UILabel().then {
        $0.setLabelUI("배송지명(선택)", font: .pretendard_medium, size: 12, color: .black)
    }
    
    lazy var receiverAddressNameTextField = UITextField().then {
        $0.setTextFieldUI("배송지명", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.delegate = self
        $0.returnKeyType = .next
    }
    
    private let phoneNumberTextFieldView = HBTIContactTextFieldView(title: "휴대전화")
    
    private let contactTextFieldView = HBTIContactTextFieldView(title: "전화번호")
    
    lazy var addressTextFieldView = HBTIAddressTextFieldView(title: "주소").then {
        $0.delegate = self
    }

    private let deliveryRequestLabel = UILabel().then {
        $0.setLabelUI("배송 요청사항(선택)", font: .pretendard_medium, size: 12, color: .black)
    }
    
    lazy var deliveryRequestTextField = UITextField().then {
        $0.setTextFieldUI("배송 시 요청사항을 선택해주세요", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.delegate = self
        $0.returnKeyType = .done
    }
    
    private let saveAddressInfoButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 15)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        dismissKeyboard()
        setKeyboardObservers()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIAddFixReactor) {
        
        // MARK: Action
        
        receiverNameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.didChangeName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        receiverAddressNameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.didChangeAddressName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                phoneNumberTextFieldView.contactTextFieldFirst.rx.text.orEmpty,
                phoneNumberTextFieldView.contactTextFieldSecond.rx.text.orEmpty,
                phoneNumberTextFieldView.contactTextFieldThird.rx.text.orEmpty
            )
            .map { first, second, third in "\(first)-\(second)-\(third)" }
            .distinctUntilChanged()
            .map { Reactor.Action.didChangePhoneNumber($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                contactTextFieldView.contactTextFieldFirst.rx.text.orEmpty,
                contactTextFieldView.contactTextFieldSecond.rx.text.orEmpty,
                contactTextFieldView.contactTextFieldThird.rx.text.orEmpty
            )
            .map { first, second, third in "\(first)-\(second)-\(third)" }
            .distinctUntilChanged()
            .map { Reactor.Action.didChangeTelephoneNumber($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addressTextFieldView.detailAddressTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.didChangeDetailAddress($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        deliveryRequestTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.didChangeOrderRequest($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveAddressInfoButton.rx.tap
            .map { Reactor.Action.didTapSaveButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        
        reactor.state
            .map { $0.title }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] title in
                self?.setBackItemNaviBar(title)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isEnabledSaveButton }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, isEnabled in
                owner.saveAddressInfoButton.isEnabled = isEnabled
                owner.saveAddressInfoButton.backgroundColor = isEnabled ? .black : .customColor(.gray3)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushVC }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentHBTIOrderSheetViewController()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Set UI
   
    private func setUI() {
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
         scrollView,
         saveAddressInfoButton
        ].forEach(view.addSubview)
        
        scrollView.addSubview(contentView)
        
        [
         receiverInfoLabel,
         receiverNameLabel,
         receiverNameTextField,
         receiverAddressNameLabel,
         receiverAddressNameTextField,
         phoneNumberTextFieldView,
         contactTextFieldView,
         addressTextFieldView,
         deliveryRequestLabel,
         deliveryRequestTextField
        ].forEach(contentView.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(saveAddressInfoButton.snp.top).offset(-27)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        receiverInfoLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        receiverNameLabel.snp.makeConstraints {
            $0.top.equalTo(receiverInfoLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        receiverNameTextField.snp.makeConstraints {
            $0.top.equalTo(receiverNameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        receiverAddressNameLabel.snp.makeConstraints {
            $0.top.equalTo(receiverNameTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        receiverAddressNameTextField.snp.makeConstraints {
            $0.top.equalTo(receiverAddressNameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        phoneNumberTextFieldView.snp.makeConstraints {
            $0.top.equalTo(receiverAddressNameTextField.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contactTextFieldView.snp.makeConstraints {
            $0.top.equalTo(phoneNumberTextFieldView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        addressTextFieldView.snp.makeConstraints {
            $0.top.equalTo(contactTextFieldView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        deliveryRequestLabel.snp.makeConstraints {
            $0.top.equalTo(addressTextFieldView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        deliveryRequestTextField.snp.makeConstraints {
            $0.top.equalTo(deliveryRequestLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
        
        saveAddressInfoButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(52)
        }
    }
}

extension HBTIAddFixAddressViewController {
    
    // MARK: Other Functions
    
    private func dismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addDismissKeyboardGesture))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func addDismissKeyboardGesture() {
        self.view.endEditing(true)
    }

    private func setKeyboardObservers() {
        // 키보드가 나타날 때 호출
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .keyboardWillShow, object: nil)
        
        // 키보드가 사라질 때 호출
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .keyboardWillHide, object: nil)
    }
    
    // 키보드가 나타날 때 스크롤뷰의 contentInset을 조정
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        // 스크롤뷰의 인셋을 키보드 높이에 맞게 조정
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    // 키보드가 사라질 때 스크롤뷰의 contentInset을 원래대로 복원
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

extension HBTIAddFixAddressViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 배송자 정보 중 이름 textField만 입력 제한
        if textField == receiverNameTextField {
            let restrictedCharacters = CharacterSet
                                            .decimalDigits
                                            .union(.punctuationCharacters)
                                            .union(.symbols)
                                            .union(.whitespaces)
                
            // restrictedCharacters에 포함되지 않는 문자만 허용 (한글, 알파벳만 허용)
            if string.rangeOfCharacter(from: restrictedCharacters) != nil {
                return false
            }
        }
        
        return true
    }
    
    // 키보드에서 next버튼 누를 때 다음 텍스트 필드로 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case receiverNameTextField:
            return moveToNextTextField(currentTextField: receiverNameTextField, nextTextField: receiverAddressNameTextField)
            
        case receiverAddressNameTextField:
            return moveToNextTextField(currentTextField: receiverAddressNameTextField, nextTextField: phoneNumberTextFieldView.contactTextFieldFirst)

        case addressTextFieldView.detailAddressTextField:
            return moveToNextTextField(currentTextField: addressTextFieldView.detailAddressTextField, nextTextField: deliveryRequestTextField)
            
        case deliveryRequestTextField:
            textField.resignFirstResponder()
            return true
            
        default:
            return false
        }
    }
}

extension HBTIAddFixAddressViewController: HBTIAddressTextFieldViewDelegate {
    
    // 상세주소 텍스트필드에서 returnKey 탭했을 경우 배송 요청사항 텍스트필드로 이동
    func didTapReturnOnDetailAddressTextField() {
        moveToNextTextField(currentTextField: addressTextFieldView.detailAddressTextField, nextTextField: deliveryRequestTextField)
    }
}
