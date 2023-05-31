//
//  ViewController.swift
//  WebEngageInline
//
//  Created by Milind Keni on 20/02/23.
//

import UIKit
import WebEngage
import WEPersonalization
class InlineHomeViewController: UIViewController {
    struct Constants {
        
        static let login = "UserDefaults.loginID"
        static let badgeSize: CGFloat = 18
        static let badgeTag: Int = 12
    }

    @IBOutlet weak var tvCuid: UITextField!
    
    @IBOutlet weak var cuidLabel: UILabel!
    @IBOutlet weak var btnLoginLogout: UIButton!
    @IBOutlet weak var switchAutoClick: UISwitch!
    var isUserLoggedIn = false
    let weUser: WEGUser = WebEngage.sharedInstance().user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isUserLoggedIn = Storage.instance.isLogged()
        tvCuid.isHidden = isUserLoggedIn
        cuidLabel.isHidden = !isUserLoggedIn
        btnLoginLogout.setTitle(!isUserLoggedIn ? "Login" : "Logout", for: .normal)
        WEPersonalization.shared.registerWECampaignCallback(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        if let currentLoginID = UserDefaults.standard.value(forKey: Constants.login) as? String {
            cuidLabel.text = "Logged in as: \(currentLoginID)"
        }
    }

    @IBAction func performLoginLogoutAction(_ sender: Any) {
        if(!isUserLoggedIn){
            if(tvCuid.text != nil && tvCuid.text!.isEmpty){
                return
            }
        }
        isUserLoggedIn = !isUserLoggedIn
        if(isUserLoggedIn){
            weUser.login(tvCuid.text)
//            weUser.login(tvCuid.text, jwtToken: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiY3VpZCI6InNuX2lvcyIsImFkbWluIjp0cnVlLCJpYXQiOjE1MTYyMzkwMjJ9.Vssaf9-FgEzKWuZRM-n0f-52X6BV0xeSj-HNbdv_Faxy0tRXCiJFvK2M76MarG4fhlA1qcUmJ_-OhLdkBiP22CB-q7zo9gu-w3U5wADPFCelteM0fDH78QyCMQdJSRBHvrauB7SDcTyroQPNJ_CGQQl0yLLrTtYFSFqm9xkbDhzgODsVyZelN-vr7qIfr4isuWhgZZHCyLvpYdviSFiB7Jc5Rs-H7V5-aBMhYGnRGppgs35zqoO8Pjg8HjbTdFCcchIfx6-cBPv8UOVRoS6BESfJtKGcPDOt9FvjujW1oC3UTzLE4HxLva-OvDUxILviIycBwh7FMwPs2kL6tSKMSLsbt1hgCPU1XWPK4GBMHyu4orJbTvBvHJu_ARKWQBgD3y4XHzPPNW7-aulRV_Mq6IEOKlNPw3YrdgVCY6MRrThS3S2tlN4fe44JgUrWbAmQCbUim85Q9az9nz1Vs0spIzOzYWbmDemMtUfEa8vna00OTPyNaUGFxOLIZnfx3MbgfyY6YHv_V3YJH4BpW-jzAleYzZfjjkMja8UsDS2p_GM6ai9kHdqjRP_9ssaAl24pENBMgrevj-kMV_1S6uwbLv-MaaCyP6UeQw5SIkxu8HFgIJcGipXdIRnrnDSxonH_fgHQNhumQVeq-4kiIXbjlOcfnwDDl7jaZs55YRDmmBk")
            UserDefaults.standard.set(tvCuid.text, forKey: Constants.login)
            cuidLabel.text = "Logged in as: \(tvCuid.text!)"
        }else{
            weUser.logout()
            UserDefaults.standard.removeObject(forKey: Constants.login)
        }
        Storage.instance.isLogged(isLoggedIn: isUserLoggedIn)
        tvCuid.isHidden = isUserLoggedIn
        cuidLabel.isHidden = !isUserLoggedIn
        btnLoginLogout.setTitle(!isUserLoggedIn ? "Login" : "Logout", for: .normal)
    }
    
//    @IBAction func goToCustomScreen(_ sender: Any) {
//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//        let secondViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SecondViewController")
//        self.navigationController?.pushViewController(secondViewController, animated: true)
//    }
    
}

extension InlineHomeViewController:WECampaignCallback{
    func onCampaignClicked(actionId: String, deepLink: String, data: WECampaignData) -> Bool {
        if(!switchAutoClick.isOn){
            let url = URL(string: deepLink)!
            let path = url.path.replacingOccurrences(of: "/", with: "")
            if(!path.isEmpty){
                if let data = Storage.instance.getScreenData(screenName: path){
                    Storage.instance.currentSelectedScreen = data
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "InlineListViewController")
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
        return !switchAutoClick.isOn
    }
}



