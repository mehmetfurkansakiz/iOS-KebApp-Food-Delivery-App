//
//  PaymentDaoRepository.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 21.01.2024.
//

import Foundation
import RxSwift
import FirebaseFirestore
import FirebaseAuth

class PaymentDaoRepository {
    var cardList = BehaviorSubject<[Cards]>(value: [Cards]())
    
    // FIRESTORE DATABASE
    let firestoreDatabase = Firestore.firestore()
    var firestoreReference : DocumentReference? = nil
    
    func addCard(viewController: UIViewController, card: Cards) {
        
        let account = firestoreDatabase.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        account.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error?.localizedDescription ?? "Error", in: viewController)
            } else if let documents = snapshot?.documents {
                if let userDocument = documents.first {
                    
                    let cardData = [
                        "id": card.id ?? "",
                        "title": card.title ?? "",
                        "cardNumber": card.cardNumber ?? "",
                        "cardHolderName": card.cardHolderName ?? "",
                        "expirationDate": card.expirationDate ?? "",
                        "cvv": card.cvv ?? ""
                    ] as [String : Any]
                    
                    self.firestoreReference = userDocument.reference.collection("Cards").addDocument(data: cardData) { error in
                        if let error = error {
                            AlertHelper.createAlert(title: "Error", message: error.localizedDescription, in: viewController)
                        } else {
                            print("Card added successfully")
                            self.getCards(viewController: viewController)
                            self.setDefaultCardID(viewController: viewController, defaultCardID: card.id!) {
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getCards(viewController: UIViewController) {
        
        let account = firestoreDatabase.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        account.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
            } else if let documents = snapshot?.documents {
                if let userDocument = documents.first {
                    
                    let cardCollection = userDocument.reference.collection("Cards")
                    
                    cardCollection.getDocuments { (snapshot, error) in
                        if error != nil {
                            AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                        } else if let cardDocuments = snapshot?.documents {
                            var cardList: [Cards] = []
                            for cardDocument in cardDocuments {
                                do {
                                    if let card = try cardDocument.data(as: Cards?.self) {
                                        cardList.append(card)
                                    }
                                } catch {
                                    AlertHelper.createAlert(title: "Error", message: error.localizedDescription, in: viewController)
                                }
                            }
                            self.cardList.onNext(cardList)
                        }
                    }
                }
            }
         }
    }
    
    func deleteCard(viewController: UIViewController, cardID: String) {
        
        let account = firestoreDatabase.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        account.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
            } else if let documents = snapshot?.documents {
                if let userDocument = documents.first {
                    
                    let cardCollection = userDocument.reference.collection("Cards").whereField("id", isEqualTo: cardID)
                    
                    cardCollection.getDocuments { (snapshot, error) in
                        if error != nil {
                            AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                        } else if let cardDocuments = snapshot?.documents {
                            for document in cardDocuments {
                                document.reference.delete { error in
                                    if error != nil {
                                        AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                                    } else {
                                        AlertHelper.createAlert(title: "Success", message: "Card has been successfully deleted.", in: viewController)
                                        self.getCards(viewController: viewController)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func editCard(viewController: UIViewController, cardID: String, updatedCard: Cards) {
        
        let account = firestoreDatabase.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        account.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
            } else if let documents = snapshot?.documents {
                if let userDocument = documents.first {
                    
                    let cardData = [
                        "id": updatedCard.id ?? "",
                        "title": updatedCard.title ?? "",
                        "cardNumber": updatedCard.cardNumber ?? "",
                        "cardHolderName": updatedCard.cardHolderName ?? "",
                        "expirationDate": updatedCard.expirationDate ?? "",
                        "cvv": updatedCard.cvv ?? ""
                    ] as [String : Any]
                    
                    let cardCollection = userDocument.reference.collection("Cards").whereField("id", isEqualTo: cardID)
                    
                    cardCollection.getDocuments { (snapshot, error) in
                        if error != nil {
                            AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                        } else if let cardDocuments = snapshot?.documents {
                            for document in cardDocuments {
                                document.reference.setData(cardData, merge: true) { error in
                                    if error != nil {
                                        AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                                    } else {
                                        print("Card updated successfully")
                                        self.getCards(viewController: viewController)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setDefaultCardID(viewController: UIViewController, defaultCardID: String, completion: @escaping () -> Void) {
        
        let account = firestoreDatabase.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        account.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
            } else if let documents = snapshot?.documents {
                if let userDocument = documents.first {
                    
                    let defaultCardData = [
                        "defaultCardID": defaultCardID
                    ] as [String : Any]
                    
                    userDocument.reference.setData(defaultCardData, merge: true) { error in
                        if error != nil {
                            AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                        } else {
                            print("Default Card Updated successfully")
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func getDefaultCard(viewController: UIViewController, completion: @escaping (Cards?) -> Void) {
        
        let account = firestoreDatabase.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        account.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
            } else if let documents = snapshot?.documents {
                if let userDocument = documents.first {
                    
                    let cardCollection = userDocument.reference.collection("Cards").whereField("id", isEqualTo: userDocument["defaultCardID"] ?? "")
                    
                    cardCollection.getDocuments { snapshot, error in
                        if error != nil {
                            AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                        } else if let cardDocument = snapshot?.documents {
                            var defaultCard: Cards? = nil
                            
                            do {
                                if let card = try cardDocument.first?.data(as: Cards.self) {
                                    defaultCard = card
                                }
                            } catch {
                                AlertHelper.createAlert(title: "Error", message: error.localizedDescription, in: viewController)
                            }
                            completion(defaultCard)
                        }
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }
}
