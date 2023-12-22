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
    
    func addCart(cartFood: CartFoods) {
        let params: Parameters = ["yemek_adi":cartFood.yemek_adi!,
                                  "yemek_resim_adi":cartFood.yemek_resim_adi!,
                                  "yemek_fiyat":cartFood.yemek_fiyat!,
                                  "yemek_siparis_adet":cartFood.yemek_siparis_adet!,
                                  "kullanici_adi":cartFood.kullanici_adi!]
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
    
    func getCart(nickname: String) {
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
}
