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
    
    func addCart(food_name: String, food_image_name: String, food_price: Int, order_quantity: Int, nickname: String) {
        foodRepo.addCart(food_name: food_name, food_image_name: food_image_name, food_price: food_price, order_quantity: order_quantity, nickname: nickname)
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
