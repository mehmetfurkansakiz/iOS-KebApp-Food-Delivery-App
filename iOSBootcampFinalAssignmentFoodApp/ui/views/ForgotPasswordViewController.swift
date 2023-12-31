//
//  ForgotPasswordViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 30.12.2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var forgotImageView: UIImageView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    let userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buttonPasswordReset(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            AlertHelper.createAlert(title: "Error", message: "Please enter your email address.", in: self)
                    return
        }
        userViewModel.sendPasswordReset(email: email, viewController: self)
    }
}
