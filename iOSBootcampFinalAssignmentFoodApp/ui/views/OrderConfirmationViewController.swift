//
//  OrderConfirmationViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 2.03.2024.
//

import UIKit

class OrderConfirmationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toHomeVC", sender: nil)
    }
}
