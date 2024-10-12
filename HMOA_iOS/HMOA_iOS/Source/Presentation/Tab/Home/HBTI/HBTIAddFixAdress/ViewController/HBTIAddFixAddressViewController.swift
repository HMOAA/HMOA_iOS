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
    
    private let addressTextFieldView = HBTIAddressTextFieldView(title: "주소")

    private let deliveryRequestLabel = UILabel().then {
        $0.setLabelUI("배송 요청사항(선택)", font: .pretendard_medium, size: 12, color: .black)
    }
    
    private let deliveryRequestTextField = UITextField().then {
        $0.setTextFieldUI("배송 시 요청사항을 선택해주세요", leftPadding: 12, font: .pretendard_medium, isCapsule: true)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let saveAddressInfoButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
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
        dismissKeyboard()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIAddFixReactor) {
        
        // MARK: Action
        
        // MARK: State
        
        reactor.state
            .map { $0.title }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] title in
                self?.setBackItemNaviBar(title)
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
    
    // MARK: Other Functions
    
    private func dismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addDismissKeyboardGesture))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func addDismissKeyboardGesture() {
        self.view.endEditing(true)
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
            
        default:
            return false
        }
    }
}
