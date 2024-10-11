//
//  UIViewController++Extenstions.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/21.
//

import UIKit
import SnapKit
import Then

extension UIViewController {
    
    /// Height of status bar + navigation bar (if navigation bar exist)
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    // MARK: - Push or Present VC
    
    /// 튜토리얼 페이지 전환 여부
    func checkTutorialRun() {
        let isTutorial = UserDefaults.standard.bool(forKey: "Tutorial")
        if !isTutorial {
            let vc = TutorialViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
    /// 탭바에서 로그인 VC로 present
    func presentInAppLoginVC() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.reactor = LoginReactor(.inApp)
        self.present(loginVC, animated: true)
    }
    
    /// 로그인 시작VC로 present
    func presentLoginStartVC() {
        let vc = LoginStartViewController()
        let nvController = UINavigationController(rootViewController: vc)
        nvController.modalPresentationStyle = .fullScreen
        self.present(nvController, animated: true)
    }
    
    /// 탭바로 present
    func presentTabBar(_ state: LoginState) {
        switch state {
        case .first:
            let tabBar = AppTabbarController()
            self.view.window?.rootViewController = tabBar
        case .inApp:
            self.view.window?.rootViewController?.dismiss(animated: true)
        }
    }
        
    /// community Image DetailVC로 전환
    func presentImageListVC(_ indexPath: IndexPath, images: [CommunityPhoto]) {
        let vc = ImageListViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.reactor = ImageListReactor(indexPath.row, images)
        self.present(vc, animated: true)
    }
    
    /// CustomAlertVC로 present
    func presentAlertVC(title: String, content: String, buttonTitle: String) {
        let alertVC = AlertViewController(title: title, content: content, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        self.present(alertVC, animated: false)
    }
    
    /// communityListVC -> communityDetailVC
    func presentCommunityDetailVC(_ id: Int, _ reactor: CommunityListReactor) {
        let CommunityDetailVC = CommunityDetailViewController()
        let detailReactor = reactor.reactorForDetail()
        
        CommunityDetailVC.reactor = detailReactor
        CommunityDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(CommunityDetailVC, animated: true)
    }

    /// writedPostVC -> communityDetailVC
    func presentCommunityDetailVC(_ id: Int) {
        let CommunityDetailVC = CommunityDetailViewController()
        let detailReactor = CommunityDetailReactor(id, CommunityListService())
        
        CommunityDetailVC.reactor = detailReactor
        CommunityDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(CommunityDetailVC, animated: true)
    }
    
    // hpediaHomeVC -> communityDetailVC
    func presentCommunityDetailVC(reactor: HPediaReactor) {
        let CommunityDetailVC = CommunityDetailViewController()
        let detailReactor = reactor.reactorForDetail()
        
        CommunityDetailVC.reactor = detailReactor
        CommunityDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(CommunityDetailVC, animated: true)
    }
    
    /// communityDetailVC -> communityWriteVC (When Edit)
    func presentCommunityWriteVCForEdit(reactor: CommunityDetailReactor) {
        let CommunityWriteVC = CommunityWriteViewController()
        let reactor = reactor.reactorForPostEdit()
        CommunityWriteVC.reactor = reactor
        CommunityWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(CommunityWriteVC, animated: true)
    }
    
    /// communityListVC -> communityWriteVC (When Write)
    func presentCommunityWriteVC(_ reactor: CommunityListReactor) {
        let CommunityWriteVC = CommunityWriteViewController()
        let reactor = reactor.reactorForWrite()
        CommunityWriteVC.reactor = reactor
        CommunityWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(CommunityWriteVC, animated: true)
    }
    
    /// HPediaMainVC -> communityWriteVC (When Wrrite)
    func presentCommunityWriteVC(_ reactor: HPediaReactor) {
        let CommunityWriteVC = CommunityWriteViewController()
        let reactor = reactor.reactorForWrite()
        CommunityWriteVC.reactor = reactor
        CommunityWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(CommunityWriteVC, animated: true)
    }
    
    /// CommunityListVC로 push
    func presentCommunityListVC(_ reactor: HPediaReactor) {
        let CommunityListVC = CommunityListViewController()
        let reactor = reactor.reactorForCommunityList()
        CommunityListVC.reactor = reactor
        self.navigationController?.pushViewController(CommunityListVC, animated: true)
    }
    
    /// DetailDictionaryVC로 push
    func presentDetailDictionaryVC(_ type: HpediaType, _ id: Int) {
        let detailDictionaryVC = DetailDictionaryViewController()
        let reactor = DetailDictionaryReactor(type, id)
        detailDictionaryVC.reactor = reactor
        self.navigationController?.pushViewController(detailDictionaryVC, animated: true)
    }
    
    /// HPediaDictionaryVC로 push
    func presentDictionaryViewController(_ type: HpediaType) {
        let dictionaryVC = DictionaryViewController()
        let reactor = DictionaryReactor(type: type)
        dictionaryVC.reactor = reactor
        self.navigationController?.pushViewController(dictionaryVC, animated: true)
    }
    
    /// PerfumeDetailVC로 push
    func presentDetailViewController(_ id: Int, _ service: BrandDetailService? = nil) {
        let reactor = DetailViewReactor(perfumeId: id, service: service)
        let detailVC = DetailViewController()
        detailVC.reactor = reactor
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    /// CommentListVC로 push
    func presentCommentViewContorller(_ id: Int) {
        let commentVC = CommentListViewController()
        commentVC.reactor = CommentListReactor(id, service: DetailCommentService())
        commentVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    /// SearchVC로 push
    func presentSearchViewController() {
        let searchVC = SearchViewController()
        searchVC.reactor = SearchReactor(service: BrandDetailService())
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    /// CommentDetailVC로 push
    func presentCommentDetailViewController(comment: Comment?, communityCommet: CommunityComment?, perfumeService: DetailCommentServiceProtocol?, communityService: CommunityListProtocol?) {
        let commentDetailVC = CommentDetailViewController()
        commentDetailVC.hidesBottomBarWhenPushed = true
        commentDetailVC.reactor = CommentDetailReactor(comment: comment,
                                                       communityComment: communityCommet,
                                                       perfumeService: perfumeService,
                                                       communityService: communityService)
        self.navigationController?.pushViewController(commentDetailVC, animated: true)
    }
    
    /// CommentWriteVC로 push
    func presentCommentWriteViewController(_ reactorType: CommentReactorType) {
        let commentWriteVC = CommentWriteViewController()
        
        var commentWriteReactor: CommentWriteReactor!
        
        switch reactorType {
        case .perfumeDetail(let reactor):
            commentWriteReactor = reactor.reactorForCommentAdd()
        case .commentList(let reactor):
            commentWriteReactor = reactor.reactorForCommentAdd()
        default: break
        }
        
        commentWriteVC.reactor = commentWriteReactor
        commentWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentWriteVC, animated: true)
    }
    
    /// CommunityListVC로 push (수정일 때)
    func presentCommentWirteViewControllerForWriter(_ reactorType: CommentReactorType) {
        
        let commentWriteVC = CommentWriteViewController()
        var commentWriteReactor: CommentWriteReactor!
        switch reactorType {
            
        case .commentList(let reactor):
            commentWriteReactor = reactor.reactorForEdit()
            
        case .community(let reactor):
            commentWriteReactor = reactor.reactorForCommentEdit()
            
        case .perfumeDetail(let reactor):
            commentWriteReactor = reactor.reactorForCommentEdit()
            
        case .commentDetail(let reactor):
            commentWriteReactor = reactor.reactorForCommentEdit()
        }
        commentWriteVC.reactor = commentWriteReactor
        commentWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentWriteVC, animated: true)
    }
    
    /// BrandSearchVC로 push
    func presentBrandSearchViewController() {
        let brandSearchVC = BrandSearchViewController()
        brandSearchVC.reactor = BrandSearchReactor()
        self.navigationController?.pushViewController(brandSearchVC, animated: true)
    }
    
    /// BrandSearchDetailVC로 push
    func presentBrandDetailViewController(_ brandId: Int) {
        let brandDetailVC = BrandDetailViewController()
        brandDetailVC.reactor = BrandDetailReactor(brandId, BrandDetailService())
        self.navigationController?.pushViewController(brandDetailVC, animated: true)
    }
    
    /// TotalPerfumeVC로 push
    func presentTotalPerfumeViewController(_ listType: Int) {
        let totalPerfumeVC = TotalPerfumeViewController()
        totalPerfumeVC.reactor = TotalPerfumeReactor(listType)
        self.navigationController?.pushViewController(totalPerfumeVC, animated: true)
    }
    
    /// MagazineDetailVC로 push
    func presentMagazineDetailViewController(_ id: Int) {
        let magazineDetailVC = MagazineDetailViewController()
        magazineDetailVC.reactor = MagazineDetailReactor(id)
        magazineDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(magazineDetailVC, animated: true)
    }
    
    /// NotificationDetailVC로 push
    func presentPushAlarmViewController() {
        let pushAlarmVC = PushAlarmViewController()
        pushAlarmVC.reactor = PushAlarmReactor()
        self.navigationController?.pushViewController(pushAlarmVC, animated: true)
    }
    
    /// HBTIVC로 push
    func presentHBTIViewController() {
        let hbtiVC = HBTIViewController()
        hbtiVC.reactor = HBTIReactor()
        hbtiVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hbtiVC, animated: true)
    }
    
    /// HBTISurveyVC로 push
    func presentHBTISurveyViewController() {
        let hbtiSurveyVC = HBTISurveyViewController()
        hbtiSurveyVC.reactor = HBTISurveyReactor()
        hbtiSurveyVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hbtiSurveyVC, animated: true)
    }
    
    /// HBTISurveyResultVC로 push
    func presentHBTISurveyResultViewController(_ selectedIDList: [Int]) {
        let hbtiSurveyResultVC = HBTISurveyResultViewController()
        hbtiSurveyResultVC.reactor = HBTISurveyResultReactor(selectedIDList)
        hbtiSurveyResultVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hbtiSurveyResultVC, animated: true)
    }
        
    /// HBTIPerfumeSurveyVC로 push
    func presentHBTIPerfumeSurveyViewController() {
        let hbtiPerfumeSurveyVC = HBTIPerfumeSurveyViewController()
        hbtiPerfumeSurveyVC.reactor = HBTIPerfumeSurveyReactor()
        hbtiPerfumeSurveyVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hbtiPerfumeSurveyVC, animated: true)
    }
    
    /// HBTIPerfumeResultVC로 push
    func presentHBTIPerfumeResultViewController(_ minPrice: Int, _ maxPrice: Int, _ notes: [String]) {
        let hbtiPerfumeResultVC = HBTIPerfumeResultViewController()
        hbtiPerfumeResultVC.reactor = HBTIPerfumeResultReactor(minPrice, maxPrice, notes)
        hbtiPerfumeResultVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hbtiPerfumeResultVC, animated: true)
    }
  
    /// HBTINotesCatrgoryVC로 push
    func presentHBTINotesCategoryViewController(_ selectedQuantity: Int, _ isFreeSelection: Bool) {
        let hbtiNotesCategoryVC = HBTINotesCategoryViewController()
        hbtiNotesCategoryVC.reactor = HBTINotesCategoryReactor(selectedQuantity, isFreeSelection)
        hbtiNotesCategoryVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hbtiNotesCategoryVC, animated: true)
    }
  
    /// HBTIQuantitySelectVC로 push
    func presentHBTIQuantitySelectViewController() {
        let hbtiQuantitySelectVC = HBTIQuantitySelectViewController()
        hbtiQuantitySelectVC.reactor = HBTIQuantitySelectReactor()
        hbtiQuantitySelectVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hbtiQuantitySelectVC, animated: true)
    }
  
    /// HBTIProcessGuideVC로 push
    func presentHBTIProcessGuideViewController() {
        let hbtiProcessGuideVC = HBTIProcessGuideViewController()
        hbtiProcessGuideVC.reactor = HBTIProcessGuideReactor()
        hbtiProcessGuideVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hbtiProcessGuideVC, animated: true)
    }
    
    /// HBTIOrderSheetVC로 push
    func presentHBTIOrderSheetViewController() {
        let hbtiOrderSheetVC = HBTIOrderSheetViewController()
        hbtiOrderSheetVC.reactor = HBTIOrderReactor()
        hbtiOrderSheetVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hbtiOrderSheetVC, animated: true)
    }
    
    func presentHBTIAddFixAddressViewController(title: String) {
        let hbtiAddFixAddressVC = HBTIAddFixAddressViewController()
        hbtiAddFixAddressVC.reactor = HBTIAddFixReactor(title: title)
        hbtiAddFixAddressVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hbtiAddFixAddressVC, animated: true)
    }
    
    /// HBTINotesResultVC로 push
    func presentHBTINotesResultViewController() {
        let hbtiNotesResultVC = HBTINotesResultViewController()
        hbtiNotesResultVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hbtiNotesResultVC, animated: true)
    }
    
    // MARK: Configure NavigationBar
    
    /// 확인 버튼, 취소 버튼 navigation bar
    func setOkCancleNavigationBar(okButton: UIButton, cancleButton: UIButton, titleLabel: UILabel) {
        
        okButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        cancleButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        let okButtonItem = UIBarButtonItem(customView: okButton)
        let cancleButtonItem = UIBarButtonItem(customView: cancleButton)
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [cancleButtonItem]
        self.navigationItem.rightBarButtonItems = [okButtonItem]
    }
    
    // TODO: - 알림 API 구현 후 수정
    /// Set HomeVC NavigatioinBar
    func setSearchBellNaviBar(_ title: String, bellButton: UIBarButtonItem) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        let brandButton = self.navigationItem.makeImageButtonItem(self, action: #selector(goToBrand), imageName: "homeMenu")
        
        let searchButton = self.navigationItem.makeImageButtonItem(self, action: #selector(goToSearch), imageName: "search")

        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [brandButton]
        self.navigationItem.rightBarButtonItems = [bellButton, searchButton]
    }
    
    /// BackButton만 있는 NavigationBar
    func setBackItemNaviBar(_ title: String) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "backButton")
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [backButton]
    }
    
    /// Back버튼, Home버튼 NavigationBar
    func setBackHomeRightNaviBar(_ title: String) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "backButton")
        
        let homeButton = self.navigationItem.makeImageButtonItem(self, action: #selector(goToHome), imageName: "homeNavi")

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [backButton]
        self.navigationItem.rightBarButtonItems = [homeButton]
    }
    
    /// Back버튼과 Bell 버튼 NavigationBar
    func setBackBellNaviBar(_ title: String, bellButton: UIBarButtonItem) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "backButton")
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .white
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [backButton]
        self.navigationItem.rightBarButtonItems = [bellButton]
    }
    
    /// 투명 NavigationBar
    func setClearNaviBar(_ title: String) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        self.navigationItem.titleView = titleLabel
        

        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = .clear
        scrollEdgeAppearance.shadowColor = .clear
        scrollEdgeAppearance.backgroundEffect = nil
        scrollEdgeAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.customFont(.pretendard_bold, 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
    
    // 투명 배경과 back버튼 Navigation Bar
    func setClearBackNaviBar(_ title: String, _ titleColor: UIColor) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = titleColor
        }
        
        let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "backButton")
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [backButton]

        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = .clear
        scrollEdgeAppearance.shadowColor = .clear
        scrollEdgeAppearance.backgroundEffect = nil
        scrollEdgeAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.customFont(.pretendard_bold, 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
    
    // 투명 배경과 흰색 back버튼 NavigationBar
    func setClearWhiteBackNaviBar(_ title: String, _ titleColor: UIColor) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = titleColor
        }
        
        let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "whiteBack")
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [backButton]

        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = .clear
        scrollEdgeAppearance.shadowColor = .clear
        scrollEdgeAppearance.backgroundEffect = nil
        scrollEdgeAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.customFont(.pretendard_bold, 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
    
    /// 향BTI 홈으로 이동하는 Back버튼 Navigation Bar
    func setBackToHBTIVCNaviBar(_ title: String) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popToHBTIViewController), imageName: "backButton")
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [backButton]
    }
    
    /// Back 버튼, Share 버튼 NavigationBar
        func setBackShareRightNaviBar(_ title: String) {
            let titleLabel = UILabel().then {
                $0.text = title
                $0.font = .customFont(.pretendard_medium, 20)
                $0.textColor = .black
            }

            let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "backButton")

            let shareButton = self.navigationItem.makeImageButtonItem(self, action: #selector(shareMagazine), imageName: "share")

            let scrollEdgeAppearance = UINavigationBarAppearance()
            scrollEdgeAppearance.backgroundColor = .white
            scrollEdgeAppearance.shadowColor = .clear

            self.navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
            self.navigationController?.view.backgroundColor = .white

            self.navigationItem.titleView = titleLabel
            self.navigationItem.leftBarButtonItems = [backButton]
            self.navigationItem.rightBarButtonItems = [shareButton]
        }
    
    /// NavigationBarTitle 설정
    func setNavigationBarTitle(_ title: String) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        self.navigationItem.titleView = titleLabel
    }
    
    /// search NavigationBar 설정
    func configureSearchNavigationBar(_ backButton: UIButton?, searchBar: UISearchBar) {
        var barBackButton: UIButton
        
        if let backButton = backButton {
            barBackButton = backButton
            let barButtonItem = UIBarButtonItem(customView: barBackButton)
            barButtonItem.customView?.snp.makeConstraints {
                $0.width.height.equalTo(30)
            }
            self.navigationItem.leftBarButtonItems = [barButtonItem]
        }
        
        let searchBarWrapper = SearchBarContainerView(customSearchBar: searchBar)
        searchBarWrapper.frame = CGRect(x: 0, y: 0, width: self.navigationController!.view.frame.size.width - 44, height: 30)
        self.navigationItem.titleView = searchBarWrapper
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    // MARK: - objc Function
    
    /// popVC
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// RootVC까지 pop
    @objc func goToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /// searchViewController로 push
    @objc func goToSearch() {
        presentSearchViewController()
    }
    
    /// brandSearchViewController로 push
    @objc func goToBrand() {
        presentBrandSearchViewController()
    }
    
    /// Magazine 공유
    @objc func shareMagazine() {
        // TODO: 링크 생성 서비스 유료 계약 후 구현
//        let activityViewController = UIActivityViewController(activityItems: ["url"], applicationActivities: nil)
//        
//        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .saveToCameraRoll, .markupAsPDF]
//        
//        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
//            if success {
//                
//            } else {
//                
//            }
//        }
//        
//        self.present(activityViewController, animated: true, completion: nil)
    }
    
    /// 알림 권한 요청 및 On/Off
    @objc func pushAlarmSetting() {
        // TODO: 알림 권한 요청 및 On/Off 기능 구현
    }
    
    // 향BTI 홈으로 이동
    @objc func popToHBTIViewController() {
        if let viewControllers = navigationController?.viewControllers {
            for vc in viewControllers {
                if vc is HBTIViewController {
                    navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
    
    // MARK: - UI Function
    
    /// 아래 선 설정
    func setBottomBorder(_ sender: AnyObject, width: CGFloat, height: CGFloat, color: Colors = .gray2) {
        let border = CALayer()
        if sender is UITextField {
            border.frame = CGRect(x: 0, y: height -  1, width: width - 16, height: 1)
        } else if sender is UIView {
            border.frame = CGRect(x: 0, y: height -  1, width: width, height: 1)
        }
        border.borderColor = UIColor.customColor(color).cgColor
        border.borderWidth = 1
        sender.layer.addSublayer(border)
        sender.layer.masksToBounds = true
    }
    
    
    /// floatingButton animation 설정
    func showFloatingButtonAnimation(floatingButton: UIButton, stackView: UIStackView, backgroundView: UIView, isTap: Bool) {
        floatingButton.isSelected = isTap
        //버튼, 뷰 숨기기
        if !isTap {
            UIView.animate(withDuration: 0.3) {
                stackView.alpha = 0
                stackView.isHidden = true
                self.view.layoutIfNeeded()
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                backgroundView.alpha = 0
            }) { _ in
                backgroundView.isHidden = true
            }
        }
        // 버튼, 뷰 보이기
        else {
            backgroundView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                backgroundView.alpha = 1
            })
            
            UIView.animate(withDuration: 0.3) {
                stackView.alpha = 1
                stackView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
    }
    
    /// Alert 보여주기
    /// - Parameters:
    ///   - title: Alert 제목: String
    ///   - message: Alert 내용: String
    ///   - buttonTitle1: Alert 버튼1 title: String
    ///   - buttonTitle2: Alert 버튼2 title: String? = nil
    ///   - action1: 버튼 1 액션: (() -> Void)? = nil
    ///   - action2: 버튼 2 액션: (() -> Void)? = nil
    func showAlert(title: String,
                   message: String,
                   buttonTitle1: String,
                   buttonTitle2: String? = nil,
                   action1: (() -> Void)? = nil,
                   action2: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let button1 = UIAlertAction(title: buttonTitle1, style: .default, handler: { _ in
            action1?()
        })
        alert.addAction(button1)
        
        if let buttonTitle2 = buttonTitle2 {
            let button2 = UIAlertAction(title: buttonTitle2, style: .cancel, handler: { _ in
                action2?()
            })
            alert.addAction(button2)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
