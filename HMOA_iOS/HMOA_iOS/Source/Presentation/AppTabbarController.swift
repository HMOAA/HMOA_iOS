//
//  AppTabbarController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit

class AppTabbarController: UITabBarController {
    
    // MARK: - Properties
    
    private let homeTab: UITabBarItem = {
       
        let item = UITabBarItem()
        item.customTabBar(imageName: "home")
        item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        item.title = "Home"
        return item
    }()
    
    private let hPediaTab: UITabBarItem = {
       
        let item = UITabBarItem()
        item.customTabBar(imageName: "HPeida")
        
        return item
    }()
    
    private let magazineTab: UITabBarItem = {
       
        let item = UITabBarItem()
        item.customTabBar(imageName: "magazine")
        
        return item
    }()
    
    private let myPageTab: UITabBarItem = {
       
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
    
    private func configureTabbar() {
        
        delegate = self
        
        
        let homeVC = HomeViewController()
        homeVC.reactor = HomeViewReactor()
        
        let hpediaVC = HPediaViewController()
        hpediaVC.reactor = HPediaReactor(service: CommunityListService())
        
        let magazineVC = MagazineViewController()
        magazineVC.reactor = MagazineReactor()
        
        let myPageReactor = MyPageReactor(service: UserService())
        let myPageVC = MyPageViewController(reactor: myPageReactor)
        
        let homeNVC = UINavigationController(
            rootViewController: homeVC),
        hPediaNVC = UINavigationController(
            rootViewController: hpediaVC),
        magazineNVC = UINavigationController(
            rootViewController: magazineVC),
        myPageNVC = UINavigationController(
            rootViewController: myPageVC)
        
        
        viewControllers = [homeNVC, hPediaNVC, magazineNVC, myPageNVC]
        
        self.selectedIndex = 0
        view.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = UIColor.customColor(.gray3)
        tabBar.layer.masksToBounds = true
        tabBar.layer.addBorder([.top], color: .customColor(.gray1), width: 1)
        
        homeNVC.tabBarItem = homeTab
        hPediaNVC.tabBarItem = hPediaTab
        magazineNVC.tabBarItem = magazineTab
        myPageNVC.tabBarItem = myPageTab
        
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
            item.title = "Magazine"
        case 3:
            item.title = "My"
        default:
            break
        }
        
        item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        tabBar.items?.filter { $0 != item }.forEach {
            $0.title = nil
            $0.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
        }
        
        return true
    
    }
}
