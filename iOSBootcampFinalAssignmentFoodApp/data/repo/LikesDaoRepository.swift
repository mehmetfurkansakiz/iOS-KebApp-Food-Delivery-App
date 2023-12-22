//
//  LikesDaoRepository.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 4.12.2023.
//

import Foundation
import RxSwift
import FirebaseFirestore
import FirebaseAuth

class LikesDaoRepository {
    var likedFoodList = BehaviorSubject<[Foods]>(value: [Foods]())
    
    // FIRESTORE DATABASE
    let firestore = Firestore.firestore()
    var firestoreReference : DocumentReference? = nil
    
    func getFoodImageUrl(imageName: String) -> URL? {
        return URL(string: ("http://kasimadalan.pe.hu/yemekler/resimler/" + imageName))
    }
    
    func setLike(viewController: UIViewController, food: Foods) {
        
        let firestoreLikes = [
            "yemek_id": food.yemek_id!,
            "yemek_adi" : food.yemek_adi!,
            "yemek_fiyat" : food.yemek_fiyat!,
            "yemek_resim_adi" : food.yemek_resim_adi!,
            "email" : Auth.auth().currentUser!.email!,
        ] as [String : Any]
        
        firestoreReference = firestore.collection("Likes").addDocument(data: firestoreLikes, completion: { error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error?.localizedDescription ?? "Error", in: viewController)
            } else {
                AlertHelper.createAlert(title: "Success", message: "Food has been successfully liked.", in: viewController)
            }
        })
    }
    
    func undoLike(viewController: UIViewController, food: Foods) {
        let userLikes = firestore.collection("Likes")
            .whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
            .whereField("yemek_id", isEqualTo: food.yemek_id!)
        
        userLikes.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error?.localizedDescription ?? "Error", in: viewController)
            } else if let document = snapshot?.documents.first{
                let documentID = document.documentID
                self.firestore.collection("Likes").document(documentID).delete() { error in
                    if error != nil {
                        AlertHelper.createAlert(title: "Error", message: error?.localizedDescription ?? "Error", in: viewController)
                    } else {
                        AlertHelper.createAlert(title: "Success", message: "Food has been successfully removed.", in: viewController)
                    }
                }
            }
        }
    }
    
    func getLikes(viewController: UIViewController) {
        let userLikes = firestore.collection("Likes")
            .whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        userLikes.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error?.localizedDescription ?? "Error", in: viewController)
            } else if let documents = snapshot?.documents {
                var likedFoods: [Foods] = []
                for document in documents {
                    do {
                        if let like = try document.data(as: Foods?.self) {
                            likedFoods.append(like)
                        }
                    } catch {
                        AlertHelper.createAlert(title: "Error", message: error.localizedDescription, in: viewController)
                    }
                }
                
                self.likedFoodList.onNext(likedFoods)
            }
        }
    }
}
