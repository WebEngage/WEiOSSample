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
        vc.setUpUI(callBackType: .clickedWithActionInApp(inAppNotificationData, actionId))
        Helper.shared.topmostViewController()?.present(vc, animated: true, completion: nil)
        debugPrint("👉🏻👉🏻👉🏻👉🏻👉🏻 Notification was clicked with action")
    }
    
    func notificationPrepared(_ inAppNotificationData: [String: Any]!, shouldStop stopRendering: UnsafeMutablePointer<ObjCBool>!) -> [AnyHashable: Any]! {
        debugPrint("👉🏻👉🏻👉🏻👉🏻👉🏻 Notification is prepared")
        return inAppNotificationData
    }
    
    func notificationDismissed(_ inAppNotificationData: [String : Any]!) {
        debugPrint("👉🏻👉🏻👉🏻👉🏻👉🏻 Notification Dismissed")
    }
    
    func notificationShown(_ inAppNotificationData: [String : Any]!) {
        debugPrint("👉🏻👉🏻👉🏻👉🏻👉🏻 Notification shown")
    }
    
}


extension AppDelegate: WEGAppDelegate {
    
    func wegHandleDeeplink(_ deeplink: String!, userData data: [AnyHashable : Any]!) {
        guard let callBackVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CallBackViewController") as? CallBackViewController else {return}
        callBackVC.setUpUI(callBackType: .wegHandleDeeplinkPush(deeplink, data))
        Helper.shared.topmostViewController()?.present(callBackVC, animated: true, completion: nil)
        print("Push Notification was clicked")
    }
}

