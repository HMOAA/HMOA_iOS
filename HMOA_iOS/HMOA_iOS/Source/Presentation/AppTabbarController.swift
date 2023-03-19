//
//  AppTabbarController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit

class AppTabbarController: UITabBarController {
    
    // MARK: - Properties
    
    let homeTab: UITabBarItem = {
       
        let item = UITabBarItem()
        item.customTabBar(imageName: "home")
        item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -8, right: 0)
        item.title = "Home"
        return item
    }()
    
    let hPediaTab: UITabBarItem = {
       
        let item = UITabBarItem()
        item.customTabBar(imageName: "HPeida")
        
        return item
    }()
    
    let likeTab: UITabBarItem = {
       
        let item = UITabBarItem()
        item.customTabBar(imageName: "drawer")
        
        return item
    }()
    
    let myPageTab: UITabBarItem = {
       
        let item = UITabBarItem()
        item.customTabBar(imageName: "myPage")

        return item
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbar()
    }
}

extension AppTabbarController {
    
    func configureTabbar() {
        
        delegate = self
        
        let homeVC = UINavigationController(
            rootViewController: HomeViewController()),
        hPediaVC = UINavigationController(
            rootViewController: HPediaViewController()),
        likeVC = UINavigationController(
            rootViewController: LikeViewController()),
        myPageVC = UINavigationController(
            rootViewController: MyPageViewController())
        
        viewControllers = [homeVC, hPediaVC, likeVC, myPageVC]
        
        self.selectedIndex = 0
        view.backgroundColor = .white
        tabBar.barTintColor = .black
        tabBar.tintColor = .white
        tabBar.backgroundColor = .black
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = UIColor.customColor(.tabbarColor)
        tabBar.layer.masksToBounds = true
        
        homeVC.tabBarItem = homeTab
        hPediaVC.tabBarItem = hPediaTab
        likeVC.tabBarItem = likeTab
        myPageVC.tabBarItem = myPageTab
        
    }
}

extension AppTabbarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController), let item = tabBar.items?[index] else { return true }
        
        switch index {
        case 0:
            item.title = "Home"
        case 1:
            item.title = "HPedia"
        case 2:
            item.title = "Like"
        case 3:
            item.title = "My"
        default:
            break
        }
        
        item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
        
        tabBar.items?.filter { $0 != item }.forEach {
            $0.title = nil
            $0.imageInsets = UIEdgeInsets(top: 16, left: 0, bottom: -20, right: 0)
        }
        
        return true
    
    }
}
