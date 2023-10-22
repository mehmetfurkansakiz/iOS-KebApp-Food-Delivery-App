//
//  FoodsDaoRepository.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 9.10.2023.
//

import Foundation
import RxSwift
import Alamofire

class FoodsDaoRepository {
    var foodsList = BehaviorSubject<[Foods]>(value: [Foods]())
    var cartFoodsList = BehaviorSubject<[CartFoods]>(value: [CartFoods]())
    var cartFoods: [CartFoods]?
    
    func getFoods(searchText: String?) {
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do {
                    let res = try JSONDecoder().decode(FoodsResponse.self, from: data)
                    if var list = res.yemekler {
                        if let searchText = searchText, !searchText.isEmpty {
                            list = list.filter { food in
                                return food.yemek_adi!.localizedCaseInsensitiveContains(searchText)
                            }
                        }
                        self.foodsList.onNext(list)
                    }
//                    print("------RAW RESPONSE------")
//                    let rawResponse = try JSONSerialization.jsonObject(with: data)
//                    print(rawResponse)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func addCart(food_name: String, food_image_name: String, food_price: Int, order_quantity: Int, nickname: String) {
        let params: Parameters = ["yemek_adi":food_name, "yemek_resim_adi":food_image_name, "yemek_fiyat":food_price, "yemek_siparis_adet":order_quantity, "kullanici_adi":nickname]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let res = try JSONDecoder().decode(CRUDresponse.self, from: data)
                    print("---------ADD-CART---------")
                    print("Success: \(res.success!)")
                    print("Message: \(res.message!)")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func resCart(nickname: String) {
        let params: Parameters = ["kullanici_adi":nickname]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let res = try JSONDecoder().decode(CartFoodsResponse.self, from: data)
                    print("---------RES-CART---------")
                    print("Success: \(res.success!)")
                    if let list = res.sepet_yemekler {
                        self.cartFoodsList.onNext(list)
                    }
                } catch {
                    print(error.localizedDescription)
                    self.cartFoodsList.onNext([])
                }
            }
            
        }
    }
    
    func getMergedCart(nickname: String) {
        let params: Parameters = ["kullanici_adi":nickname]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let res = try JSONDecoder().decode(CartFoodsResponse.self, from: data)
                    print("---------GET-MERGED-CART---------")
                    print("Success: \(res.success!)")
                    if let list = res.sepet_yemekler {
                        var mergedList = self.mergeCartFoods(list)
                        self.cartFoodsList.onNext(mergedList)
                        mergedList.removeAll() //mergedList clean
                    }
//                    print("------RAW RESPONSE------")
//                    let rawResponse = try JSONSerialization.jsonObject(with: data)
//                    print(rawResponse)
                } catch {
                    print(error.localizedDescription)
                    self.cartFoodsList.onNext([])
                }
            }
        }
    }
    
    func deleteCart(cart_food_id: Int, nickname: String) {
        let params: Parameters = ["sepet_yemek_id":cart_food_id, "kullanici_adi":nickname]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let res = try JSONDecoder().decode(CRUDresponse.self, from: data)
                    print("---------DELETE-CART---------")
                    print("Success: \(res.success!)")
                    print("Message: \(res.message!)")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getFoodImageUrl(imageName: String) -> URL? {
        return URL(string: ("http://kasimadalan.pe.hu/yemekler/resimler/" + imageName))
    }
    
    func mergeCartFoods(_ cartFoods: [CartFoods]) -> [CartFoods] {
        var mergedList: [CartFoods] = []
        
        for food in cartFoods {
            if let existingFood = mergedList.first(where: { $0.yemek_adi == food.yemek_adi }) {
                let newQuantity = Int(existingFood.yemek_siparis_adet!)! + Int(food.yemek_siparis_adet!)!
                let newPrice = Int(existingFood.yemek_fiyat!)! + Int(food.yemek_fiyat!)!
                
                DispatchQueue.global().async {
                    self.deleteCart(cart_food_id: Int(existingFood.sepet_yemek_id!)!, nickname: existingFood.kullanici_adi!)
                    self.deleteCart(cart_food_id: Int(food.sepet_yemek_id!)!, nickname: food.kullanici_adi!)
                    
                    DispatchQueue.main.async {
                        self.addCart(food_name: food.yemek_adi!, food_image_name: food.yemek_resim_adi!, food_price: newPrice, order_quantity: newQuantity, nickname: food.kullanici_adi!)
                    }
                }
            } else {
                mergedList.append(food)
            }
        }
        
        return mergedList
    }
}
