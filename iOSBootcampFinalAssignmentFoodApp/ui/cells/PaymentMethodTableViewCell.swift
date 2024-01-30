//
//  PaymentMethodsTableViewCell.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 6.01.2024.
//

import UIKit

class PaymentMethodsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCardName: UILabel!
    @IBOutlet weak var labelCardNumber: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
