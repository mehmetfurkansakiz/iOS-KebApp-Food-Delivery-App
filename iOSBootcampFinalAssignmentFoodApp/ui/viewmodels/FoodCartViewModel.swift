//
//  FoodCartViewModel.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 14.10.2023.
//

import Foundation
import RxSwift

class FoodCartViewModel {
    
    var foodRepo = FoodsDaoRepository()
    var cartFoodsList = BehaviorSubject<[CartFoods]>(value: [CartFoods]())
    
    init() {
        cartFoodsList = foodRepo.cartFoodsList
    }
    
    func getMergedCart(nickname: String) {
        foodRepo.getMergedCart(nickname: nickname)
    }
    
    func deleteCart(cart_food_id: Int, nickname: String) {
        foodRepo.deleteCart(cart_food_id: cart_food_id, nickname: nickname)
    }
    
    func resCart(nickname: String) {
        foodRepo.resCart(nickname: nickname)
    }
    
    func getFoodImageUrl(imageName: String) -> URL? {
        return foodRepo.getFoodImageUrl(imageName: imageName)
    }
    
}
