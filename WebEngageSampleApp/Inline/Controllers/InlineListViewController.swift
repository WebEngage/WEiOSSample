//
//  InlineListViewController.swift
//  WebEngageInline
//
//  Created by Milind Keni on 26/02/23.
//

import UIKit
import WebEngage
import WEPersonalization
class InlineListViewController: UIViewController {
    
    let names = ["John", "Emma", "Liam", "Olivia", "Noah", "Ava", "William", "Sophia", "James", "Isabella"]
    let messages = [
        "Hello, how are you?","What are you up to?","I'm heading to the park.","Let's grab lunch tomorrow.","Did you watch the game last night?","Remember to pick up some groceries.","Happy birthday! 🎉","Can you help me with this task?","I'm excited for our upcoming.","Just wanted to say hi!"
    ]
    let images = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    var inlineScreenData : InlineScreenData = Storage.instance.currentSelectedScreen!
    var weAnalytics = WebEngage.sharedInstance().analytics
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleName: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleName.title = inlineScreenData.screenName
        let addButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(openScreenDialog))
        let eventButton = UIBarButtonItem(image: UIImage(systemName: "note.text"), style: .plain, target: self, action: #selector(openEventTrackingDailog))
        titleName.rightBarButtonItems = [addButton, eventButton]
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    
    @objc func openScreenDialog(){
        showListDialog(
            currentData: inlineScreenData,
            actionHandler:
                { (input:InlineScreenData) in
                    Storage.instance.currentSelectedScreen = input
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "InlineListViewController")
                    self.navigationController?.pushViewController(vc!, animated: true)
                })
    }

    @objc func openEventTrackingDailog(){
        let alert = UIAlertController.init(title: "Track Event", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Track Event"
        }

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction.init(title: "Track Event", style: .default, handler: {[unowned self] (_) in

            let event = alert.textFields![0].text

            guard let eventName = event, (event != nil), !((event?.isEmpty)!)else {
                self.presentEventFailAlert(for: event)
                return
            }
            WebEngage.sharedInstance().analytics.trackEvent(withName: eventName)
            self.presentEventSuccessAlert(for: eventName)
        }))
        
        alert.addAction(UIAlertAction(title: "Track Custom Event", style: .default, handler: { [unowned self] (_) in
            self.openCustomEventTrackingDailog()
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func openCustomEventTrackingDailog(){
        let alert = UIAlertController.init(title: "Track Custom Event", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Enter Key"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Enter Value"
            textField.text = "{\"key1\":\"value1\", \"key2\":\"value2\"}"
        }

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction.init(title: "Track Event", style: .default, handler: { [unowned self] (_) in

            let key = alert.textFields![0].text
            let value = alert.textFields![1].text

            guard (key != nil), (value != nil), !((key?.isEmpty)!), !((value?.isEmpty)!) else {
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

    
    override func viewWillAppear(_ animated: Bool) {
        print("wept called \(inlineScreenData.screenName)")
        if(!inlineScreenData.screenName.isEmpty){
            if(inlineScreenData.screenAttribute.isEmpty){
                weAnalytics?.navigatingToScreen(withName: inlineScreenData.screenName)
            }else{
                if let number = Int(inlineScreenData.screenAttribute){
                    weAnalytics?.navigatingToScreen(withName: inlineScreenData.screenName, andData: ["id":number])
                }else {
                    weAnalytics?.navigatingToScreen(withName: inlineScreenData.screenName, andData: ["id":inlineScreenData.screenAttribute])
                }
                
            }
            if(!inlineScreenData.event.isEmpty){
                weAnalytics?.trackEvent(withName: inlineScreenData.event)
            }
            for data in inlineScreenData.listOfInlineWidgetData{
                if(data.position < inlineScreenData.listSize){
                    WEPersonalization.shared.registerWEPlaceholderCallback(data.iosPropertyId, self)
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    private func presentEventSuccessAlert(for event: String) {
        let alert = UIAlertController.init(title: "Event tracking Success ✅", message: "Entered event: \(event)", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Done", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentEventFailAlert(for event: String?) {
        let alert = UIAlertController.init(title: "Event tracking failed ❌", message: "Event cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Done", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func generateRandomNumber() -> Int {
        let randomNumber = Int.random(in: 0...9)
        return randomNumber
    }
    
}

extension InlineListViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inlineScreenData.listSize + inlineScreenData.listOfInlineWidgetData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row + 1
        var contains = false;
        var height = -1;
        for data in inlineScreenData.listOfInlineWidgetData{
            if(data.position == index){
                contains = true
                height = data.viewHeight
                break
            }
        }
        if(height <= 0){
            height = 90
        }
        return contains ? CGFloat(height) : 90
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if inlineScreenData.isRecycledView {
            if let data = self.inlineScreenData.listOfInlineWidgetData.first(where: {$0.position == (indexPath.row + 1)}){
                let listViewCell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell") as! ListViewCell
                listViewCell.contentView.frame.size.width = tableView.frame.width
                print("1 CellSize\(listViewCell.contentView.bounds.width), \(indexPath.row)")
                listViewCell.inlineView.tag = data.iosPropertyId
                listViewCell.inlineView.load(tag: data.iosPropertyId, callbacks: self)
                cell = listViewCell
                
            }else{
                let listViewCell = tableView.dequeueReusableCell(withIdentifier: "ListViewStaticCell") as! ListViewStaticCell
                listViewCell.contentView.frame.size.width = tableView.frame.width
                print("2 CellSize\(listViewCell.contentView.bounds.width), \(indexPath.row)")
                for subview in listViewCell.contentView.subviews {
                    subview.removeFromSuperview()
                }
                listViewCell.contentView.addSubview(createDummyView(text: "\(indexPath.row + 1)",cell: listViewCell,index: indexPath.row))
                cell = listViewCell
            }
        }else{
            let reuseIdentifier = "cell_\(indexPath.row + 1)"
            let screenCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell()
            screenCell.contentView.frame.size.width = tableView.frame.width
            print("3 CellSize\(screenCell.contentView.bounds.width), \(indexPath.row)")
            let index = indexPath.row + 1
            var contains = false;
            var _inlineView:WEInlineView?=nil
            if(inlineScreenData.isRecycledView){
                screenCell.contentView.addSubview(createDummyView(text: "Recycled view is not added yet ",cell: screenCell,index: index))
                return screenCell
            }
            for data in inlineScreenData.listOfInlineWidgetData{
                if(data.position == index){
                    if(data.isCustomView){
                        contains = true
                        let _view = CustomView(frame: CGRect(x: 0, y: 0, width: screenCell.contentView.frame.size.width, height: CGFloat(data.viewHeight)))
                        _view.setData(width: screenCell.contentView.frame.size.width, inlineData: data)
                        
                        screenCell.addSubview(_view)
                        break
                    }
                    contains = true
                    _inlineView = WEInlineView(frame: CGRect(x: 0, y: 0, width: data.viewWidth == 0 ? screenCell.contentView.frame.size.width : CGFloat(data.viewWidth), height: CGFloat(data.viewHeight)))
                    _inlineView!.tag = data.iosPropertyId
                    screenCell.addSubview(_inlineView!)
                    break
                }
            }
            if(!contains){
                for view in screenCell.contentView.subviews{
                    view.removeFromSuperview()
                }
                screenCell.contentView.addSubview(createDummyView(text: "\(index)",cell: screenCell,index: index))
            }
            return screenCell
        }
        return cell
    }
    
    
}

extension InlineListViewController : WEPlaceholderCallback{
    public func onRendered(data: WECampaignData) {
        print("wep t onRendered")
    }
    
    public func onDataReceived(_ data: WECampaignData) {
        print("wep t onDataReceived")
    }
    
    public func onPlaceholderException(_ campaignId: String?, _ targetViewId: String, _ exception: Error) {
        print("wep t onPlaceholderException \(exception.localizedDescription)")
    }
    
}

extension InlineListViewController{
    func createDummyView(text:String,cell:ListViewCell,index:Int)->UIView{
        let cellWidth = cell.contentView.frame.size.width
        let containerView = UIView(frame: CGRect(x: 0, y: 10, width: cellWidth, height: 80))
        containerView.backgroundColor = index % 2 == 0 ? UIColor.lightGray : UIColor.lightText
        containerView.layer.cornerRadius = 10.0
        view.addSubview(containerView)
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: 80))
        label.text = text
        label.textAlignment = .center
        containerView.addSubview(label)
        return containerView
    }
    
    func createDummyView(text:String,cell:UITableViewCell,index:Int)->UIView{
        let cellWidth = cell.contentView.frame.size.width
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: 85))
        containerView.layer.cornerRadius = 10.0
        containerView.backgroundColor = .init(white: 0.9, alpha: 0.2)
        
        let messageLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15)
            label.numberOfLines = 0
            label.text = messages[index % 10]
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let nameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 17)
            label.numberOfLines = 0
            label.text = names[index % 10]
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let posotionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 17)
            label.numberOfLines = 0
            label.text = text
            label.textAlignment = .right
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let emptyLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 17)
            label.numberOfLines = 0
            label.text = "   "
            label.textAlignment = .right
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: images[index % 10])
            imageView.layer.cornerRadius = 25
            imageView.layer.masksToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 8
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(messageLabel)
        
        let verticalStackView2 = UIStackView()
        verticalStackView2.axis = .vertical
        verticalStackView2.alignment = .fill
        verticalStackView2.distribution = .fill
        verticalStackView2.spacing = 8
        
        verticalStackView2.addArrangedSubview(posotionLabel)
        verticalStackView2.addArrangedSubview(emptyLabel)
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 8
        
        horizontalStackView.addArrangedSubview(profileImageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(verticalStackView2)
        
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        containerView.addSubview(horizontalStackView)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        horizontalStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        return containerView
    }
}


class ListViewCell:UITableViewCell{
    @IBOutlet weak var inlineView: WEInlineView!
    
    @IBOutlet weak var positionLabel: UILabel!
}

class ListViewStaticCell:UITableViewCell{
    @IBOutlet weak var positionLabel: UILabel!
}

class CustomView : UIView,WEPlaceholderCallback{
    
    var inlineData :InlineWidgetData? = nil
    var dataLabel : UILabel? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setData(width:CGFloat,inlineData : InlineWidgetData){
        self.inlineData = inlineData
        addSubview(createDummyView(width:width))
        WEPersonalization.shared.registerWEPlaceholderCallback(inlineData.iosPropertyId, self)
    }
    
    
    func createDummyView(width:CGFloat)->UIView{
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat(inlineData!.viewHeight)))
        containerView.backgroundColor = UIColor.blue
        containerView.layer.cornerRadius = 10.0
        addSubview(containerView)
        
        let stackView   = UIStackView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat(inlineData!.viewHeight)))
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.fillProportionally
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(createLabel(text: "Property ID : \(String(describing: inlineData!.iosPropertyId))", width: width))
        dataLabel = createLabel(text: "Data : fetching...", width: width,height: CGFloat(inlineData!.viewHeight-30))
        stackView.addArrangedSubview(dataLabel!)
        
        return containerView
    }
    
    func createLabel(text:String,width:CGFloat,height:CGFloat = 20)->UILabel{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        label.text = text
        label.backgroundColor = UIColor.green
        label.textAlignment = .center
        label.numberOfLines = 20;
        return label
    }
    
    func onDataReceived(_ data: WECampaignData) {
        DispatchQueue.main.async {
            self.dataLabel?.text = data.toJSONString()
        }
        
    }
    
    func onPlaceholderException(_ campaignId: String?, _ targetViewId: String, _ exception: Error) {
        DispatchQueue.main.async {
            self.dataLabel?.text = "ERROR \(exception.localizedDescription)"
        }
    }
    
}

