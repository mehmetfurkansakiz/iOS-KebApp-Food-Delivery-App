//
//  FoodCartViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 14.10.2023.
//

import UIKit
import RxSwift

class FoodCartViewController: UIViewController {
    
    @IBOutlet weak var cartCollectionView: UICollectionView!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var labelDiscount: UILabel!
    
    var cartFoodsList = [CartFoods]()
    var foodViewModel = FoodCartViewModel()
    let userViewModel = MyProfileViewModel()
    var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartCollectionView.delegate = self
        cartCollectionView.dataSource = self
        
        let collectionDesign = UICollectionViewFlowLayout()
        collectionDesign.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionDesign.minimumLineSpacing = 10
        collectionDesign.minimumInteritemSpacing = 10
        
        //10 [item] 10
        let deviceWidth = UIScreen.main.bounds.width
        let itemWidth = deviceWidth - 20
        
        collectionDesign.itemSize = CGSize(width: itemWidth, height: itemWidth*0.4)
        
        cartCollectionView.collectionViewLayout = collectionDesign
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userViewModel.getNickname { nickname in
            self.nickname = nickname
            print("nickname: \(nickname ?? "No nickname")")
            self.loadCartData()
        }
    }
    
    @IBAction func buttonDelete(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? FoodCartCollectionViewCell else {
            return
        }
        
        if let indexPath = cartCollectionView.indexPath(for: cell) {
            let cartFood = cartFoodsList[indexPath.row]
            if let sepetYemekID = Int(cartFood.sepet_yemek_id!) {
                foodViewModel.deleteCart(cart_food_id: sepetYemekID, nickname: nickname!)
                foodViewModel.getCart(nickname: nickname!)
            }
        }
        self.cartCollectionView.reloadData()
    }
    
    func calculateDiscountedTotalPrice() {
        var totalCartPrice = 0
        
        for cart in cartFoodsList {
            if let foodPrice = Int(cart.yemek_fiyat!) {
                totalCartPrice += foodPrice
            }
        }
        
        let discountAmount = Double(totalCartPrice) * 0.25
        let discountedPrice = Double(totalCartPrice) - discountAmount
        
        labelDiscount.text = String(format: "- %.2f ₺", discountAmount)
        labelTotalPrice.text = String(format: "%.2f ₺", discountedPrice)
        self.cartCollectionView.reloadData()
    }
    
    func loadCartData() {
        _ = foodViewModel.cartFoodsList.subscribe(onNext: { list in
            self.cartFoodsList = list
            DispatchQueue.main.async {
                self.calculateDiscountedTotalPrice()
                self.cartCollectionView.reloadData()
            }
        })
        
        self.foodViewModel.getCart(nickname: self.nickname!)
        self.cartCollectionView.reloadData()
    }
}

extension FoodCartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartFoodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartCell", for: indexPath) as! FoodCartCollectionViewCell
        
        let cart = cartFoodsList[indexPath.row]
        
        cell.labelFoodName.text = cart.yemek_adi
        cell.labelTotalPrice.text = "Total: \(cart.yemek_fiyat!) ₺"
        cell.labelQuantity.text = "Quantity: \(cart.yemek_siparis_adet!)"
        
        if let quantity = Int(cart.yemek_siparis_adet!), let foodPrice = Int(cart.yemek_fiyat!) {
            let perPrice = foodPrice / quantity
            cell.labelPrice.text = "Per Price: \(perPrice) ₺"
        }
        
        if let imageUrl = foodViewModel.getFoodImageUrl(imageName: cart.yemek_resim_adi!) {
            cell.cartImageView.kf.setImage(with: imageUrl)
        }
        
        return cell
    }
}
