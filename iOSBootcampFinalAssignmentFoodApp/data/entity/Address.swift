//
//  Address.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 7.01.2024.
//

import Foundation

class Address: Codable {
    
    var id: String?
    var addressTitle: String?
    var postalCode: String?
    var city: String?
    var state: String?
    var street: String?
    var buildingNumber: String?
    var floorNumber: String?
    var doorNumber: String?
    var telephoneNo: String?
    
    init(){
        
    }
    
    init(id: String?, addressTitle: String?, postalCode: String?, city: String?, state: String?, street: String?, buildingNumber: String?, floorNumber: String?, doorNumber: String?, telephoneNo: String?) {
        self.id = id
        self.addressTitle = addressTitle
        self.postalCode = postalCode
        self.city = city
        self.state = state
        self.street = street
        self.buildingNumber = buildingNumber
        self.floorNumber = floorNumber
        self.doorNumber = doorNumber
        self.telephoneNo = telephoneNo
    }
}
