//
//  HomeViewCell.swift
//  WebEngageSampleApp
//
//  Created by Shubham Naidu on 30/05/23.
//

import UIKit

class HomeViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    func configure(with itemName: String){
        itemNameLabel.text = itemName
        cardView.layer.cornerRadius = 15
    }
}
