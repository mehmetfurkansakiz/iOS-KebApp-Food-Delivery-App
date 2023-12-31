//
//  FoodDetailViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 10.10.2023.
//

import UIKit

class FoodDetailViewController: UIViewController {
    
    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var detailNavigationBar: UINavigationItem!
    
    var food: Foods?
    var cartFood = CartFoods()
    var cartFoodsList = [CartFoods]()
    let foodViewModel = FoodCartViewModel()
    let userViewModel = UserViewModel()
    var imageUrl: URL?
    var quantity: Int?
    var price: Int?
    var totalPrice: Int?
    var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userViewModel.getNickname { nickname in
            self.nickname = nickname
            print("nickname: \(nickname ?? "No nickname")")
            self.foodViewModel.getCart(nickname: nickname!)
            
            _ = self.foodViewModel.cartFoodsList.subscribe(onNext: { list in
                self.cartFoodsList = list
            })
        }
    }
    
    func updateQuantityLabel() {
        labelQuantity.text = String(quantity!)
    }
    
    func updateTotalPriceLabel() {
        totalPrice = quantity! * price!
        labelTotalPrice.text = "Total: \(totalPrice!) ₺"
    }
    
    @IBAction func buttonMinus(_ sender: Any) {
        if quantity! > 0 {
            quantity! -= 1
            updateQuantityLabel()
            updateTotalPriceLabel()
        }
    }
    
    @IBAction func buttonPlus(_ sender: Any) {
        quantity! += 1
        updateQuantityLabel()
        updateTotalPriceLabel()
    }
    
    @IBAction func buttonAddCart(_ sender: Any) {
        let existingQuantity = cartControl()
        let order_quantity = quantity! + existingQuantity
        
        cartFood.yemek_adi = food?.yemek_adi
        cartFood.yemek_resim_adi = food?.yemek_resim_adi
        cartFood.yemek_fiyat = String(totalPrice! + (existingQuantity * price!))
        cartFood.yemek_siparis_adet = String(order_quantity)
        cartFood.kullanici_adi = nickname
        
        foodViewModel.addCart(cartFood: cartFood)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func buttonLike(_ sender: Any) {
    }
}

extension FoodDetailViewController {
    func cartControl() -> Int {
        for cartFood in cartFoodsList {
            if cartFood.yemek_adi == food?.yemek_adi {
                print("Matched")
                let quantity = Int(cartFood.yemek_siparis_adet!)!
                foodViewModel.deleteCart(cart_food_id: Int(cartFood.sepet_yemek_id!)!, nickname: self.nickname!)
                return quantity
            }
        }
        return(0)
    }
    
    func appearance() {
        
        self.navigationItem.title = "\(food!.yemek_adi ?? "Meal") Detail"
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = UIColor(named: "mainColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "textColor1")!,.font: UIFont(name: "Anton-Regular", size: 24)!]
        navigationController?.navigationBar.barStyle = .black

        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        if let food = food, let imageUrl = imageUrl {
            quantity = 1
            price = 0
            totalPrice = 0
            
            labelFoodName.text = food.yemek_adi
            
            price = Int(food.yemek_fiyat!)!
            labelPrice.text = "\(price!) ₺"
            updateTotalPriceLabel()
            updateQuantityLabel()
            
            // Upload image with Kingfisher
            foodImageView.kf.setImage(with: imageUrl)
        }
    }
}
