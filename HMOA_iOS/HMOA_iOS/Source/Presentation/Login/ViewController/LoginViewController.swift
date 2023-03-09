
import UIKit

import SnapKit
import Then
import ReactorKit
import RxCocoa

class LoginViewController: UIViewController {

    //MARK: - Property
    let noLoginLabel = UILabel().then {
        $0.sizeToFit()
        $0.textColor = .customColor(.gray4)
        $0.font = .customFont(.pretendard, 12)
        $0.text = "로그인없이 사용하기"
    }
    let noLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "noLoginButton"), for: .normal)
    }
    
    let titleImageView = UIImageView().then {
        $0.image = UIImage(named: "logo_EG")
    }
    
    let idPwStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 6
        $0.axis = .vertical
    }
    let idTextField = UITextField().then {
        $0.setTextFieldUI("이메일 주소 또는 아이디", leftPadding: 16, font: .pretendard, isCapsule: true)
    }
    let pwTextField = UITextField().then {
        $0.setTextFieldUI("비밀번호", leftPadding: 16, font: .pretendard, isCapsule: true)
    }
    
    
    let loginRetainStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    let checkLoginRetainButton = UIButton().then {
        $0.setImage(UIImage(), for: .normal)
        $0.setImage(UIImage(named: "checkButton"), for: .selected)
        $0.backgroundColor = .customColor(.gray3)
    }
    let loginRetainLabel = UILabel().then {
        $0.textColor = .customColor(.gray4)
        $0.font = .customFont(.pretendard_light, 12)
        $0.text = "로그인 상태 유지"
    }
    
    let loginButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.titleLabel?.font = .customFont(.pretendard, 14)
        $0.setTitle("로그인", for: .normal)
    }
    
    let idPwRegisterStackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.spacing = 32
        $0.axis = .horizontal
    }
    let findIdButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("아이디 찾기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_light, 12)
    }
    let resetPwButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("비밀번호 재설정", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_light, 12)
    }
    let registerButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_light, 12)
    }
    
    let easyLoginLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 10)
        $0.text = "간편로그인"
    }
    
    let easyLoginStackView = UIStackView().then {
        $0.distribution = .fill
        $0.spacing = 33
        $0.axis = .horizontal
    }
    let appleButton = UIButton().then {
        $0.clipsToBounds = true
        $0.backgroundColor = #colorLiteral(red: 0.7540718913, green: 0.7540718913, blue: 0.7540718913, alpha: 1)
        $0.setImage(UIImage(named: "apple"), for: .normal)
    }
    let googleButton = UIButton().then {
        $0.layer.borderColor = UIColor.customColor(.gray1).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerCurve = .circular
        $0.setImage(UIImage(named: "google"), for: .normal)
    }
    let kakaoButton = UIButton().then {
        $0.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.8980392157, blue: 0, alpha: 1)
        $0.setImage(UIImage(named: "kakaotalk"), for: .normal)
    }
    
    let loginReactor = LoginReactor()
    let disposeBag = DisposeBag()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddView()
        setUpConstraints()
        setUpUI()
        
        bind(reactor: loginReactor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        [appleButton, googleButton, kakaoButton].forEach {
            $0.layer.cornerRadius = 25
        }
    }

    private func setAddView() {
        
        [idTextField,
         pwTextField].forEach { idPwStackView.addArrangedSubview($0) }
        
        [checkLoginRetainButton,
         loginRetainLabel].forEach { loginRetainStackView.addArrangedSubview($0) }
        
        [findIdButton,
         resetPwButton,
         registerButton].forEach { idPwRegisterStackView.addArrangedSubview($0)}
        
        [appleButton,
         googleButton,
         kakaoButton].forEach { easyLoginStackView.addArrangedSubview($0) }
        
        [noLoginButton,
         noLoginLabel,
         titleImageView,
         loginRetainStackView,
         loginButton,
         idPwStackView,
         idPwRegisterStackView,
         easyLoginLabel,
         easyLoginStackView].forEach { view.addSubview($0) }
        
    }
    
    private func setUpConstraints() {
        
        noLoginButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(19)
            make.top.equalToSuperview().inset(69)
        }
        
        noLoginLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(72)
            make.trailing.equalTo(noLoginButton.snp.leading).offset(-15.09)
        }
        
        titleImageView.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().inset(152)
            make.width.equalTo(200)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        checkLoginRetainButton.snp.makeConstraints { make in
            make.width.equalTo(16)
        }
        
        idPwStackView.snp.makeConstraints{ make in
            make.height.equalTo(100)
            make.top.equalTo(titleImageView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        loginRetainStackView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(idPwStackView.snp.bottom).offset(10)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(loginRetainStackView.snp.bottom).offset(38)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        idPwRegisterStackView.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(16)
        }
        
        easyLoginLabel.snp.makeConstraints { make in
            make.top.equalTo(idPwRegisterStackView.snp.bottom).offset(92)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }
        
        easyLoginStackView.snp.makeConstraints { make in
            make.top.equalTo(easyLoginLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(66).priority(750)
        }
        
        [kakaoButton,
         googleButton,
         appleButton].forEach{
            $0.snp.makeConstraints { make in
                make.height.equalTo(50)
                make.width.equalTo(50)
           }
        }
    }
    
    //MARK: - Bind
    private func bind(reactor: LoginReactor) {
        
        //MARK: - Actiong
        //Input
        
        //로그인 버튼 터치
        loginButton.rx.tap
            .map { LoginReactor.Action.didTapLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        //로그인 없이 이용하기 버튼 터치
        noLoginButton.rx.tap
            .map { LoginReactor.Action.didTapNoLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        //로그인 상태 유지 버튼 터치
        checkLoginRetainButton.rx.tap
            .map { LoginReactor.Action.didTapLoginRetainButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //MARK: - State
        //Output
        //메인 탭바로 이동
        reactor.state
            .map { $0.isPresentTabBar}
            .distinctUntilChanged()
            .compactMap { $0}
            .filter { $0 }
            .bind(onNext: { _ in
                let tabBar = AppTabbarController()
                tabBar.modalPresentationStyle = .fullScreen
                self.present(tabBar, animated: true)
            }).disposed(by: disposeBag)
        
        //StartVC로 이동
        reactor.state
            .map { $0.isPushStartVC}
            .distinctUntilChanged()
            .compactMap { $0 }
            .filter { $0 }
            .bind(onNext: { _ in
                self.navigationController?
                    .pushViewController(StartViewController(),
                                        animated: true)
            }).disposed(by: disposeBag)
        
        //로그인 상태 유지 체크버튼 toggle
        reactor.state
            .map { $0.isChecked}
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: { _ in
                self.checkLoginRetainButton.isSelected.toggle()
        }).disposed(by: disposeBag)
    }
}
