//
//  HomeViewController.swift
//  WebEngageSampleApp
//
//  Created by Shubham Naidu on 30/05/23.
//

import UIKit
import WebEngage

enum Features : String, CaseIterable {
    case trackEvents = "Track Events"
    case trackScreens = "Track Screens"
    case userAttributes = "User Attributes"
    case InLine = "InLine"
    case appInbox = "App Inbox"
}


class HomeViewController: UICollectionViewController {
    
    // Array to contain the show the options
    
    let items : [String] = Features.allCases.map { $0.rawValue }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), primaryAction: nil, menu: menuItems())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sample App"
        self.navigationItem.backButtonTitle = ""
    }
    
    // To setup the menu by which user can log out and see their username.
    
    private func menuItems() -> UIMenu? {
        if let cuid = UserDefaults.standard.string(forKey: Keys.cuid.rawValue){
            let addMenuItems = UIMenu(title: "Logged in as: \(cuid)",options: .displayInline, children: [
                UIAction (title: "Logout") { (_) in
                    WebEngage.sharedInstance()?.user.logout()
                    UserDefaults.standard.removeObject(forKey: Keys.cuid.rawValue)
                    Helper.shared.setInitialViewController()
                }
            ])
            return addMenuItems
        }
        return nil
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
            let storyBoard: UIStoryboard = UIStoryboard(name: "Events", bundle: nil)
            if let eventsViewController = storyBoard.instantiateViewController(withIdentifier: "EventsViewController") as? EventsViewController {
                navigationController?.pushViewController(eventsViewController, animated: true)
            }
        case .trackScreens:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Screens", bundle: nil)
            if let trackScreensViewController = storyBoard.instantiateViewController(withIdentifier: "ScreensViewController") as? ScreensViewController {
                navigationController?.pushViewController(trackScreensViewController, animated: true)
            }
        case .userAttributes:
            let storyBoard: UIStoryboard = UIStoryboard(name: "UserProfile", bundle: nil)
            if let userProfileViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController {
                navigationController?.pushViewController(userProfileViewController, animated: true)
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
            
        default :
            print("Invalid item")
        }
    }
}
