
import UIKit

import SnapKit
import Then
import ReactorKit
import RxCocoa
import GoogleSignIn
import AuthenticationServices
import KakaoSDKUser

class LoginViewController: UIViewController, View {
    

    //MARK: - UIComponents
    
    private let titleImageView = UIImageView().then {
        $0.image = UIImage(named: "logo_EG")
    }
    
    private let loginStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.setStackViewUI(spacing: 12)
    }
    
    private lazy var googleLoginButton = UIButton()
    private lazy var appleLoginButton = UIButton()
    private lazy var kakaoLoginButton = UIButton()
    
    private let noLoginButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.pretendard, 12)
        $0.sizeToFit()
        $0.setTitle("로그인없이 사용하기", for: .normal)
        $0.setTitleColor(.customColor(.gray4), for: .normal)
    }
    
    private lazy var xButton = UIButton().then {
        $0.isHidden = true
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    private let loginManager = LoginManager.shared
    
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
        
        googleLoginButton.addTarget(self, action: #selector(didTapGoogleButton(_ :)), for: .touchUpInside)
        kakaoLoginButton.addTarget(self, action: #selector(didTapKakaoButton(_ :)), for: .touchUpInside)
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
            appleLoginButton,
            googleLoginButton,
            kakaoLoginButton
        ]       .forEach { loginStackView.addArrangedSubview($0)}
        
        [
            titleImageView,
            loginStackView,
            noLoginButton,
            xButton
        ]      .forEach { view.addSubview($0)}
    }
    
    private func setUpConstraints() {
        titleImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(168)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
        loginStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleImageView.snp.bottom).offset(90)
            make.height.equalTo(144)
        }
        
        noLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(48)
        }
        
        xButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(80)
        }
    }
    
    //MARK: - Bind
    
    func bind(reactor: LoginReactor) {
        
        //MARK: - Action
        
        //애플 로그인 버튼 터치
        appleLoginButton.rx.tap
            .map { Reactor.Action.didTapAppleLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //로그인 없이 이용하기 버튼 터치
        noLoginButton.rx.tap
            .map { Reactor.Action.didTapNoLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        xButton.rx.tap
            .map { Reactor.Action.didTapXButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //MARK: - State
        
        //메인 탭바로 이동
        reactor.state
            .map { $0.isPresentTabBar }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentTabBar(reactor.currentState.loginState)
            }).disposed(by: disposeBag)
        
        //StartVC로 이동
        reactor.state
            .map { $0.isPushStartVC }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentLoginStartVC()
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
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, token in
                owner.checkPreviousSignIn(token)
            }).disposed(by: disposeBag)
        
        // 애플 로그인 토큰
        reactor.state
            .compactMap { $0.appleToken }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self) { owner, token in
                owner.checkPreviousSignIn(token)
            }.disposed(by: disposeBag)
            
        // 로그인 state 분기 처리
        reactor.state
            .map { $0.loginState }
            .bind(with: self) { owner, state in
                switch state {
                case .first:
                    owner.loginManager.loginStateSubject.onNext(.first)
                case .inApp:
                    owner.noLoginButton.isHidden = true
                    owner.xButton.isHidden = false
                    owner.loginManager.loginStateSubject.onNext(.inApp)
                }
            }.disposed(by: disposeBag)
        
        // dismiss 
        reactor.state
            .map { $0.isDismiss }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    
    @objc func didTapGoogleButton(_ sender: Any) {
        reactor?.action.onNext(.didTapGoogleLoginButton)
    }
    
    @objc func didTapKakaoButton(_ sender: Any) {
        reactor?.action.onNext(.didTapKakaoLoginButton)
    }
}

extension LoginViewController {
    private func googleLogin() {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            
            guard error == nil, let result = result else { return }
            
            let token = result.user.accessToken.tokenString
            let params = ["token": token]
            
            LoginAPI.postAccessToken(params: params, .google)
                .asDriver(onErrorRecover: { _ in .empty() })
                .drive(with: self, onNext: { owner, token in
                    owner.checkPreviousSignIn(token)
                }).disposed(by: self.disposeBag)
        }
    }
    
    private func checkPreviousSignIn(_ token: Token) {
        
        loginManager.tokenSubject.onNext(token)
        
        if !token.existedMember! {
            presentLoginStartVC()
        } else {
            presentTabBar(reactor!.currentState.loginState)
            KeychainManager.create(token: token)
        }
    }
}
