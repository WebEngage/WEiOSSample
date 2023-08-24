//
//  LiveActivityMethods.swift
//  WebEngageSampleApp
//
//  Created by Uday Sharma on 26/07/23.
//

import Foundation
import ActivityKit
import UIKit

class LiveActivityMethods : NSObject {
    
    static var shared : LiveActivityMethods = LiveActivityMethods()
    
    //method to invoke live activity
    func startDeliveryOrder(controller: UIViewController) {
        if !(ActivityAuthorizationInfo().areActivitiesEnabled) {
            genericMessageToast(title: nil, message: "You have disabled the live activity please enable it from the setting",controller: controller)
        }
        else {
            let OrderDeliveryAttributes = LiveActivityAttributes(numberOfOrders: 1, totalAmount:"$99")
            
            let initialContentState = LiveActivityAttributes.LiveActivityStatus(userName: "Uday", estimatedDeliveryTime:  Date()...Date().addingTimeInterval(1 * 60))
            
            do {
                let OrderDeliveryActivity = try Activity<LiveActivityAttributes>.request(
                    attributes: OrderDeliveryAttributes,
                    contentState: initialContentState,
                    pushType: .token)   // Enable Push Notification Capability First (from pushType: nil)
                
                print("Requested a Order delivery Live Activity \(OrderDeliveryActivity.id)")
                
                // Send the push token to server
                Task {
                    for await pushToken in OrderDeliveryActivity.pushTokenUpdates {
                        let pushTokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }
                        print(pushTokenString)
                        genericMessageToast(title : "SUCCESS 🫶🏼",message: "Push Token: \(pushTokenString)",controller: controller)
                    }
                }
            } catch (let error) {
                print("Error requesting Order delivery Live Activity \(error.localizedDescription)")
                genericMessageToast(title: nil, message: "Error requesting Order delivery Live Activity \(error.localizedDescription)",controller: controller)
            }
        }
        
        
    }
    func genericMessageToast(title : String?,message : String?,controller: UIViewController?) {
        let alertController = UIAlertController(title: title ?? "FAILURE" , message: message ?? "Some error Occured" , preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            if let popoverPresentationController = alertController.popoverPresentationController {
                popoverPresentationController.barButtonItem =  Helper.shared.topmostViewController()?.navigationItem.rightBarButtonItem
            }
           controller?.present(alertController, animated: false, completion: nil)
        }
       
    }
    func stopDeliveryPizza(controller:UIViewController?) {
        Task {
            for activity in Activity<LiveActivityAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }
            print("Cancelled pizza delivery Live Activity")
            genericMessageToast(title: "Sorry", message: "Cancelled pizza delivery Live Activity",controller: controller ?? Helper.shared.topmostViewController())
        }
    }
    private override init() {}
}
