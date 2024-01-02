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
    
    func checkTutorialRun() {
        let isTutorial = UserDefaults.standard.bool(forKey: "Tutorial")
        if !isTutorial {
            let vc = TutorialViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
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
    
    func presentInAppLoginVC() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.reactor = LoginReactor(.inApp)
        self.present(loginVC, animated: true)
    }
    
    func presentLoginStartVC() {
        let vc = LoginStartViewController()
        let nvController = UINavigationController(rootViewController: vc)
        nvController.modalPresentationStyle = .fullScreen
        self.present(nvController, animated: true)
    }
    
    func presentTabBar(_ state: LoginState) {
        switch state {
        case .first:
            let tabBar = AppTabbarController()
            self.view.window?.rootViewController = tabBar
        case .inApp:
            self.view.window?.rootViewController?.dismiss(animated: true)
        }
    }
        
        
    func presentImagePinchVC(_ indexPath: IndexPath, images: [CommunityPhoto]) {
        let vc = ImagePinchViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.reactor = ImagePinchReactor(indexPath.row, images)
        self.present(vc, animated: true)
    }
    
    func presentAlertVC(title: String, content: String, buttonTitle: String) {
        let alertVC = AlertViewController(title: title, content: content, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        self.present(alertVC, animated: false)
    }
    
    // list -> detail
    func presentQnADetailVC(_ id: Int, _ reactor: QNAListReactor) {
        let qnaDetailVC = QnADetailViewController()
        let detailReactor = reactor.reactorForDetail()
        
        qnaDetailVC.reactor = detailReactor
        qnaDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(qnaDetailVC, animated: true)
    }

    // hpedia, writedPost -> detail
    func presentQnADetailVC(_ id: Int) {
        let qnaDetailVC = QnADetailViewController()
        let detailReactor = QnADetailReactor(id, CommunityListService())
        
        qnaDetailVC.reactor = detailReactor
        qnaDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(qnaDetailVC, animated: true)
    }
    func presentQnAWriteVCForEdit(reactor: QnADetailReactor) {
        let qnaWriteVC = QnAWriteViewController()
        let reactor = reactor.reactorForPostEdit()
        qnaWriteVC.reactor = reactor
        qnaWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(qnaWriteVC, animated: true)
    }
    
    func presentQnAWriteVC(_ reactor: QNAListReactor) {
        let qnaWriteVC = QnAWriteViewController()
        let reactor = reactor.reactorForWrite()
        qnaWriteVC.reactor = reactor
        qnaWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(qnaWriteVC, animated: true)
    }
    
    func presentQnAListVC() {
        let qnaListVC = QnAListViewController()
        qnaListVC.reactor = QNAListReactor(service: CommunityListService())
        self.navigationController?.pushViewController(qnaListVC, animated: true)
    }
    
    func presentDetailDictionaryVC(_ type: HpediaType, _ id: Int) {
        let detailDictionaryVC = DetailDictionaryViewController()
        let reactor = DetailDictionaryReactor(type, id)
        detailDictionaryVC.reactor = reactor
        self.navigationController?.pushViewController(detailDictionaryVC, animated: true)
    }
    
    func presentDictionaryViewController(_ type: HpediaType) {
        let dictionaryVC = DictionaryViewController()
        let reactor = DictionaryReactor(type: type)
        dictionaryVC.reactor = reactor
        self.navigationController?.pushViewController(dictionaryVC, animated: true)
    }
    
    func presentDatailViewController(_ id: Int, _ service: BrandDetailService? = nil) {
        let reactor = DetailViewReactor(perfumeId: id, service: service)
        let detailVC = DetailViewController()
        detailVC.reactor = reactor
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func presentCommentViewContorller(_ id: Int) {
        let commentVC = CommentListViewController()
        commentVC.reactor = CommentListReactor(id, service: DetailCommentService())
        commentVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func presentSearchViewController() {
        let searchVC = SearchViewController()
        searchVC.reactor = SearchReactor(service: BrandDetailService())
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func presentCommentDetailViewController(_ comment: Comment?, _ communityCommet: CommunityComment?, _ service: DetailCommentService? = nil) {
        let commentDetailVC = CommentDetailViewController()
        commentDetailVC.hidesBottomBarWhenPushed = true
        commentDetailVC.reactor = CommentDetailReactor(comment, communityCommet, service)
        self.navigationController?.pushViewController(commentDetailVC, animated: true)
    }
    
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
        }
        commentWriteVC.reactor = commentWriteReactor
        commentWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentWriteVC, animated: true)
    }
    
    func presentBrandSearchViewController() {
        let brandSearchVC = BrandSearchViewController()
        brandSearchVC.reactor = BrandSearchReactor()
        self.navigationController?.pushViewController(brandSearchVC, animated: true)
    }
    
    func presentBrandDetailViewController(_ brandId: Int) {
        let brandDetailVC = BrandDetailViewController()
        brandDetailVC.reactor = BrandDetailReactor(brandId, BrandDetailService())
        self.navigationController?.pushViewController(brandDetailVC, animated: true)
    }
    
    func presentTotalPerfumeViewController(_ listType: Int) {
        let totalPerfumeVC = TotalPerfumeViewController()
        totalPerfumeVC.reactor = TotalPerfumeReactor(listType)
        self.navigationController?.pushViewController(totalPerfumeVC, animated: true)
    }
    
    func presentAppTabBarController() {
        let tabBar = AppTabbarController()
        tabBar.modalPresentationStyle = .fullScreen
        self.view.window?.rootViewController = tabBar
        self.present(tabBar, animated: true)
        self.view.window?.rootViewController?.dismiss(animated: false)
    }
    
    func setOkCancleNavigationBar(okButton: UIButton, cancleButton: UIButton, titleLabel: UILabel) {
        
        okButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        cancleButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        let okButtonItem = UIBarButtonItem(customView: okButton)
        let cancleButtonItem = UIBarButtonItem(customView: cancleButton)
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [cancleButtonItem]
        self.navigationItem.rightBarButtonItems = [okButtonItem]
    }
    
    func setNavigationColor() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white

        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setBrandSearchBellNaviBar(_ title: String, bellButton: UIBarButtonItem) {
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
    
    func setBackHomeSearchNaviBar(_ title: String) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "backButton")
        
        let homeButton = self.navigationItem.makeImageButtonItem(self, action: #selector(goToHome), imageName: "homeNavi")
        
        let searchButton = self.navigationItem.makeImageButtonItem(self, action: #selector(goToSearch), imageName: "search")
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [backButton, spacerItem(15), homeButton]
        self.navigationItem.rightBarButtonItems = [searchButton]
    }
    
    func setBackHomeRightNaviBar(_ title: String) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        setNavigationColor()
        
        let backButton = self.navigationItem.makeImageButtonItem(self, action: #selector(popViewController), imageName: "backButton")
        
        let homeButton = self.navigationItem.makeImageButtonItem(self, action: #selector(goToHome), imageName: "homeNavi")

        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [backButton]
        self.navigationItem.rightBarButtonItems = [homeButton]
    }
    
    func setNavigationBarTitle(_ title: String) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        self.navigationItem.titleView = titleLabel
    }
    
    func setNavigationBarTitle(title: String, color: UIColor, isHidden: Bool, isScroll: Bool = true) {
        
        if !isHidden {
            let backButton = UIBarButtonItem(
                image: UIImage(named: "backButton"),
                style: .done,
                target: self,
                action: #selector(popViewController))
           
            backButton.tintColor = .black
            
            self.navigationItem.leftBarButtonItems = [backButton]
        }
        
        self.setNavigationBarTitle(title)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = color

        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        
        //로그인 navigationBar에서도 함수를 쓰기 위해 기존 코드에 영향이 안가게 처리 해놨습니다.
        if isScroll {
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }

    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func goToSearch() {
        presentSearchViewController()
    }
    
    @objc func goToBrand() {
        presentBrandSearchViewController()
    }
    
    func spacerItem(_ width: Int) -> UIBarButtonItem {
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        spacer.width = CGFloat(width)
        return spacer
    }
    
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
}
