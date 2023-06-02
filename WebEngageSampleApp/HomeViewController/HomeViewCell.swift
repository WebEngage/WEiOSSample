//
//  CustomCVC.swift
//  WebEngageSampleApp
//
//  Created by Shubham Naidu on 30/05/23.
//

import UIKit

class CustomCVC: UICollectionViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    var itemName = ""
    
    override func awakeFromNib() {
        self.configure(with: itemName)
    }
    
    func configure(with itemName: String){
        itemNameLabel?.text = itemName
        cardView?.layer.cornerRadius = 15
    }
}
