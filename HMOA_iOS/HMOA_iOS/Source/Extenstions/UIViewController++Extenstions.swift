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
    
    func presentDatailViewController(_ id: Int) {
        let detailVC = DetailViewController()
        detailVC.perfumeId = id
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func presentCommentViewContorller(_ id: Int) {
        let commentVC = CommentListViewController()
        commentVC.perfumeId = id
        commentVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func presentSearchViewController() {
        let searchVC = SearchViewController()
        searchVC.reactor = SearchReactor()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func presentCommentDetailViewController(_ id: Int) {
        let commentDetailVC = CommentDetailViewController()
        commentDetailVC.hidesBottomBarWhenPushed = true
        commentDetailVC.reactor = CommentDetailReactor(id)
        self.navigationController?.pushViewController(commentDetailVC, animated: true)
    }
    
    func presentCommentWriteViewController(_ perfumeId: Int) {
        let commentWriteVC = CommentWriteViewController()
        commentWriteVC.reactor = CommentWriteReactor(
            currentPerfumeId: perfumeId,
            isWrite: false)
        
        commentWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentWriteVC, animated: true)
    }
    
    func presentCommentWirteViewControllerForWriter(_ commentId: Int, _ comment: String) {
        
        let commentWriteVC = CommentWriteViewController()
        commentWriteVC.reactor = CommentWriteReactor(
            isWrite: true,
            content: comment,
            commentId: commentId
        )
        
        commentWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentWriteVC, animated: true)
    }
    
    func presentBrandSearchViewController() {
        let brandSearchVC = BrandSearchViewController()
        brandSearchVC.hidesBottomBarWhenPushed = true
        brandSearchVC.reactor = BrandSearchReactor()
        self.navigationController?.pushViewController(brandSearchVC, animated: true)
    }
    
    func setNavigationColor() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white

        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
        
        self.navigationItem.title = title
        
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
        
    }
    
    @objc func goToSearch() {
        
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
}
