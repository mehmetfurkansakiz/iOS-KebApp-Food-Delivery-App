//
//  RegisterCompleteViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 20.11.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class RegisterCompleteViewController: UIViewController {

    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var registerCompleteIndicator: UIActivityIndicatorView!
    
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
            // Yaş bilgisini string olarak döndür
            return age
        }
        
        // Hesaplama başarısız olursa varsayılan değeri döndür
        return 0
    }
    
    @IBAction func buttonRegisterComplete(_ sender: Any) {
        let age = calculateAge(birthDate: birthdayDatePicker.date) // AGE CALCULATED
        
        if nameTextField.text != "" && surnameTextField.text != "" {
            if age >= 18 {
                self.registerCompleteIndicator.startAnimating()
                let storage = Storage.storage()
                let storageReference = storage.reference()
                let avatarFolder = storageReference.child("avatars")
                
                if let data = selectImageView.image?.jpegData(compressionQuality: 0.5) {
                    let uuid = UUID().uuidString
                    let avatarReference = avatarFolder.child("\(uuid).jpg")
                    
                    avatarReference.putData(data, metadata: nil) { metadata, error in
                        if error != nil {
                            AlertHelper.createAlert(title: "Error", message: error?.localizedDescription ?? "Error", in: self)
                        } else {
                            avatarReference.downloadURL { url, error in
                                if error == nil {
                                    
                                    let avatarUrl = url?.absoluteString
                                    //if the profile picture is not uploaded, the default picture from the link "https://www.flaticon.com/free-icon/user_149071" will be uploaded from smashicons.
                                    
                                    let currentDate = Date()

                                    // Format the date
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd-MM-yyyy"  // d-M-yyyy formatında da kullanabilirsiniz
                                    let formattedDate = dateFormatter.string(from: currentDate)
                                    
                                    // FIRESTORE DATABASE
                                    let firestoreDatabase = Firestore.firestore()
                                    var firestoreReference : DocumentReference? = nil
                                    
                                    let firestoreRegister = [
                                        "name" : self.nameTextField.text!,
                                        "surname" : self.surnameTextField.text!,
                                        "nickname" : "\(self.nameTextField.text!)_\(self.surnameTextField.text!)",
                                        "email" : Auth.auth().currentUser!.email!,
                                        "age" : age,
                                        "avatarUrl" : avatarUrl!,
                                        "registrationDate" : formattedDate,
                                    ] as [String : Any]
                                    
                                    firestoreReference = firestoreDatabase.collection("Accounts").addDocument(data: firestoreRegister, completion: { error in
                                        if error != nil {
                                            AlertHelper.createAlert(title: "Error", message: error?.localizedDescription ?? "Error", in: self)
                                        } else {
                                            self.performSegue(withIdentifier: "registerToHome", sender: nil)
                                        }
                                        self.registerCompleteIndicator.stopAnimating()
                                    })
                                }
                            }
                        }
                    }
                }
                
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
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
}
