//
//  AddressDaoRepository.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 7.01.2024.
//

import Foundation
import RxSwift
import FirebaseFirestore
import FirebaseAuth

class AddressDaoRepository {
    var addressList = BehaviorSubject<[Address]>(value: [Address]())
    
    // FIRESTORE DATABASE
    let firestoreDatabase = Firestore.firestore()
    var firestoreReference : DocumentReference? = nil
    
    func addAddress(viewController: UIViewController, address: Address) {
        
        let account = firestoreDatabase.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        
        account.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error?.localizedDescription ?? "Error", in: viewController)
            } else if let documents = snapshot?.documents {
                if let userDocument = documents.first {
                    
                    let addressData = [
                        "id": address.id!,
                        "addressTitle": address.addressTitle ?? "",
                        "postalCode": address.postalCode ?? "",
                        "city": address.city ?? "",
                        "state": address.state ?? "",
                        "street": address.street ?? "",
                        "buildingNumber": address.buildingNumber ?? "",
                        "doorNumber": address.doorNumber ?? "",
                        "floorNumber": address.floorNumber ?? "",
                        "telephoneNo": address.telephoneNo ?? ""
                    ] as [String : Any]
                    
                    self.firestoreReference = userDocument.reference.collection("Address").addDocument(data: addressData) { error in
                        if let error = error {
                            AlertHelper.createAlert(title: "Error", message: error.localizedDescription, in: viewController)
                        } else {
                            print("Address added successfully")
                            self.getAddress(viewController: viewController)
                            self.setDefaultAddressID(viewController: viewController, defaultAddressID: address.id!) {
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getAddress(viewController: UIViewController) {
        
        let account = firestoreDatabase.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        account.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
            } else if let documents = snapshot?.documents {
                if let userDocument = documents.first {
                    
                    let addressCollection = userDocument.reference.collection("Address")
                    
                    addressCollection.getDocuments { (snapshot, error) in
                        if error != nil {
                            AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                        } else if let addressDocuments = snapshot?.documents {
                            var addressList: [Address] = []
                            for addressDocument in addressDocuments {
                                do {
                                    if let address = try addressDocument.data(as: Address?.self) {
                                        addressList.append(address)
                                    }
                                } catch {
                                    AlertHelper.createAlert(title: "Error", message: error.localizedDescription, in: viewController)
                                }
                            }
                            self.addressList.onNext(addressList)
                        }
                    }
                }
            }
        }
    }
    
    func deleteAddress(viewController: UIViewController, addressID: String) {
        
        let account = firestoreDatabase.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        account.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
            } else if let documents = snapshot?.documents {
                if let userDocument = documents.first {
                    
                    let addressCollection = userDocument.reference.collection("Address").whereField("id", isEqualTo: addressID)
                    
                    addressCollection.getDocuments { snapshot, error in
                        if error != nil {
                            AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                        } else if let addressDocuments = snapshot?.documents {
                            for document in addressDocuments {
                                document.reference.delete { error in
                                    if error != nil {
                                        AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                                    } else {
                                        AlertHelper.createAlert(title: "Success", message: "Address has been successfully removed.", in: viewController)
                                        self.getAddress(viewController: viewController)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func editAddress(viewController: UIViewController, addressID: String, updatedAddress: Address) {
        
        let account = firestoreDatabase.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        account.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
            } else if let documents = snapshot?.documents {
                if let userDocument = documents.first {
                    
                    let addressData = [
                        "addressTitle": updatedAddress.addressTitle ?? "",
                        "postalCode": updatedAddress.postalCode ?? "",
                        "city": updatedAddress.city ?? "",
                        "state": updatedAddress.state ?? "",
                        "street": updatedAddress.street ?? "",
                        "buildingNumber": updatedAddress.buildingNumber ?? "",
                        "doorNumber": updatedAddress.doorNumber ?? "",
                        "floorNumber": updatedAddress.floorNumber ?? "",
                        "telephoneNo": updatedAddress.telephoneNo ?? ""
                    ] as [String : Any]
                    
                    let addressCollection = userDocument.reference.collection("Address").whereField("id", isEqualTo: addressID)
                    
                    addressCollection.getDocuments { snapshot, error in
                        if error != nil {
                            AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                        } else if let addressDocuments = snapshot?.documents {
                            for document in addressDocuments {
                                document.reference.setData(addressData, merge: true) { error in
                                    if error != nil {
                                        AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                                    } else {
                                        print("Address updated successfully")
                                        self.getAddress(viewController: viewController)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setDefaultAddressID(viewController: UIViewController,defaultAddressID: String, completion: @escaping () -> Void) {
        
        let account = firestoreDatabase.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        account.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
            } else if let documents = snapshot?.documents {
                if let userDocument = documents.first {
                    
                    let defaultAddressData = [
                        "defaultAddressID": defaultAddressID
                    ] as [String : Any]
                    
                    userDocument.reference.setData(defaultAddressData, merge: true) { error in
                        if error != nil {
                            AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                        } else {
                            print("Default Address updated successfully")
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func getDefaultAddress(viewController: UIViewController, completion: @escaping (Address?) -> Void) {
        
        let account = firestoreDatabase.collection("Accounts").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
        
        account.getDocuments { snapshot, error in
            if error != nil {
                AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
            } else if let documents = snapshot?.documents {
                if let userDocument = documents.first {
                    
                    let addressCollection = userDocument.reference.collection("Address").whereField("id", isEqualTo: userDocument["defaultAddressID"] ?? "")
                    
                    addressCollection.getDocuments { (snapshot, error) in
                        if error != nil {
                            AlertHelper.createAlert(title: "Error", message: error!.localizedDescription, in: viewController)
                        } else if let addressDocument = snapshot?.documents {
                            var defaultAddress: Address? = nil
                            
                            do {
                                if let address = try addressDocument.first?.data(as: Address?.self) {
                                    defaultAddress = address
                                }
                            } catch {
                                AlertHelper.createAlert(title: "Error", message: error.localizedDescription, in: viewController)
                            }
                            completion(defaultAddress)
                        }
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }
}
 
