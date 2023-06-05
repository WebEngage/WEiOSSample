//
//  Helper.swift
//  WebEngageSampleApp
//
//  Created by Uday Sharma on 02/06/23.
//

import Foundation

enum Keys:String{
    case cuid
}

class Helper: NSObject {
    
    static let shared = Helper()
    private let SCREEN_LIST = "screenList"
    var currentInlineScreenDataPosition :Int = -1
    var currentSelectedScreen : InlineScreenData? = nil
    
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
       if let cuid = UserDefaults.standard.value(forKey: Keys.cuid.rawValue) as? String,
          !cuid.isEmpty{
            vcToNaviagte = storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        } else {
            vcToNaviagte = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        }
        let navigation = UINavigationController(rootViewController: vcToNaviagte ?? UIViewController())
        return navigation
    }
    
    func saveListOfScreens(list:Array<InlineScreenData>){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(list) {
            UserDefaults.standard.set(encoded, forKey: SCREEN_LIST)
        }
    }
        
    func getListOfScreen()->Array<InlineScreenData>{
        if let data = UserDefaults.standard.data(forKey: SCREEN_LIST) {
                // decode the data into an array of person objects
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([InlineScreenData].self, from: data) {
                    return decoded
                }
            }
            return [InlineScreenData()]
        }
    
    func getScreenData(screenName : String)->InlineScreenData?{
        let list = getListOfScreen()
        for data in list {
            if(data.screenName == screenName){
                return data
            }
        }
        return nil
    }
    
}

