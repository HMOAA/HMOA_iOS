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
    
    func setNavigationSearchBar() {
        let logoImageView = UIImageView(image: UIImage(named: "mainLogo"))
        let logoImageItem = UIBarButtonItem(customView: logoImageView)
        let searchBarView = UISearchBar()
        searchBarView.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width) - 60 - Int(logoImageView.frame.size.width), height: 44)
        searchBarView.backgroundColor = UIColor.customColor(.searchBarColor)
        searchBarView.searchTextField.backgroundColor = UIColor.clear
        
        let searchImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30.0, height: 0))
        searchImage.image = UIImage(named: "search")
        searchImage.contentMode = .right

        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 30.0, height: 0))
        emptyView.backgroundColor = .clear
        emptyView.addSubview(searchImage)
        
        searchBarView.searchTextField.leftView = emptyView

        let searchBarItem = UIBarButtonItem(customView: searchBarView)
        
        self.navigationItem.leftBarButtonItems = [spacerItem(13), logoImageItem, spacerItem(20), searchBarItem]
        

        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    func spacerItem(_ width: Int) -> UIBarButtonItem {
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        spacer.width = CGFloat(width)
        return spacer
    }
}
