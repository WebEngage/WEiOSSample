//
//  NotificationService.swift
//  NotificationViewController
//
import UserNotifications

// Here you have conformed to the service extension class e.g. -> UNNotificationServiceExtension

class NotificationService: UNNotificationServiceExtension {
    
    // Make an instance for WEXPushNotificationService
    //WEXPushNotificationService -> Service extension class for WebEngage
    
    let wegSerivceExtenionInstance = WEXPushNotificationService()
    
    //Override the didReceive method here
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        // call the didReceive method here and it is all set.
        wegSerivceExtenionInstance.didReceive(request, withContentHandler: contentHandler)
        
        // you can call other service method if you want
    }
    
    // other service code here
    
}

