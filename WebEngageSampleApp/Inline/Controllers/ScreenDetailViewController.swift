//
//  ScreenDetailViewController.swift
//  WebEngageInline
//
//  Created by Milind Keni on 24/02/23.
//

import UIKit

class ScreenDetailViewController: UIViewController {

    var inlineScreenData :InlineScreenData? = nil
    var screenList : Array<InlineScreenData> = []
    
    
    @IBOutlet weak var etListSize: UITextField!
    
    @IBOutlet weak var etScreenName: UITextField!
    
    @IBOutlet weak var etEventName: UITextField!
    
    @IBOutlet weak var etEventAttribute: UITextField!
    
    @IBOutlet weak var switchIsRecycledView: UISwitch!
    
    @IBOutlet weak var inlineDataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenList = Storage.instance.getListOfScreen()
        inlineScreenData = screenList[Storage.instance.currentInlineScreenDataPosition]
        inlineDataTableView.dataSource = self
        inlineDataTableView.delegate = self
        loadData()
        // Do any additional setup after loading the view.
    }
    
    
    func loadData(){
        etScreenName?.text = inlineScreenData?.screenName
        etEventName?.text = inlineScreenData?.event
        etListSize?.text = inlineScreenData?.listSize == nil ? "" : "\(String(describing: inlineScreenData!.listSize))"
        etEventAttribute?.text = inlineScreenData?.screenAttribute
        if let isOn = inlineScreenData?.isRecycledView{
            switchIsRecycledView.setOn(isOn, animated: true)
        }
      
        inlineDataTableView.reloadData()
    }
    
    @IBAction func addData(_ sender: Any) {
        showInputDialog(title: "Add Data",
                        subtitle: "Please enter the data for inline view.",
                        actionTitle: "Add",
                        cancelTitle: "Cancel",
                        inlineWidgetdata: nil,
                        actionHandler:
                                { (input:InlineWidgetData) in
            self.inlineScreenData?.listOfInlineWidgetData.append(input)
            self.inlineDataTableView.reloadData()
                                })
    }
    
    func updateData(inlineWidgetdata:InlineWidgetData){
        showInputDialog(title: "Update Data",
                        subtitle: "Please enter the data for inline view.",
                        actionTitle: "Update",
                        cancelTitle: "Cancel",
                        inlineWidgetdata: inlineWidgetdata,
                        actionHandler:
                                { (input:InlineWidgetData) in
           // self.inlineScreenData?.listOfInlineWidgetData.append(input)
            self.inlineDataTableView.reloadData()
                                })
    }
    
    
    @IBAction func saveForm(_ sender: Any) {
        print("saveForm")
        if let text = etListSize.text, let number = Int(text) {
            inlineScreenData?.listSize = number
        }
        if let screenName = etScreenName.text{
            inlineScreenData?.screenName = screenName
        }
        if let eventName = etEventName.text{
            inlineScreenData?.event = eventName
        }
        if let eventAttribute = etEventAttribute.text{
            inlineScreenData?.screenAttribute = eventAttribute
        }
        
        inlineScreenData?.isRecycledView = switchIsRecycledView.isOn
        
        Storage.instance.saveListOfScreens(list: screenList)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ScreenDetailViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inlineScreenData!.listOfInlineWidgetData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let screenCell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! DataTableViewCell
        let widget = inlineScreenData?.listOfInlineWidgetData[indexPath.row]
        screenCell.labelPosition.text = "Position : \(widget!.position)"
        screenCell.labelHeight.text = "Height : \(widget!.viewHeight)"
        screenCell.labelWidth.text = "Width : \(widget!.viewWidth)"
        screenCell.labelProperty.text = "Property ID : \(widget!.iosPropertyId)"
        screenCell.btnEdit.tag = indexPath.row
        screenCell.btnEdit.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        screenCell.screenCellView.layer.cornerRadius = 10
        return screenCell
    }
    
    @objc func pressed(sender:UIButton) {
        updateData(inlineWidgetdata: inlineScreenData!.listOfInlineWidgetData[sender.tag])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class DataTableViewCell : UITableViewCell{
    @IBOutlet weak var labelPosition: UILabel!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var labelWidth: UILabel!
    @IBOutlet weak var labelProperty: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var screenCellView: UIView!
}

extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inlineWidgetdata:InlineWidgetData? = nil,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: InlineWidgetData) -> Void)? = nil) {
        var _inlineWidgetData = inlineWidgetdata ?? InlineWidgetData();
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Position to display"
            textField.keyboardType = UIKeyboardType.numberPad
            if let text = inlineWidgetdata?.position{
                textField.text = "\(text)"
            }
        }
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "view height"
            textField.keyboardType = UIKeyboardType.numberPad
            if let text = inlineWidgetdata?.viewHeight{
                textField.text = "\(text)"
            }
        }
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "view width"
            textField.keyboardType = UIKeyboardType.numberPad
            if let text = inlineWidgetdata?.viewWidth{
                textField.text = "\(text)"
            }
        }
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "property id"
            textField.keyboardType = UIKeyboardType.numberPad
            if let text = inlineWidgetdata?.iosPropertyId{
                textField.text = "\(text)"
            }
        }
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "is Custom View"
            textField.keyboardType = UIKeyboardType.default
            if let text = inlineWidgetdata?.isCustomView{
                textField.text = "\(text)"
            }
        }
        
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(_inlineWidgetData)
                return
            }
            if let value = alert.textFields?[0].text, let number = Int(value){
                _inlineWidgetData.position = number
            }
            if let value = alert.textFields?[1].text, let number = Int(value){
                _inlineWidgetData.viewHeight = number
            }
            if let value = alert.textFields?[2].text, let number = Int(value){
                _inlineWidgetData.viewWidth = number
            }
            if let value = alert.textFields?[3].text, let number = Int(value){
                _inlineWidgetData.iosPropertyId = number
            }
            if let value = alert.textFields?[4].text{
                _inlineWidgetData.isCustomView = (value == "true")
            }
           
            actionHandler?(_inlineWidgetData)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showListDialog(
        currentData : InlineScreenData,
        actionHandler: ((_ text: InlineScreenData) -> Void)? = nil) {
    
        let alert = UIAlertController(title: "Screen List", message: "", preferredStyle: .alert)
            let list = Storage.instance.getListOfScreen()
            for data in list {
                if(data.screenName != currentData.screenName){
                    
                    alert.addAction(UIAlertAction(title: "Screen: \(data.screenName)", style: .default, handler: { (action:UIAlertAction) in
                        actionHandler?(data)
                    }))
                    
                }
            }

        
    

        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
