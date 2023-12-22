//
//  LikesViewModel.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 7.12.2023.
//

import Foundation
import RxSwift
import UIKit

class LikesViewModel {
    var likeRepo = LikesDaoRepository()
    var likedFoodList = BehaviorSubject<[Foods]>(value:[Foods]())
    
    init() {
        likedFoodList = likeRepo.likedFoodList
    }
    
    func setlike(viewController: UIViewController, food: Foods){
        likeRepo.setLike(viewController: viewController, food: food)
    }
    
    func undoLike(viewController: UIViewController, food: Foods ){
        likeRepo.undoLike(viewController: viewController, food: food)
    }
    
    func getLikes(viewController: UIViewController) {
        likeRepo.getLikes(viewController: viewController)
    }
    
    func getFoodImageUrl(imageName: String) -> URL? {
        return likeRepo.getFoodImageUrl(imageName: imageName)
    }
}
