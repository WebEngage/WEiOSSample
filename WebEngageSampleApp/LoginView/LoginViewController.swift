//
//  ViewController.swift
//  WebEngageSampleApp
//
//  Created by Shubham Naidu on 30/05/23.
//

import UIKit
import WebEngage

class LoginViewController: UIViewController {

    @IBOutlet weak var cuidTextField: UITextField!
    @IBOutlet weak var jwtTokenTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func loginPressed(_ sender: Any) {
        guard let cuid = cuidTextField.text, !(cuid.isEmpty)else {
            return
        }
        if let jwtToken = jwtTokenTextField.text, !(jwtToken.isEmpty) {
            WebEngage.sharedInstance().user.login(cuid, jwtToken: jwtToken)
        } else {
            WebEngage.sharedInstance().user.login(cuid)
        }
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
}

