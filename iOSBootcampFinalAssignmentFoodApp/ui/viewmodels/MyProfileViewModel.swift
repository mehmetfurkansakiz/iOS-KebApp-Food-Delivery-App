//
//  MyProfileViewModel.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 26.11.2023.
//

import Foundation
import RxSwift
import UIKit

class MyProfileViewModel {
    
    var userRepo = UsersDaoRepository()
    var user = BehaviorSubject<User>(value: User())
    
    init() {
        user = userRepo.user
    }
    
    func registerUser(viewController: UIViewController, data: UIImage?, name: String, surname: String, nickname: String, age: Int) {
        userRepo.registerUser(viewController: viewController, data: data, name: name, surname: surname, nickname: nickname, age: age)
    }
    
    func getUser(viewController: UIViewController) {
        userRepo.getUser(viewController: viewController)
    }
    
    func getNickname(completion: @escaping (String?) -> Void) {
        return userRepo.getNickname(completion: completion)
    }
    
    func getRegistrationStatus(completion: @escaping (Bool) -> Void) {
        return userRepo.getRegistrationStatus(completion: completion)
    }
    
    func sendPasswordReset(email: String, viewController: UIViewController) {
        userRepo.sendPasswordReset(email: email, viewController: viewController)
    }
}
