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
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = color

        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func spacerItem(_ width: Int) -> UIBarButtonItem {
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        spacer.width = CGFloat(width)
        return spacer
    }
}
