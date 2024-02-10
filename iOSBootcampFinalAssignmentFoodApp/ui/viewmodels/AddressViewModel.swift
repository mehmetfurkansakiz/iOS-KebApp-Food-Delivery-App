//
//  AddressViewModel.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 10.01.2024.
//

import Foundation
import RxSwift
import UIKit

class AddressViewModel {
    let addressRepo = AddressDaoRepository()
    var addressList = BehaviorSubject<[Address]>(value: [Address]())
    
    init() {
        addressList = addressRepo.addressList
    }
    
    func addAddress(viewController: UIViewController, address: Address) {
        addressRepo.addAddress(viewController: viewController, address: address)
    }
    
    func getAddress(viewController: UIViewController) {
        addressRepo.getAddress(viewController: viewController)
    }
    
    func deleteAddress(viewController: UIViewController, addressID: String) {
        addressRepo.deleteAddress(viewController: viewController, addressID: addressID)
    }
    
    func editAddress(viewController: UIViewController, addressID: String, updatedAddress: Address) {
        addressRepo.editAddress(viewController: viewController, addressID: addressID, updatedAddress: updatedAddress)
    }
    
    func setDefaultAddress(viewController: UIViewController, defaultAddressID: String, completion: @escaping () -> Void) {
        addressRepo.setDefaultAddressID(viewController: viewController, defaultAddressID: defaultAddressID, completion: completion)
    }
    
    func getDefaultAddress(viewController: UIViewController, completion: @escaping (Address?) -> Void) {
        addressRepo.getDefaultAddress(viewController: viewController, completion: completion)
    }
}
