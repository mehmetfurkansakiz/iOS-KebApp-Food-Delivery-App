//
//  OrderSumTableViewCell.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 6.01.2024.
//

import UIKit

class OrderSumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelItemName: UILabel!
    @IBOutlet weak var labelItemPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
