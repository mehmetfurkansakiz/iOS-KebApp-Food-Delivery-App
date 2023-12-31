//
//  LikesViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 7.12.2023.
//

import UIKit
import RxSwift
import Kingfisher
import SkeletonView

class LikesViewController: UIViewController {
    
    @IBOutlet weak var likesTableView: UITableView!
    @IBOutlet weak var labelNoLiked: UILabel!
    
    let likesViewModel = LikesViewModel()
    var likedFoodList = [Foods]()
    let foodCartViewModel = FoodCartViewModel()
    var cartFoodsList = [CartFoods]()
    var cartFood = CartFoods()
    let userViewModel = UserViewModel()
    var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likesTableView.dataSource = self
        likesTableView.delegate = self
        
        _ = likesViewModel.likeRepo.likedFoodList.subscribe(onNext: { list in
            self.likedFoodList = list
            DispatchQueue.main.async {
                self.likesTableView.reloadData()
                self.checkLikes()
                
            }
        })
        userViewModel.getNickname { nickname in
            self.nickname = nickname
            self.foodCartViewModel.getCart(nickname: nickname!)
            
            _ = self.foodCartViewModel.cartFoodsList.subscribe(onNext: { list in
                self.cartFoodsList = list
                self.likesTableView.stopSkeletonAnimation()
                self.view.hideSkeleton()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        likesTableView.isSkeletonable = true
        likesTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver),
                                                        animation: nil,
                                                        transition: .crossDissolve(0.25))
        likesViewModel.getLikes(viewController: self)
        if let nickname = self.nickname {
            self.foodCartViewModel.getCart(nickname: nickname)
        }
    }
    
    func checkLikes() {
        if likedFoodList.isEmpty == true {
            
            labelNoLiked.isHidden = false
            likesTableView.isHidden = true
        } else {
            
            labelNoLiked.isHidden = true
            likesTableView.isHidden = false
        }
    }
}

extension LikesViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    //MARK: - SkeletonView
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "likesCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedFoodList.count
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedFoodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "likesCell", for: indexPath) as! LikesTableViewCell
        
        let likedFood = likedFoodList[indexPath.row]
        
        cell.buttonLike.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        cell.buttonLike.tag = indexPath.row
        
        cell.buttonAdd.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        cell.buttonAdd.tag = indexPath.row
        
        cell.labelFoodName.text = likedFood.yemek_adi
        cell.labelFoodPrice.text = String(likedFood.yemek_fiyat! + "₺")
        
        if let imageUrl = likesViewModel.getFoodImageUrl(imageName: likedFood.yemek_resim_adi!) {
            cell.foodImageView.kf.setImage(with: imageUrl)
        }
        
        return cell
    }
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        likesViewModel.undoLike(viewController: self, food: likedFoodList[sender.tag])

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.likesViewModel.getLikes(viewController: self)
        }
        
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let selectedLike = likedFoodList[sender.tag]
        let existingQuantity = cartControl(selectedFood: selectedLike)
        let order_quantity = existingQuantity + 1
        let cartFood = CartFoods()
        
        cartFood.yemek_adi = selectedLike.yemek_adi
        cartFood.yemek_fiyat = String(Int(selectedLike.yemek_fiyat!)! * order_quantity)
        cartFood.yemek_resim_adi = selectedLike.yemek_resim_adi
        cartFood.yemek_siparis_adet = String(order_quantity)
        cartFood.kullanici_adi = nickname
        
        AlertHelper.createAlert(title: "Success", message: "\(cartFood.yemek_adi!) successfully added to cart", in: self)
        foodCartViewModel.addCart(cartFood: cartFood)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.foodCartViewModel.getCart(nickname: self.nickname!)
        }
        
    }
    
    func cartControl(selectedFood: Foods) -> Int {
        for cartFood in cartFoodsList {
            if cartFood.yemek_adi == selectedFood.yemek_adi {
                
                let quantity = Int(cartFood.yemek_siparis_adet!)!
                foodCartViewModel.deleteCart(cart_food_id: Int(cartFood.sepet_yemek_id!)!, nickname: self.nickname!)
                return quantity
            }
        }
        return(0)
    }
    
}
