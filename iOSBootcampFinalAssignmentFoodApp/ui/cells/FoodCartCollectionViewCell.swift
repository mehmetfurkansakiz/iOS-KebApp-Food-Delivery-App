//
//  FoodCartCollectionViewCell.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 14.10.2023.
//

import UIKit

class FoodCartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var labelTotalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeAppearance()
    }

    private func customizeAppearance() {
        self.layer.cornerRadius = 15
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 15).cgPath
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
    }
}
