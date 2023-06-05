//
//  SecondViewController.swift
//  WebEngageInline
//
//  Created by Milind Keni on 23/02/23.
//

import UIKit
import WebEngage

class CustomScreenViewController: UIViewController {
   

    @IBOutlet weak var btnGoBack: UIButton!
    @IBOutlet weak var tableViewScreen: UITableView!
    var screenList : Array<InlineScreenData> = []
    var weAnalytics = WebEngage.sharedInstance().analytics
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewScreen.dataSource = self
        tableViewScreen.delegate = self
        screenList = Helper.shared.getListOfScreen()
    }

    @IBAction func btnAddScreen(_ sender: Any) {
        screenList.append(InlineScreenData())
        tableViewScreen.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        screenList = Helper.shared.getListOfScreen()
        tableViewScreen.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        WebEngage.sharedInstance().analytics.navigatingToScreen(withName: "Custom Screen")
    }
}

class ScreenTableViewCell:UITableViewCell {
    
    
    @IBOutlet weak var tvScreenName: UILabel!
    
  
    @IBOutlet weak var btnOpenScreen: UIButton!
    
}

extension CustomScreenViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let screenCell = tableView.dequeueReusableCell(withIdentifier: "screenCell", for: indexPath) as! ScreenTableViewCell
        screenCell.tvScreenName.text = "Screen Name : \(screenList[indexPath.row].screenName)"
        screenCell.btnOpenScreen.tag = indexPath.row
        screenCell.btnOpenScreen.addTarget(self, action: #selector(openListScreen), for: .touchUpInside)
        return screenCell
    }
    
    @objc func openListScreen(sender:UIButton){
        Helper.shared.currentSelectedScreen = screenList[sender.tag]
        let vc = storyboard?.instantiateViewController(withIdentifier: "InlineListViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func openDetailScreen(position : Int) {
         Helper.shared.saveListOfScreens(list: self.screenList)
         Helper.shared.currentInlineScreenDataPosition = position
        let vc = storyboard?.instantiateViewController(withIdentifier: "ScreenDetailViewController")
        vc?.title = "Add Details"
        self.navigationController?.pushViewController(vc!, animated: true)
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openDetailScreen(position: indexPath.row)
    }
    
}
