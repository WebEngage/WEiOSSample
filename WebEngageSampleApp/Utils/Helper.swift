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
    
    func setInitialViewController(){
        DispatchQueue.main.async {
            if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first{
                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
                appDelegate.window = window
                let rootVC = self.getRootViewController()
                window.rootViewController = rootVC
                window.makeKeyAndVisible()
            }
        }
    }
    func getRootViewController() -> (UIViewController?) {
      
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
        var vcToNaviagte:UIViewController?
        let loginDetail = UserDefaults.standard.value(forKey: Constants.login) as! String
        if loginDetail != ""{
            vcToNaviagte = storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        } else {
            vcToNaviagte = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        }
        let navigation = UINavigationController(rootViewController: vcToNaviagte ?? UIViewController())
        return navigation
    }
}

