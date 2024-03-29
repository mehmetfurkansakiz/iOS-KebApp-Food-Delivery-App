//
//  User.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 23.11.2023.
//

import Foundation

class User {
    
    var name: String?
    var surname: String?
    var age: Int?
    var nickname: String?
    var email: String?
    var avatarImage: String?
    var registrationDate: Date?
    var likes: [Foods]?
    var address: [Address]?
    var defaultAddressID: String?
    var cards: [Cards]?
    var defaultCardID: String?
    
    init(){
        
    }
    
    init(name: String, surname: String, age: Int, nickname: String, email: String, avatarImage: String, registrationDate: Date, likes: [Foods], address: [Address], defaultAddressID: String, cards: [Cards], defaultCardID: String) {
        self.name = name
        self.surname = surname
        self.age = age
        self.nickname = nickname
        self.email = email
        self.avatarImage = avatarImage
        self.registrationDate = registrationDate
        self.likes = likes
        self.address = address
        self.defaultAddressID = defaultAddressID
        self.cards = cards
        self.defaultCardID = defaultCardID
        
    }
}
