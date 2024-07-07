//
//  AppDelegate.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/10.
//

import UIKit
import CoreData

import GoogleSignIn
import RxKakaoSDKCommon
import RxKakaoSDKAuth
import KakaoSDKAuth
import FirebaseCore
import FirebaseMessaging
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureNavigationBar()
        
        RxKakaoSDK.initSDK(appKey: Key.KAKAO_NATIVE_APP_KEY)
        FirebaseApp.configure()
        
        configurePushAlarm(application: application)
        
        // splash 보이는 시간
        sleep(2)
        
        return true
    }
    
    func configureNavigationBar() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HMOA_iOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return false
//    }

}

// MARK: - NotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {

    /// 스위즐링 NO시, APNs등록, 토큰값가져옴
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // TODO: - 홈 화면 알림 테스트 해보기
    /// 앱화면 보고있는중에 푸시올 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .badge, .sound])
    }
    
    /// 알림 탭 시 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        handleDeeplink(userInfo)
        
        readAlarm(userInfo)
        
        completionHandler()
    }
    
    func handleDeeplink(_ userInfo: [AnyHashable: Any]) {
        if let deepLink = userInfo["deeplink"] as? String, let url = URL(string: deepLink) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.moveToViewController(by: url)
            }
        }
    }
    
    func readAlarm(_ userInfo: [AnyHashable: Any]) {
        if let notificationIDString = userInfo["id"] as? String,
           let notificationID = Int(notificationIDString) {
            PushAlarmAPI.putAlarmRead(ID: notificationID)
                .subscribe(onNext: { response in
                    print("Server responded successfully: \(response)")
                }, onError: { error in
                    print("Server response failed: \(error)")
                }).disposed(by: disposeBag)
        }
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken: \(fcmToken)")
        LoginManager.shared.fcmTokenSubject.onNext(fcmToken)
    }
}

extension AppDelegate {
    
    /// pushAlram 기본 세팅
    func configurePushAlarm(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
        Messaging.messaging().isAutoInitEnabled = true
        Messaging.messaging().delegate = self
    }
    
}

