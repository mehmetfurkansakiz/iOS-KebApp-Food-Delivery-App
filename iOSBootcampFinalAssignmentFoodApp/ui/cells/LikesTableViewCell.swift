//
//  LikesTableViewCell.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 8.12.2023.
//

import UIKit

class LikesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var labelFoodPrice: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeAppearance()
    }
    
    private func customizeAppearance() {
        foodImageView.layer.cornerRadius = 16.0
        foodImageView.layer.borderWidth = 1
        foodImageView.layer.borderColor = UIColor.gray.cgColor
        foodImageView.layer.masksToBounds = true
    }
}
