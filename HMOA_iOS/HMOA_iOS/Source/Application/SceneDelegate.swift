//
//  SceneDelegate.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/10.
//

import UIKit

import RxKakaoSDKAuth
import KakaoSDKAuth
import ReactorKit
import GoogleSignIn
import PretendardKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        setFirstViewController()
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url {
            // 카카오 링크
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
            // 구글 링크
            else if ((url.scheme?.contains("com.googleusercontent.apps")) != nil) {
                GIDSignIn.sharedInstance.handle(url)
            }
            
            else {
                // 기타 URL 처리 로직
            }
        }
    }
    
    func moveToViewController(by deeplink: URL) {
        let tabbarController = window?.rootViewController as! UITabBarController
        let navigationController = tabbarController.selectedViewController as! UINavigationController
        let homeVC = navigationController.viewControllers.first!
       
        let urlString = deeplink.absoluteString
        let path = urlString.replacingOccurrences(of: "hmoa://", with: "").split(separator: "/")
        let category = String(path[0])
        let ID = Int(String(path[1]))!
        
        switch category {
        case "community":
            homeVC.presentCommunityDetailVC(ID)
        case "perfume_comment":
            homeVC.presentDetailViewController(ID)
            // TODO: 댓글 목록으로 이동
        default:
            print("unknown category: \(category)")
        }
    }
    
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // App -> 아이폰 설정 알림 On/Off -> 앱으로 돌아왔을 때 푸쉬 알림 설정 여부 체크
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let isPushEnabled = settings.authorizationStatus == .authorized
                LoginManager.shared.isPushAlarmAuthorization.onNext(isPushEnabled)
            }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

extension SceneDelegate {
    
    // 로그인 기록에 따른 첫 뷰컨트롤러 설정
    
    func setFirstViewController() {
        PretendardKit.register()
        let loginManager: LoginManager = LoginManager.shared
        let token = KeychainManager.read()
        if UserDefaults.isFirstLaunch() {
            if let token = token {
                KeychainManager.delete()
            }
            let vc = LoginViewController()
            vc.reactor = LoginReactor(.first)
            window?.rootViewController = vc
            DispatchQueue.main.async {
                vc.checkTutorialRun()
            }
        } else {
            if let token = token {
                print("start \(token)")
                let vc = AppTabbarController()
                window?.rootViewController = vc
                loginManager.tokenSubject.onNext(token)
                DispatchQueue.main.async {
                    vc.checkTutorialRun()
                }
            } else {
                let vc = LoginViewController()
                vc.reactor = LoginReactor(.first)
                window?.rootViewController = vc
                DispatchQueue.main.async {
                    vc.checkTutorialRun()
                }
            }
        }
    }
}

