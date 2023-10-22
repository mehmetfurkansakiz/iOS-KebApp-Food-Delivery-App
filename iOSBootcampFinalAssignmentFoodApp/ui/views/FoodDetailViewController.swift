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
    var imageUrl: URL?
    var viewModel = FoodDetailViewModel()
    var quantity: Int?
    var price: Int?
    var totalPrice: Int?
    var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(food!.yemek_adi ?? "Meal") Detail"
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = UIColor(named: "mainColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "textColor1")!,.font: UIFont(name: "Anton-Regular", size: 24)!]
        navigationController?.navigationBar.barStyle = .black

        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        if let food = food, let imageUrl = imageUrl {
            nickname = "furkan_sakiz"
            quantity = 0
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
        guard let foodName = food?.yemek_adi, let imageName = food?.yemek_resim_adi else {
            return
        }
        viewModel.addCart(food_name: foodName, food_image_name: imageName, food_price: totalPrice!, order_quantity: quantity!, nickname: nickname!)
        navigationController?.popToRootViewController(animated: true)
        viewModel.getMergedCart(nickname: nickname!)
    }
    
    @IBAction func buttonLike(_ sender: Any) {
    }
}
