//
//  WebAppDelegate.swift
//
//
//  Created by Uday Sharma on 18/05/23.
//

import Foundation
import WebEngage


extension AppDelegate : WEGInAppNotificationProtocol {
    
    func notification(_ inAppNotificationData: [String : Any]!, clickedWithAction actionId: String!) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CallBackViewController") as? CallBackViewController else { return  }
        _ = vc.view
        vc.setUpUI(callBackType: .clickedWithActionInApp(inAppNotificationData, actionId))
        Helper.shared.topmostViewController()?.present(vc, animated: true, completion: nil)
        print("Notificaction was clicked with action")
    }
    func notificationPrepared(_ inAppNotificationData: [String: Any]!, shouldStop stopRendering: UnsafeMutablePointer<ObjCBool>!) -> [AnyHashable: Any]! {
        //        DispatchQueue.main.async {
        //            guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CallBackViewController") as? CallBackViewController else {
        //                return
        //            }
        //            _ = vc.view
        //            vc.setUpUI(callBackType: .notificationPreparedInApp(inAppNotificationData, stopRendering))
        //            Helper.shared.topmostViewController()?.present(vc, animated: true, completion: nil)
        //            print("Notification prepared")
        //        }
        return inAppNotificationData
    }
    
    
    
    
    func notificationDismissed(_ inAppNotificationData: [String : Any]!) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CallBackViewController") as? CallBackViewController else { return }
        _ = vc.view
        vc.setUpUI(callBackType: .notificationDismissedInApp(inAppNotificationData))
        Helper.shared.topmostViewController()?.present(vc, animated: true, completion: nil)
        print("Notificaction shown")
        
    }
    
    func notificationShown(_ inAppNotificationData: [String : Any]!) {
        //        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CallBackViewController") as? CallBackViewController else { return }
        //        _ = vc.view
        //        vc.setUpUI(callBackType: .notificationShownInApp(inAppNotificationData))
        //        Helper.shared.topmostViewController()?.present(vc, animated: true, completion: nil)
        print("Notificaction shown")
    }
    
}


extension AppDelegate: WEGAppDelegate {
    
    func wegHandleDeeplink(_ deeplink: String!, userData data: [AnyHashable : Any]!) {
//        guard let vc = Helper.shared.callBackVC else {return}
        guard let callBackVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CallBackViewController") as? CallBackViewController else {return}
        callBackVC.setUpUI(callBackType: .wegHandleDeeplinkPush(deeplink, data))
        Helper.shared.topmostViewController()?.present(callBackVC, animated: true, completion: nil)
        print("Push Notification was clicked")
    }
}


class Helper: NSObject {
    
    static let shared = Helper()
    
    let callBackVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CallBackViewController") as? CallBackViewController
    
    private override init() {
        // Private initializer to enforce singleton behavior
    }
    
    func topmostViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let mainWindow = windowScene.windows.first else {
            return nil
        }
        var topViewController = mainWindow.rootViewController
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    
}

