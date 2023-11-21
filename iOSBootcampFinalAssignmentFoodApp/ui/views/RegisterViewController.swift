//
//  RegisterViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 16.11.2023.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var registerImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    @IBOutlet weak var registerIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearance()
        
    }
    
    @IBAction func buttonRegister(_ sender: Any) {
        registerIndicator.startAnimating()
        if emailTextField.text != "" && passwordTextField.text != "" && passwordRepeatTextField.text != "" {
            if passwordTextField.text == passwordRepeatTextField.text {
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                    if let error = error {
                            AlertHelper.createAlert(title: "Error", message: error.localizedDescription, in: self)
                            self.registerIndicator.stopAnimating()
                        } else {
                            print("Kullanıcı kaydedildi. UID: \(authResult?.user.uid ?? "")")
                            self.performSegue(withIdentifier: "toLoginVC", sender: nil)
                            self.registerIndicator.stopAnimating()
                        }
                }
            } else {
                AlertHelper.createAlert(title: "Error", message: "Passwords do NOT match", in: self)
                self.registerIndicator.stopAnimating()
            }
        } else {
            AlertHelper.createAlert(title: "Error", message: "Email/Password cannot be empty", in: self)
            self.registerIndicator.stopAnimating()
        }
    }
    
    @objc func keyboardDismiss(){
        view.endEditing(true)
    }
    
    func appearance(){
        registerImageView.image = UIImage(named: "kebab")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        view.addGestureRecognizer(tapGesture)
    }
}
