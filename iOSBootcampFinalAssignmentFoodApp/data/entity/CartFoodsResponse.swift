//
//  CartFoodsResponse.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 15.10.2023.
//

import Foundation

class CartFoodsResponse: Codable {
    var sepet_yemekler: [CartFoods]?
    var success: Int?
}
