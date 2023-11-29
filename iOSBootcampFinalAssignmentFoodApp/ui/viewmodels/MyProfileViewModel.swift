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
    
    func getFoods(viewController: UIViewController) {
        userRepo.getUser(viewController: viewController)
    }
}
