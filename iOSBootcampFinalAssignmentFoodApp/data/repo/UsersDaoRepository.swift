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

class UsersDaoRepository {
    var user = BehaviorSubject<User>(value: User())
    var nickname: String?
    
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
}
