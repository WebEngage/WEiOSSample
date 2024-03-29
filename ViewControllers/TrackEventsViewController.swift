//
//  EventsViewController.swift
//  WebEngageSampleApp
//
//  Created by Shubham Naidu on 30/05/23.
//

import UIKit
import WebEngage

class TrackEventsViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.becomeFirstResponder()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Track Events"
    }

    private func presentEventSuccessAlert(for event: String) {
        let alert = UIAlertController.init(title: "Event tracking Success ✅", message: "Entered event: \(event)", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Cool", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func presentEventFailAlert(for event: String?) {
        let alert = UIAlertController.init(title: "Event tracking failed ❌", message: "Entered event: \(event ?? "nil")", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Damn!", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Single Event Handler
extension TrackEventsViewController {

    @IBAction func trackEventTapped(_ sender: UIButton) {

        if let event = textField.text, !event.replacingOccurrences(of: " ", with: "").isEmpty {
            WebEngage.sharedInstance()?.analytics.trackEvent(withName: event)
            self.presentEventSuccessAlert(for: event)
        } else {
            self.presentEventFailAlert(for: textField.text)
        }
    }

}

// MARK: - Custom Events Handlers
extension TrackEventsViewController {

    @IBAction func trackCustomEventTapped(_ sender: UIButton) {

        let alert = UIAlertController.init(title: "Track Custom Event", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Enter Key"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Enter Value"
            textField.text = "{\"key1\":\"value1\", \"key2\":\"value2\"}"
        }

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction.init(title: "Track Event", style: .default, handler: { (_) in

            let key = alert.textFields![0].text
            let value = alert.textFields![1].text

            guard (key != nil), (value != nil), !((key?.replacingOccurrences(of: " ", with: "").isEmpty)!), !((value?.replacingOccurrences(of: " ", with: "").isEmpty)!) else {
                self.presentCustomEventFail(key: key, value: value)
                return
            }

            if let data = value?.data(using: String.Encoding.utf8) {

                do {
                    if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable: Any] {
                        WebEngage.sharedInstance()?.analytics.trackEvent(withName: key!, andValue: dict)
                        self.presentCustomEventSuccess(key: key!, value: value!)
                    } else {
                        self.presentCustomEventFail(key: key, value: value)
                    }

                } catch let error as NSError {
                    self.presentCustomEventFail(key: key, value: value)
                    print(error)
                }

            } else {
                self.presentCustomEventFail(key: key, value: value)
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }

    private func presentCustomEventFail(key: String?, value: String?) {

        let alert = UIAlertController.init(title: "Event tracking Failed ❌", message: "Entered key: \(key ?? "nil") & value: \(value ?? "nil")",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Damn!", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func presentCustomEventSuccess(key: String, value: String) {

        let alert = UIAlertController.init(title: "Event tracking Success ✅", message: "Entered key: \(key) & value: \(value)",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Cool", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
