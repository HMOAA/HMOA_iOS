//
//  MyPageViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import RxAppState
import KakaoSDKTalk
import RxKakaoSDKTalk

class MyPageViewController: UIViewController, View {

    var reactor: MyPageReactor
    var disposeBag = DisposeBag()
    private let loginManger = LoginManager.shared
    
    // MARK: - UI Component
    private let alarmSwitch = UISwitch()
    private let myPageView = MyPageView()
    private let noLoginView = NoLoginEmptyView(title:
                                            """
                                            로그인이 필요한
                                            페이지 입니다
                                            """,
                                       subTitle:
                                            """
                                            향모아의 회원이 되면
                                            더 많은 기능을 사용할 수 있어요
                                            """,
                                       buttonHidden: false
                                  )

    private var dataSource: UITableViewDiffableDataSource<MyPageSection, MyPageSectionItem>?
    
    init(reactor: MyPageReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setNavigationBarTitle("마이페이지")
        bind(reactor: reactor)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - Functions

extension MyPageViewController {
    
    func bind(reactor: MyPageReactor) {
        configureDataSource()
    
        // MARK: - action
        
        //tableView 아이템 클릭
        myPageView.tableView.rx.itemSelected
            .compactMap {
                MyPageType(rawValue: "\($0.section)" + "\($0.row)")
            }
            .map { Reactor.Action.didTapCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //로그인 바로가기 버튼 터치
        noLoginView.goLoginButton.rx.tap
            .map { Reactor.Action.didTapGoLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - state
        
        //로그인 상태에 따른 뷰 보여주기
        loginManger.isLogin
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, isLogin in
                owner.setFirstView(isLogin)
            })
            .disposed(by: disposeBag)
        
        // 로그인 버튼 터치
        reactor.state
            .map { $0.isTapGoLoginButton }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentInAppLoginVC()
            })
            .disposed(by: disposeBag)
        
        // tableView 바인딩
        reactor.state
            .map { $0.sections }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, sections in
                guard let datasource = owner.dataSource else { return }
                var snapshot = NSDiffableDataSourceSnapshot<MyPageSection, MyPageSectionItem>()
                
                snapshot.appendSections(sections)
                sections.forEach { section in
                    snapshot.appendItems(section.items, toSection: section)
                }
                
                datasource.apply(snapshot, animatingDifferences: false)
            }).disposed(by: disposeBag)
        
        // cell 클릭 시 화면 전환
        reactor.state
            .map { $0.presentVC }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(onNext: presentNextVC)
            .disposed(by: disposeBag)
        
        // 계정 삭제
        reactor.state
            .map { $0.isDelete }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                KeychainManager.delete()
                owner.loginManger.tokenSubject.onNext(nil)
                owner.presentInAppLoginVC()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        noLoginView.isHidden = true
        [
            myPageView,
            noLoginView
        ] .forEach { view.addSubview($0) }
        
        myPageView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        myPageView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        noLoginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: myPageView.tableView, cellProvider: { tableView, indexPath, item in
            
            switch item {
            case .memberCell(let member, let profileImage):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageUserCell.identifier, for: indexPath) as? MyPageUserCell else { return UITableViewCell() }
                
                cell.updateCell(member, profileImage)
                cell.selectionStyle = .none
                
                return cell
                
            case .pushAlaramCell(let title):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageSwitchCell.identifier, for: indexPath) as? MyPageSwitchCell else {
                    return UITableViewCell() }
                
                cell.updateCell(title)
                
                
                cell.accessoryView = self.alarmSwitch
                
                self.alarmSwitch.rx.isOn
                    .skip(1)
                    .map { Reactor.Action.didSwitchAlarm($0) }
                    .bind(to: self.reactor.action)
                    .disposed(by: cell.disposeBag)
                
                self.reactor.state
                    .map { $0.isSetOnSwitch }
                    .compactMap { $0 }
                    .distinctUntilChanged()
                    .observe(on: MainScheduler.instance)
                    .bind(to: self.alarmSwitch.rx.isOn)
                    .disposed(by: cell.disposeBag)
                
                self.reactor.state
                    .map { $0.isOnSwitch }
                    .skip(1)
                    .compactMap { $0 }
                    .distinctUntilChanged()
                    .observe(on: MainScheduler.asyncInstance)
                    .bind(with: self) { owner, isOn in
                        if isOn && owner.reactor.currentState.isPushSetting {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            
                        }
                        owner.loginManger.isUserSettingAlarm.onNext(isOn)
                        owner.reactor.action.onNext(.networkingFcmTokenAPI(isOn))
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.selectionStyle = .none
                
                return cell
                
            case .otherCell(let title):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.identifier, for: indexPath) as? MyPageCell else { return UITableViewCell() }
                
                cell.updateCell(title)
                cell.selectionStyle = .none
                
                return cell
                
            }
        })
    }
    
    private func presentNextVC(_ type: MyPageType) {
        
        switch type {
        case .myProfile:
            let changeProfileReactor = self.reactor.reactorForMyProfile()
            let changeProfileVC = ChangeProfileImageViewController()
            changeProfileVC.reactor = changeProfileReactor
            changeProfileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(changeProfileVC, animated: true)
            
        case .orderLog:
            let orderLogVC = OrderLogViewController()
            let orderLogReactor = OrderLogReactor()
            orderLogVC.reactor = orderLogReactor
            self.navigationController?.pushViewController(orderLogVC, animated: true)
            
        case .orderCancelLog:
            let orderCancelLogVC = OrderCancelLogViewController()
            let orderCancelLogReactor = OrderCancelLogReactor()
            orderCancelLogVC.reactor = orderCancelLogReactor
            self.navigationController?.pushViewController(orderCancelLogVC, animated: true)
            
        case .myPerfume:
            let likeVC = LikeViewController()
            let reactor = LikeReactor()
            likeVC.reactor = reactor
            self.navigationController?.pushViewController(likeVC, animated: true)
            
        case .myLog:
            let myLogVC = MyLogViewController()
            myLogVC.reactor = MyLogReactor()
            navigationController?.pushViewController(myLogVC, animated: true)
            
        case .myInformation:
            let myInformationReactor = self.reactor.reactorForMyInformation()
            let myInformationVC = MyProfileViewController(reactor: myInformationReactor)
            self.navigationController?.pushViewController(myInformationVC, animated: true)
        case .policy:
            UIApplication.shared.open(URL(string: "https://atom-baritone-abe.notion.site/Hmoa-b80ec8694fc440f7a78b3a05b35ecffd?pvs=4")!)
        case .version:
            break
        case .inquireAccount:
            MemberAPI.kakaoTalkAddChannel()
                .map { $0 }
                .bind(with: self, onNext: { owner, isSetKakao in
                    if !isSetKakao {
                        owner.showAlert(title: "카카오톡 미설치",
                                        message: "카카오톡이 설치되어 있어야 합니다.",
                                        buttonTitle1: "확인")
                    }
                })
                .disposed(by: disposeBag)
        case .logout:
            showAlert(title: "로그아웃",
                      message: "로그아웃 하시겠습니까?",
                      buttonTitle1: "아니요",
                      buttonTitle2: "네",
                      action2: {
                if self.alarmSwitch.isOn {
                    PushAlarmAPI.deleteFcmToken()
                        .bind(onNext: { _ in })
                        .disposed(by:  self.disposeBag)
                }
                self.presentInAppLoginVC()
                KeychainManager.delete()
                self.loginManger.tokenSubject.onNext(nil)
            })
            
        case .deleteAccount:
            showAlert(title: "계정 삭제",
                      message: "계정을 삭제 하시겠습니까?",
                      buttonTitle1: "아니요",
                      buttonTitle2: "네",
                      action2: {
                self.reactor.action.onNext(.didTapDeleteMember)
            })
        }
    }
    
    private func setFirstView(_ isLogin: Bool) {
        if !isLogin {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.noLoginView.isHidden = false
                self.myPageView.isHidden = true
            }
        } else {
            
            // viewDidLoad
            Observable.just(())
                .map { Reactor.Action.viewDidLoad }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            
            // 앱 알람 권한 설정 셋팅
            loginManger.isPushAlarmAuthorization
                .map { Reactor.Action.settingAlarmAuthorization($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            
            // 유저 알람 권한 설정 셋팅
            loginManger.isUserSettingAlarm
                .map { Reactor.Action.settingIsUserSetting($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)

            
            noLoginView.isHidden = true
            myPageView.isHidden = false
        }
    }
}

// MARK: - UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 90
        } else {
            return 52
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 || section == 2 { return UIView() }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageSeparatorLineView.ientfifier)

        return header
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}


extension MyPageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
}
