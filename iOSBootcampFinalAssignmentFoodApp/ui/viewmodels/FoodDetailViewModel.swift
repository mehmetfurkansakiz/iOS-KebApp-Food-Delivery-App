//
//  FoodDetailViewModel.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 12.10.2023.
//

import Foundation
import RxSwift

class FoodDetailViewModel {
    
    var foodRepo = FoodsDaoRepository()
    
    func addCart(food_name: String, food_image_name: String, food_price: Int, order_quantity: Int, nickname: String) {
        foodRepo.addCart(food_name: food_name, food_image_name: food_image_name, food_price: food_price, order_quantity: order_quantity, nickname: nickname)
    }
    
    func getMergedCart(nickname: String) {
        foodRepo.getMergedCart(nickname: nickname)
    }
    
}
