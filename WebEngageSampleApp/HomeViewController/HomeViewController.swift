//
//  HomeViewController.swift
//  WebEngageSampleApp
//
//  Created by Shubham Naidu on 30/05/23.
//

import UIKit
import WebEngage

class HomeViewController: UICollectionViewController {
    
    //MARK: Outlet Initializations
    
    
    // Array to contain the show the options

    let items = ["Track Events","Track Screens", "User Attributes", "InLine", "App Inbox"]
    
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

    private func menuItems() -> UIMenu {
        let cuid = UserDefaults.standard.string(forKey: Constants.login) ?? "user"
        let addMenuItems = UIMenu(title: "Logged in as: \(cuid)",options: .displayInline, children: [
            UIAction (title: "Logout") { [unowned self] (_) in
                WebEngage.sharedInstance()?.user.logout()
                UserDefaults.standard.set("", forKey: Constants.login)
                self.navigationController?.popViewController(animated: true)
            }
        ])
        return addMenuItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCVC", for: indexPath) as? CustomCVC else {return UICollectionViewCell()}
        cell.itemName = items[indexPath.row]
        cell.configure(with: items[indexPath.row])
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        switch item {
           case "Track Events":
                let storyBoard: UIStoryboard = UIStoryboard(name: "Events", bundle: nil)
                if let eventsViewController = storyBoard.instantiateViewController(withIdentifier: "EventsViewController") as? EventsViewController {
                    navigationController?.pushViewController(eventsViewController, animated: true)
                }
            
        case "Track Screens" :
            let storyBoard: UIStoryboard = UIStoryboard(name: "Screens", bundle: nil)
            if let trackScreensViewController = storyBoard.instantiateViewController(withIdentifier: "ScreensViewController") as? ScreensViewController {
                navigationController?.pushViewController(trackScreensViewController, animated: true)
            }
            
           case "User Attributes":
                let storyBoard: UIStoryboard = UIStoryboard(name: "UserProfile", bundle: nil)
                if let userProfileViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController {
                    navigationController?.pushViewController(userProfileViewController, animated: true)
                }
            
           case "InLine":
                print("Inline")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Inline", bundle: nil)
            if let inLineViewController = storyBoard.instantiateViewController(withIdentifier: "CustomScreenViewController") as? CustomScreenViewController {
                navigationController?.pushViewController(inLineViewController, animated: true)
            }
            
           case "App Inbox":
            let storyBoard: UIStoryboard = UIStoryboard(name: "AppInbox", bundle: nil)
            if let appInboxViewController = storyBoard.instantiateViewController(withIdentifier: "AppInboxViewController") as? AppInboxViewController {
                navigationController?.pushViewController(appInboxViewController, animated: true)
            }
                print("AppInbox")
           default:
               print("Invalid item")
           }
    }
}
