//
//  AppTabbarController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit
// test
class AppTabbarController: UITabBarController {
    
    // MARK: - Properties
    
    let menuTab: UITabBarItem = {
       
        let item = UITabBarItem()
        item.customTabBar(imageName: "menu")

        return item
    }()
    
    let newsTab: UITabBarItem = {
       
        let item = UITabBarItem()
        item.customTabBar(imageName: "news")

        return item
    }()
    
    let homeTab: UITabBarItem = {
       
        let item = UITabBarItem()
        item.customTabBar(imageName: "home")
        
        return item
    }()
    
    let drawerTab: UITabBarItem = {
       
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
        let menuVC = MenuViewController(),
        newsVC = NewsViewController(),
        homeVC = HomeViewController(),
        drawerVC = DrawerViewController(),
        myPageVC = MyPageViewController()
        
        viewControllers = [menuVC, newsVC, homeVC, drawerVC, myPageVC]
        
        self.selectedIndex = 2
        tabBar.backgroundColor = .black
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = UIColor.customColor(.tabbarColor)
        tabBar.layer.cornerRadius = tabBar.frame.height * 0.22
        tabBar.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        menuVC.tabBarItem = menuTab
        newsVC.tabBarItem = newsTab
        homeVC.tabBarItem = homeTab
        drawerVC.tabBarItem = drawerTab
        myPageVC.tabBarItem = myPageTab
    }
}
