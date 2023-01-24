
import UIKit

import SnapKit
import Then

class LoginViewController: UIViewController {

    //MARK: - Property
    let titleLabel = UILabel().then {
        $0.font = .customFont(.slabo27px, 30)
        $0.text = "HMOA"
        $0.textAlignment = .center
    }
    
    let idPwStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 6
        $0.axis = .vertical
    }
    let idTextField = UITextField().then {
        $0.addLeftPadding(8)
        $0.font = .customFont(.pretendard, 14)
        $0.placeholder = "이메일 주소 또는 아이디"
        $0.setPlaceholder(color: .black)
        $0.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
    }
    let pwTextField = UITextField().then {
        $0.addLeftPadding(8)
        $0.font = .customFont(.pretendard, 14)
        $0.placeholder = "비밀번호"
        $0.setPlaceholder(color: .black)
        $0.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
    }
    
    let loginButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 22
        $0.titleLabel?.font = .customFont(.pretendard, 14)
        $0.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        $0.setTitle("로그인", for: .normal)
    }
    
    let idPwRegisterStackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.spacing = 30
        $0.axis = .horizontal
    }
    let findIdButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("아이디 찾기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 12)
    }
    let resetPwButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("비밀번호 재설정", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 12)
    }
    let registerButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 12)
    }
    
    let easyLoginLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 12)
        $0.text = "간편 로그인"
    }
    
    let easyLoginStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 33
        $0.axis = .horizontal
    }
    let naverButton = UIButton().then {
        $0.setImage(UIImage(named: "naver"), for: .normal)
    }
    let kakaoButton = UIButton().then {
        $0.setImage(UIImage(named: "kakaotalk"), for: .normal)
    }
    let googleButton = UIButton().then {
        $0.setImage(UIImage(named: "google"), for: .normal)
    }
    
    let viewModel = LoginViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setAddView()
        setUpConstraints()
        
    }
    
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
        loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton(_: )), for: .touchUpInside)
    }
    
    
    private func setAddView() {
        
        [idTextField, pwTextField].forEach { idPwStackView.addArrangedSubview($0) }
        
        [findIdButton, resetPwButton, registerButton].forEach { idPwRegisterStackView.addArrangedSubview($0)}
        
        [naverButton, kakaoButton, googleButton].forEach { easyLoginStackView.addArrangedSubview($0) }
        
        [titleLabel, loginButton, idPwStackView, idPwRegisterStackView, easyLoginLabel, easyLoginStackView].forEach { view.addSubview($0) }
        
    }
    
    private func setUpConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(23)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(181)
            make.centerX.equalToSuperview()
        }
        
        idPwStackView.snp.makeConstraints{ make in
            make.height.equalTo(106)
            make.top.equalTo(titleLabel.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(pwTextField.snp.bottom).offset(19)
            make.leading.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(38)
        }
        
        idPwRegisterStackView.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(13)
        }
        
        easyLoginLabel.snp.makeConstraints { make in
            make.top.equalTo(idPwRegisterStackView.snp.bottom).offset(88)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }
        
        easyLoginStackView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(easyLoginLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Function
    @objc private func didTapLoginButton(_ sender: UIButton) {
        let vc = StartViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func didTapRegisterButton(_ sender: UIButton) {
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true)
    }
    
                                

}
