//
//  Cards.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 21.01.2024.
//

import Foundation

class Cards: Codable {
    
    var id: String?
    var title: String?
    var cardHolderName: String?
    var cardNumber: String?
    var expirationDate: String?
    var cvv: String?
    
    init() {
        
    }
    
    init(id: String?, title: String?, cardHolderName: String? , cardNumber: String?, expirationDate: String?, cvv: String?) {
        self.id = id
        self.title = title
        self.cardHolderName = cardHolderName
        self.cardNumber = cardNumber
        self.expirationDate = expirationDate
        self.cvv = cvv
    }
}
