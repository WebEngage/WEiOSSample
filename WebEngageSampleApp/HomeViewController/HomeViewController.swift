//
//  HomeViewController.swift
//  WebEngageSampleApp
//
//  Created by Shubham Naidu on 30/05/23.
//

import UIKit
import WebEngage

class HomeViewController: UICollectionViewController {

    let items = ["Track Events", "User Attributes", "InLine", "App Inbox"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), primaryAction: nil, menu: menuItems())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sample App"
        self.navigationItem.backButtonTitle = ""
    }

    private func menuItems() -> UIMenu {
        let addMenuItems = UIMenu(title: "Logged in as: sn_ios",options: .displayInline, children: [
            UIAction (title: "Logout") { [unowned self] (_) in
                WebEngage.sharedInstance()?.user.logout()
                let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier:"LoginViewController") as!
                    LoginViewController
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated:true, completion:nil)
            }
        ])
        return addMenuItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? HomeViewCell {
            itemCell.configure(with: items[indexPath.row])
            cell = itemCell
        }
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
                print("AppInbox")
           default:
               print("Invalid item")
           }
    }
}
