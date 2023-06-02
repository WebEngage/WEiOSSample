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
    @IBOutlet weak var logInButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableButton(button: logInButtonOutlet)
        cuidTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                for: .editingChanged)
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
        UserDefaults.standard.set(cuid, forKey: Constants.login)
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        if let text = sender.text, (text.isEmpty) {
            disableButton(button: logInButtonOutlet)
        }
        
        else {
            enableButton(button: logInButtonOutlet)
        }
    }
    
    func disableButton(button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .disabled)
        button.alpha = 0.4
        button.layer.cornerRadius = 20
    }
    func enableButton(button: UIButton) {
        button.isEnabled = true
        button.alpha = 1
        button.layer.cornerRadius = 20
    }
}




