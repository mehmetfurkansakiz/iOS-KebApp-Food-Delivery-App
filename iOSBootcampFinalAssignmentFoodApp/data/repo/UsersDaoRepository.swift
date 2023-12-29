//
//  UsersDaoRepository.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 26.11.2023.
//

import Foundation
import RxSwift
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UsersDaoRepository {
    var user = BehaviorSubject<User>(value: User())
    var nickname: String?
    
    func registerUser(viewController: UIViewController, data: UIImage!, name: String, surname: String, nickname: String, age: Int) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let avatarFolder = storageReference.child("avatars")
        
        if let data = data?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let avatarReference = avatarFolder.child("\(uuid).jpg")
            
            avatarReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    AlertHelper.createAlert(title: "Error", message: error?.localizedDescription ?? "Error", in: viewController)
                    //                    self.registerCompleteIndicator.stopAnimating()
                } else {
                    avatarReference.downloadURL { url, error in
                        if error != nil {
                            print(error!.localizedDescription)
                        } else {
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
                                "name" : name,
                                "surname" : surname,
                                "nickname" : nickname,
                                "email" : Auth.auth().currentUser!.email!,
                                "age" : age,
                                "avatarUrl" : avatarUrl!,
                                "registrationDate" : formattedDate,
                            ] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Accounts").addDocument(data: firestoreRegister, completion: { error in
                                if error != nil {
                                    AlertHelper.createAlert(title: "Error", message: error?.localizedDescription ?? "Error", in: viewController)
                                } else {
                                    viewController.performSegue(withIdentifier: "registerToHome", sender: nil)
                                }
                                //                                self.registerCompleteIndicator.stopAnimating()
                            })
                        }
                    }
                }
            }
        }
    }
    
    func getUser(viewController: UIViewController) {
        let firestore = Firestore.firestore()
        
        firestore.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                viewController.dismiss(animated: true)
                return
            } else {
                guard let querySnapshot = snapshot else {
                    AlertHelper.createAlert(title: "Error", message: "Data not available", in: viewController)
                    viewController.dismiss(animated: true)
                    return
                }
                let profile = User()
                
                for document in querySnapshot.documents{
                    
                    if let nickname = document.get("nickname") as? String {
                        profile.nickname = nickname
                        self.nickname = nickname
                    }
                    if let email = document.get("email") as? String {
                        profile.email = email
                    }
                    if let name = document.get("name") as? String {
                        profile.name = name
                    }
                    if let surname = document.get("surname") as? String {
                        profile.surname = surname
                    }
                    if let age = document.get("age") as? Int {
                        profile.age = age
                    }
                    if let registrationDate = document.get("registrationDate") as? Date {
                        profile.registrationDate = registrationDate
                    }
                    if let avatarImage = document.get("avatarUrl") as? String {
                        profile.avatarImage = avatarImage
                    }
                }
                self.nickname = profile.nickname
                self.user.onNext(profile)
            }
        }
    }
    
    func getNickname(completion: @escaping (String?) -> Void) {
        let firestore = Firestore.firestore()
        
        firestore.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            if error != nil {
                completion(nil)
                return
            } else {
                guard let querySnapshot = snapshot else {
                    completion(nil)
                    return
                }
                
                for document in querySnapshot.documents {
                    if let nickname = document.get("nickname") as? String {
                        completion(nickname)
                    }
                }
            }
        }
    }
    
    func getRegistrationStatus(completion: @escaping (Bool) -> Void) {
        let firestore = Firestore.firestore()

        firestore.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            if error != nil {
                completion(false)
                return
            } else {
                guard let querySnapshot = snapshot else {
                    completion(false)
                    return
                }
                completion(querySnapshot.documents.count > 0)
            }
        }
    }
}
