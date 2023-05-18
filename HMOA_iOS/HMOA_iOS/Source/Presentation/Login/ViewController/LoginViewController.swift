
import UIKit

import SnapKit
import Then
import ReactorKit
import RxCocoa
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {

    //MARK: - Property
    let titleImageView = UIImageView().then {
        $0.image = UIImage(named: "logo_EG")
    }
    
    let loginRetainButton = UIButton().then {
        $0.layer.borderColor = UIColor.customColor(.gray1).cgColor
        $0.layer.borderWidth = 1
        $0.setImage(UIImage(), for: .normal)
        //TODO: - 해당 이미지로 바꿔주기
        $0.setImage(UIImage(named: "kakaotalk"), for: .selected)
    }
    let loginRetainLabel = UILabel().then {
        $0.textColor = .customColor(.gray4)
        $0.font = .customFont(.pretendard_light, 12)
        $0.text = "로그인 상태 유지"
    }
    
    let loginStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.setStackViewUI(spacing: 12)
    }
    var googleLoginButton: UIButton!
    var appleLoginButton: UIButton!
    var kakaoLoginButton: UIButton!
    
    let noLoginButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.pretendard, 12)
        $0.sizeToFit()
        $0.setTitle("로그인없이 사용하기", for: .normal)
        $0.setTitleColor(.customColor(.gray4), for: .normal)
    }
    
    let loginReactor = LoginReactor()
    let disposeBag = DisposeBag()
    let loginManager = LoginManager.shared
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setUpConstraints()
        
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
        
        //Button SetUp
        googleLoginButton = UIButton(
            configuration: setConfigButton(
                "구글로 시작하기",
                color: .black,
                imageName: "google",
                backgroundColor: .white,
                padding: 80))
        //button shadown
        googleLoginButton.layer.shadowColor = UIColor.black.cgColor
        googleLoginButton.layer.shadowOpacity = 0.25
        googleLoginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        googleLoginButton.layer.shadowRadius = 2
        
        appleLoginButton = UIButton(
            configuration: setConfigButton(
                "애플로 시작하기",
                color: .white,
                imageName: "apple",
                backgroundColor: .black,
                padding: 80))
        
        kakaoLoginButton = UIButton(
            configuration: setConfigButton(
                "카카오톡으로 시작하기",
                color: .black,
                imageName: "kakaotalk",
                backgroundColor: #colorLiteral(red: 0.9983025193, green: 0.9065476656, blue: 0, alpha: 1),
                padding: 60,
                rightPadding: 102))
        
        
        
    }
    
    private func setConfigButton(_ title: String,
                                 color: UIColor,
                                 imageName: String,
                                 backgroundColor: UIColor,
                                 padding: CGFloat,
                                 rightPadding: CGFloat = 120) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString.init(title)
        titleAttr.font = .customFont(.pretendard, 14)
        titleAttr.foregroundColor = color
        
        config.attributedTitle = titleAttr
        config.background.backgroundColor = backgroundColor
        config.image = UIImage(named: imageName)
        config.imagePadding = padding
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: rightPadding)
        return config
        
    }

    private func setAddView() {
        [
            googleLoginButton,
            appleLoginButton,
            kakaoLoginButton
        ]       .forEach { loginStackView.addArrangedSubview($0)}
        
        [
            titleImageView,
            loginRetainButton,
            loginRetainLabel,
            loginStackView,
            noLoginButton
        ]      .forEach { view.addSubview($0)}
    }
    
    private func setUpConstraints() {
        titleImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(168)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
        loginRetainButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleImageView.snp.bottom).offset(60)
            make.width.height.equalTo(16)
        }
        
        loginRetainLabel.snp.makeConstraints { make in
            make.leading.equalTo(loginRetainButton.snp.trailing).offset(8)
            make.top.equalTo(loginRetainButton.snp.top)
        }
        
        loginStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(loginRetainButton.snp.bottom).offset(14)
            make.height.equalTo(144)
        }
        
        noLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(48)
        }
    }
    
    //MARK: - Bind
    private func bind(reactor: LoginReactor) {
        
        //MARK: - Actiong
        //Input
        
        //구글 로그인 버튼 터치
        googleLoginButton.rx.tap
            .map { LoginReactor.Action.didTapGoogleLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        //애플 로그인 버튼 터치
        appleLoginButton.rx.tap
            .map { LoginReactor.Action.didTapAppleLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        //카카오톡 로그인 버튼 터치
        kakaoLoginButton.rx.tap
            .map { LoginReactor.Action.didTapKakaoLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        //로그인 없이 이용하기 버튼 터치
        noLoginButton.rx.tap
            .map { LoginReactor.Action.didTapNoLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        //로그인 상태 유지 버튼 터치
        loginRetainButton.rx.tap
            .map { LoginReactor.Action.didTapLoginRetainButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //MARK: - State
        //Output
        
        //메인 탭바로 이동
        reactor.state
            .map { $0.isPresentTabBar}
            .distinctUntilChanged()
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
            .filter { $0 }
            .bind(onNext: { _ in
                let vc = LoginStartViewController()
                let nvController = UINavigationController(rootViewController: vc)
                nvController.modalPresentationStyle = .fullScreen
                self.present(nvController, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        //로그인 상태 유지 체크버튼 toggle
        reactor.state
            .map { $0.isChecked}
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { _ in
                self.loginRetainButton.isSelected.toggle()
        }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isSignInGoogle }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { _ in
                self.googleLogin()
            }).disposed(by: disposeBag)
        
        
    }
}

extension LoginViewController {
    func googleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil, let result = result else { return }

            let token = result.user.accessToken.tokenString
            let params = ["token": token]

            LoginAPI.postAccessToken(params: params)
                .bind(onNext: {
                    self.loginManager.googleToken = $0
                    
                    print($0)
                    let vc = LoginStartViewController()
                    let nvController = UINavigationController(rootViewController: vc)
                    nvController.modalPresentationStyle = .fullScreen
                    self.view.window?.rootViewController = nvController
                    self.present(nvController, animated: true)
                    self.view.window?.rootViewController?.dismiss(animated: false)
                }).disposed(by: self.disposeBag)
        }
    }
}
