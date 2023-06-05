//
//  Helper.swift
//  WebEngageSampleApp
//
//  Created by Uday Sharma on 02/06/23.
//

import Foundation


class Helper: NSObject {
    
    static let shared = Helper()
    
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

