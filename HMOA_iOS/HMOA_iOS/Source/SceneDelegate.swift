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
        //KeychainManager.delete()
        window = UIWindow(windowScene: windowScene)
        setFirstViewController()
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
            
            else if ((url.scheme?.contains("com.googleusercontent.apps")) != nil) {  //구글 링크인지
                GIDSignIn.sharedInstance.handle(url)
            }
            
            else {
                // 기타 URL 처리 로직
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let isPushEnabled = settings.authorizationStatus == .authorized
                UserDefaults.standard.set(isPushEnabled, forKey: "alarm")
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
    //로그인 기록에 따른 첫 뷰컨트롤러 설정
    func setFirstViewController() {
        PretendardKit.register()
        let loginManager: LoginManager = LoginManager.shared
        if let token = KeychainManager.read() {
            print("start \(token)")
            let vc = AppTabbarController()
            window?.rootViewController = vc
            loginManager.tokenSubject.onNext(token)
            
        } else {
            let vc = LoginViewController()
            vc.reactor = LoginReactor(.first)
            window?.rootViewController = vc
        }
        
    }
}

