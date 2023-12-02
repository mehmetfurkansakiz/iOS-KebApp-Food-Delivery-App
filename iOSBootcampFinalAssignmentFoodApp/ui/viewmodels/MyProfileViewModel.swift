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
    
    func getUser(viewController: UIViewController) {
        userRepo.getUser(viewController: viewController)
    }
    
    func getNickname(completion: @escaping (String?) -> Void) {
            return userRepo.getNickname(completion: completion)
    }
}
