//
//  CallBackViewController.swift
//  WebEngageSampleApp
//
//  Created by Uday Sharma on 02/06/23.
//

import UIKit

class CallBackViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpUI(callBackType: CallBackType) {
//         TO ensure the view is loaded
        self.loadViewIfNeeded()
        
        // Set Up the view according to the callbacks
        switch callBackType {
        case .clickedWithActionInApp(let inAppData, let actionID):
            label1.text = "Action ID for this In app : \(actionID)"
            label2.text = "In app Data : \(inAppData)"
            
        case .notificationPreparedInApp(let inAppData,  let shouldStop):
            label1.text = "notification should stop = : \(shouldStop)"
            label2.text = "In app Data : \(inAppData)"
          
        case .notificationDismissedInApp(let inAppData):
            label1.text = "Your notification was dissmissed"
            label2.text = "In app Data : \(inAppData)"
            
        case .notificationShownInApp(let inAppData):
            label1.text = "Your notification was showm"
            label2.text = "In app Data : \(inAppData)"
            
        case .wegHandleDeeplinkPush(let deepLink, let userData):
            label1.text = "Your notification's deep link : \(deepLink)"
            label2.text = "User Data : \(userData)"
        }
    }
    
}


enum CallBackType {
   
    case clickedWithActionInApp([String : Any],String)
    case notificationPreparedInApp([String : Any], UnsafeMutablePointer<ObjCBool>)
    case notificationDismissedInApp([String : Any])
    case notificationShownInApp([String : Any])
    case wegHandleDeeplinkPush(String,[AnyHashable : Any])
    
    var associatedValues: Any {
        switch self {
        case .clickedWithActionInApp(let inAppData, let actionID):
            return (inAppData, actionID)
        case .notificationPreparedInApp(let inAppData,  let shouldStop):
            return (inAppData,shouldStop)
        case .notificationDismissedInApp(let inAppData):
            return (inAppData)
        case .notificationShownInApp(let inAppData):
            return (inAppData)
        case .wegHandleDeeplinkPush(let deepLink, let userdData):
            return (deepLink,userdData)
        }
    }
}
