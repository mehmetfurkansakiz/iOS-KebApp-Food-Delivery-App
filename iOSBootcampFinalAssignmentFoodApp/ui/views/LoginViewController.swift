//
//  LoginViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 15.11.2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelForgotPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearance()
        
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            self.performSegue(withIdentifier: "toHomeVC", sender: nil)
        }
    }
    
    
    @IBAction func buttonLogin(_ sender: Any) {
        loginIndicator.startAnimating()
        if emailTextField.text != "" && passwordTextField.text != "" {
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                    if let error = error {
                        print("Giriş hatası: \(error.localizedDescription)")
                        AlertHelper.createAlert(title: "Error", message: error.localizedDescription, in: self)
                        self.loginIndicator.stopAnimating()
                    } else {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        print("Kullanıcı giriş yaptı. UID: \(authResult?.user.uid ?? "")")
                        self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                        self.loginIndicator.stopAnimating()
                    }
                }
        } else {
            AlertHelper.createAlert(title: "Error", message: "Email/Password cannot be empty", in: self)
            self.loginIndicator.stopAnimating()
        }
    }
    
    @objc func labelForgotPasswordTapped() {
        performSegue(withIdentifier: "toForgotPasswordVC", sender: nil)
    }
    
    @objc func keyboardDismiss(){
        view.endEditing(true)
    }
    
    func appearance(){
        loginImageView.image = UIImage(named: "kebab")
        
        let keyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        let forgotTapGesture = UITapGestureRecognizer(target: self, action: #selector(labelForgotPasswordTapped))
        
        labelForgotPassword.isUserInteractionEnabled = true
        labelForgotPassword.addGestureRecognizer(forgotTapGesture)
        view.addGestureRecognizer(keyboardTapGesture)
    }
}
