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
    
    func presentDatailViewController() {
        let detailVC = DetailViewController()
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
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
        
        let backButton = self.navigationItem.makeButtonItem(self, action: #selector(popViewController), imageName: "backButton")
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [backButton]
    }
    
    func setBackHomeSearchNaviBar(_ title: String) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        let backButton = self.navigationItem.makeButtonItem(self, action: #selector(popViewController), imageName: "backButton")
        
        let homeButton = self.navigationItem.makeButtonItem(self, action: #selector(goToHome), imageName: "homeNavi")
        
        let searchButton = self.navigationItem.makeButtonItem(self, action: #selector(goToSearch), imageName: "search")
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [backButton, spacerItem(15), homeButton]
        self.navigationItem.rightBarButtonItems = [searchButton]
    }
    
    func setNavigationBarTitle(title: String, color: UIColor, isHidden: Bool) {
        
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
}
