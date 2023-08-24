//
//  HomeViewController.swift
//  WebEngageSampleApp
//
//  Created by Shubham Naidu on 30/05/23.
//

import UIKit
import WebEngage
import ActivityKit

enum Features : String, CaseIterable {
    case trackEvents = "Track Events"
    case trackScreens = "Track Screens"
    case userAttributes = "User Attributes"
    case InLine = "InLine"
    case appInbox = "App Inbox"
    case liveActivity = "Trigger Live activity"
}

class HomeViewController: UICollectionViewController {
    
    // Array to contain the show the options
    let items : [String] = Features.allCases.map { $0.rawValue }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        setUpRightBarButton()
    }
    
    func setUpRightBarButton() {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(named: "themeColor")
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        button.addTarget(self, action: #selector(showLogoutOptions(_:)), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    // To setup alert by which user can log out and see their username.
    
    @objc func showLogoutOptions(_ sender: UIBarButtonItem) {
        if let cuid = UserDefaults.standard.string(forKey: Keys.cuid.rawValue){
            let alertController = UIAlertController(title: "Logged in as: \(cuid)", message: "Do you want to log out ?", preferredStyle: .alert)
            let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
                // Handle logout
                WebEngage.sharedInstance()?.user.logout()
                UserDefaults.standard.removeObject(forKey: Keys.cuid.rawValue)
                Helper.shared.setInitialViewController()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(logoutAction)
        
            if let popoverPresentationController = alertController.popoverPresentationController {
                popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem
            }
            present(alertController, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sample App"
        self.navigationItem.backButtonTitle = ""
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCVC", for: indexPath) as? CustomCVC else {return UICollectionViewCell()}
        // To confirgure the collection view cells.
        cell.configure(with: items[indexPath.row])
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = Features(rawValue: items[indexPath.row])
        switch item {
        case .trackEvents:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            if let eventsViewController = storyBoard.instantiateViewController(withIdentifier: "EventsViewController") as? TrackEventsViewController {
                navigationController?.pushViewController(eventsViewController, animated: true)
            }
        case .trackScreens:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            if let trackScreensViewController = storyBoard.instantiateViewController(withIdentifier: "ScreensViewController") as? TrackScreensViewController {
                navigationController?.pushViewController(trackScreensViewController, animated: true)
            }
        case .userAttributes:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            if let userAttributesViewController = storyBoard.instantiateViewController(withIdentifier: "UserAttributesViewController") as? UserAttributesViewController {
                navigationController?.pushViewController(userAttributesViewController, animated: true)
            }
        case .InLine:
            print("Inline")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Inline", bundle: nil)
            if let inLineViewController = storyBoard.instantiateViewController(withIdentifier: "CustomScreenViewController") as? CustomScreenViewController {
                navigationController?.pushViewController(inLineViewController, animated: true)
            }
        case .appInbox:
            let storyBoard: UIStoryboard = UIStoryboard(name: "AppInbox", bundle: nil)
            if let appInboxViewController = storyBoard.instantiateViewController(withIdentifier: "AppInboxViewController") as? AppInboxViewController {
                navigationController?.pushViewController(appInboxViewController, animated: true)
            }
            print("AppInbox")
        case .liveActivity:
            LiveActivityMethods.shared.startDeliveryOrder(controller: self)
        default :
            print("Invalid item")
        }
    }
}
