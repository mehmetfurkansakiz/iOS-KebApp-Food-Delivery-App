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
    
    init(){
        
    }
    
    init(name: String, surname: String, age: Int, nickname: String, email: String, avatarImage: String, registrationDate: Date) {
        self.name = name
        self.surname = surname
        self.age = age
        self.nickname = nickname
        self.email = email
        self.avatarImage = avatarImage
        self.registrationDate = registrationDate
    }
}
