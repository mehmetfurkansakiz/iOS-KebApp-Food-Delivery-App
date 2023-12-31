//
//  RegisterCompleteViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 20.11.2023.
//

import UIKit

class RegisterCompleteViewController: UIViewController {

    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var registerCompleteIndicator: UIActivityIndicatorView!
    
    var viewModel = UserViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appearance()
    }

    @objc func keyboardDismiss(){
        view.endEditing(true)
    }
    
    func appearance(){
        
        selectImageView.layer.cornerRadius = 100
        selectImageView.layer.borderWidth = 1
        selectImageView.layer.borderColor = UIColor.black.cgColor
        
        selectImageView.isUserInteractionEnabled = true
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        selectImageView.addGestureRecognizer(imageTapGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        view.addGestureRecognizer(tapGesture)
    }
    
    func calculateAge(birthDate: Date) -> Int {
        let now = Date()
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        if let age = ageComponents.year {
            return age
        }
        
        return 0
    }
    
    @IBAction func buttonRegisterComplete(_ sender: Any) {
        let age = calculateAge(birthDate: birthdayDatePicker.date) // AGE CALCULATED
        
        if nameTextField.text != "" && surnameTextField.text != "" {
            if age >= 18 {
                self.registerCompleteIndicator.startAnimating()
                let data = selectImageView.image
                
                viewModel.registerUser(viewController: self, data: data, name: nameTextField.text!, surname: surnameTextField.text!, nickname: "\(self.nameTextField.text!)_\(self.surnameTextField.text!)", age: age)
                self.registerCompleteIndicator.stopAnimating()
            } else {
                AlertHelper.createAlert(title: "Error", message: "You must be 18 or older to register.", in: self)
                self.registerCompleteIndicator.stopAnimating()
            }
        } else {
            AlertHelper.createAlert(title: "Error", message: "Name/Surname cannot be empty", in: self)
            self.registerCompleteIndicator.stopAnimating()
        }
    }
}

//MARK: - ImagePicker
extension RegisterCompleteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func selectImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            selectImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectImageView.image = originalImage
        }
        
        dismiss(animated: true)
    }
}
