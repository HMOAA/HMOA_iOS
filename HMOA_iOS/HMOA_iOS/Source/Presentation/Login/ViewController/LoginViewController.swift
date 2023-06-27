
import UIKit

import SnapKit
import Then
import ReactorKit
import RxCocoa
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController, View {
    
    typealias Reactor = LoginReactor

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
    lazy var googleLoginButton = UIButton()
    lazy var appleLoginButton = UIButton()
    lazy var kakaoLoginButton = UIButton()
    
    let noLoginButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.pretendard, 12)
        $0.sizeToFit()
        $0.setTitle("로그인없이 사용하기", for: .normal)
        $0.setTitleColor(.customColor(.gray4), for: .normal)
    }
    
    var disposeBag = DisposeBag()
    let loginManager = LoginManager.shared
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setUpConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        googleLoginButton.setConfigButton(.google)
        appleLoginButton.setConfigButton(.apple)
        kakaoLoginButton.setConfigButton(.kakao)
        
        //button shadow
        googleLoginButton.layer.shadowColor = UIColor.black.cgColor
        googleLoginButton.layer.shadowOpacity = 0.25
        googleLoginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        googleLoginButton.layer.shadowRadius = 2
        
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
    func bind(reactor: Reactor) {
        
        //MARK: - Actiong
        //Input
        
        //구글 로그인 버튼 터치
        googleLoginButton.rx.tap
            .map { Reactor.Action.didTapGoogleLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        //애플 로그인 버튼 터치
        appleLoginButton.rx.tap
            .map { Reactor.Action.didTapAppleLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        //카카오톡 로그인 버튼 터치
        kakaoLoginButton.rx.tap
            .map { Reactor.Action.didTapKakaoLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        //로그인 없이 이용하기 버튼 터치
        noLoginButton.rx.tap
            .map { Reactor.Action.didTapNoLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        //로그인 상태 유지 버튼 터치
        loginRetainButton.rx.tap
            .map { Reactor.Action.didTapLoginRetainButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //MARK: - State
        //Output
        
        //메인 탭바로 이동
        reactor.state
            .map { $0.isPresentTabBar}
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                let tabBar = AppTabbarController()
                tabBar.modalPresentationStyle = .fullScreen
                owner.present(tabBar, animated: true)
            }).disposed(by: disposeBag)
        
        //StartVC로 이동
        reactor.state
            .map { $0.isPushStartVC}
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                let vc = LoginStartViewController()
                let nvController = UINavigationController(rootViewController: vc)
                nvController.modalPresentationStyle = .fullScreen
                owner.present(nvController, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        //로그인 상태 유지 체크버튼 toggle
        reactor.state
            .map { $0.isChecked}
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.loginRetainButton.isSelected.toggle()
        }).disposed(by: disposeBag)
        
        //구글 로그인 호출
        reactor.state
            .map { $0.isSignInGoogle }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.googleLogin()
            }).disposed(by: disposeBag)
        
        //카카오로그인 토큰
        reactor.state
            .compactMap { $0.kakaoToken }
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, token in
                KeychainManager.create(token: token)
                owner.loginManager.tokenSubject.onNext(token)
                owner.checkPreviousSignIn(token.existedMember!)
            }).disposed(by: disposeBag)
    }
}

extension LoginViewController {
    func googleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil, let result = result else { return }
            
            let token = result.user.accessToken.tokenString
            let params = ["token": token]
            
            LoginAPI.postAccessToken(params: params, .google)
                .bind(with: self, onNext: { owner, toekn
                    KeychainManager.create(token: token)
                    owner.loginManager.tokenSubject.onNext(token)
                    owner.checkPreviousSignIn(token.existedMember!)
                }).disposed(by: owner.disposeBag)
        }
    }
    
    func checkPreviousSignIn(_ isExisted: Bool) {
        if !isExisted {
            let vc = LoginStartViewController()
            let nvController = UINavigationController(rootViewController: vc)
            nvController.modalPresentationStyle = .fullScreen
            self.view.window?.rootViewController = nvController
            self.present(nvController, animated: true)
            self.view.window?.rootViewController?.dismiss(animated: false)
        } else {
            self.presentAppTabBarController()
        }
    }
}
