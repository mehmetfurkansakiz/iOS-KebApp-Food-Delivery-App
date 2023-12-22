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
    
    func addCart(cartFood: CartFoods) {
        foodRepo.addCart(cartFood: cartFood)
    }
    
    func deleteCart(cart_food_id: Int, nickname: String) {
        foodRepo.deleteCart(cart_food_id: cart_food_id, nickname: nickname)
    }
    
    func getCart(nickname: String) {
        foodRepo.getCart(nickname: nickname)
    }
    
    func getFoodImageUrl(imageName: String) -> URL? {
        return foodRepo.getFoodImageUrl(imageName: imageName)
    }
    
}
