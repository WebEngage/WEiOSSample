//
//  CallBackViewController.swift
//  WebEngageSampleApp
//
//  Created by Uday Sharma on 02/06/23.
//

import UIKit

class CallBackViewController: UIViewController {
    
    //MARK: Outlet Initializations

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpUI(callBackType: CallBackType) {
        
        // To ensure the view is loaded
        self.loadViewIfNeeded()
        
        // Set Up the view according to the callbacks
        switch callBackType {
        case .clickedWithActionInApp(let inAppData, let actionID):
            label1.text = "INAPP NOTICATION CALLBACK"
            label2.text = "Action ID: \(actionID)"
            label3.text = "In app Data : \(inAppData)"
            
        case .wegHandleDeeplinkPush(let deepLink, let userData):
            label1.text = "PUSH NOTICATION CALLBACK"
            label2.text = "DEEPLINK: \(deepLink)"
            label3.text = "USER DATA : \(userData)"
        }
       viewHeightConstraint.constant = (label2.intrinsicContentSize.height + label1.intrinsicContentSize.height + label3.intrinsicContentSize.height)
    }
    
}


enum CallBackType {
   
    case clickedWithActionInApp([String : Any],String)
    case wegHandleDeeplinkPush(String,[AnyHashable : Any])
    
    var associatedValues: Any {
        switch self {
        case .clickedWithActionInApp(let inAppData, let actionID):
            return (inAppData, actionID)
        case .wegHandleDeeplinkPush(let deepLink, let userdData):
            return (deepLink,userdData)
        }
    }
}
