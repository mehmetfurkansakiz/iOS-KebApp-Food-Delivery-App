//
//  HomeViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 8.10.2023.
//

import UIKit
import Kingfisher
import RxSwift
import SkeletonView

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeNavigationBar: UINavigationItem!
    
    let foodViewModel = HomeViewModel()
    var foodsList = [Foods]()
    let likesViewModel = LikesViewModel()
    var likedFoodList = [Foods]()
    let userViewModel = UserViewModel()
    var cartFoodsList = [CartFoods]()
    let foodCartViewModel = FoodCartViewModel()
    let addressViewModel = AddressViewModel()
    var defaultAddress: Address?
    var nickname: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self // searchBar delegate
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        // Custom Navigation Bar Title Logo
        
        let navigationTitleView = foodViewModel.configureNavTitle(title: "KebApp")
        homeNavigationBar.rightBarButtonItem = UIBarButtonItem(customView: navigationTitleView)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "mainColor")
        navigationController?.navigationBar.barStyle = .black

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Cell Design
        let collectionDesign = UICollectionViewFlowLayout()
        collectionDesign.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionDesign.minimumLineSpacing = 10
        collectionDesign.minimumInteritemSpacing = 10

        //10 [item] 10 [item] 10
        let deviceWidth = UIScreen.main.bounds.width
        let itemWidth = (deviceWidth - 30) / 2

        collectionDesign.itemSize = CGSize(width: itemWidth, height: itemWidth*1.2)

        homeCollectionView.collectionViewLayout = collectionDesign
        
        // RxSwift
        _ = foodViewModel.foodsList.subscribe(onNext: { list in
            self.foodsList = list
            DispatchQueue.main.async {
                self.homeCollectionView.reloadData()
            }
        })
        _ = likesViewModel.likedFoodList.subscribe(onNext: { list in
            self.likedFoodList = list
            DispatchQueue.main.async {
                self.homeCollectionView.reloadData()
            }
        })
        userViewModel.getNickname { nickname in
            self.nickname = nickname
            print("nickname: \(nickname ?? "No nickname")")
            self.foodCartViewModel.getCart(nickname: self.nickname!)
            
            _ = self.foodCartViewModel.foodRepo.cartFoodsList.subscribe(onNext: { list in
                self.cartFoodsList = list
                self.homeCollectionView.stopSkeletonAnimation()
                self.view.hideSkeleton()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeCollectionView.isSkeletonable = true
        homeCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver),
                                                        animation: nil,
                                                        transition: .crossDissolve(0.25))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.likesViewModel.getLikes(viewController: self)
        }
        foodViewModel.getFoods(searchText: "")
        likesViewModel.getLikes(viewController: self)
        if let nickname = self.nickname {
            self.foodCartViewModel.getCart(nickname: nickname)
        }
        addressViewModel.getDefaultAddress(viewController: self) { address in
            self.defaultAddress = address
            if self.defaultAddress != nil {
                let navigationLocationView = self.foodViewModel.configureNavLocation(title: "\(self.defaultAddress?.state! ?? "") / \(self.defaultAddress?.city! ?? "")", imageName: "location")
                self.homeNavigationBar.leftBarButtonItem = UIBarButtonItem(customView: navigationLocationView)
            } else {
                let navigationLocationView = self.foodViewModel.configureNavLocation(title: "Add an address!", imageName: "location")
                self.homeNavigationBar.leftBarButtonItem = UIBarButtonItem(customView: navigationLocationView)
            }
        }
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let food = sender as? Foods {
                let destinationVC = segue.destination as! FoodDetailViewController
                destinationVC.food = food
                destinationVC.imageUrl = foodViewModel.getFoodImageUrl(imageName: food.yemek_resim_adi!)
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        foodViewModel.getFoods(searchText: searchText)
    }
}

extension HomeViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
    
    //MARK: - SkeletonView
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "foodCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodsList.count
    }
    
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! HomeCollectionViewCell
        
        var isLiked = false
        let food = foodsList[indexPath.row]
        
        cell.buttonLike.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        cell.buttonLike.tag = indexPath.row
        
        cell.buttonAdd.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        cell.buttonAdd.tag = indexPath.row
        
        cell.labelFoodName.text = food.yemek_adi
        cell.labelPrice.text = String(food.yemek_fiyat! + "₺")
        
        if let imageUrl = foodViewModel.getFoodImageUrl(imageName: food.yemek_resim_adi!) {
            cell.foodImageView.kf.setImage(with: imageUrl)
        }
        
        for food in likedFoodList {
            if (food.yemek_id == foodsList[indexPath.row].yemek_id) {
                isLiked = true
            }
        }
        cell.configureLikeButton(isLiked: isLiked)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let food = foodsList[indexPath.row]
        
        performSegue(withIdentifier: "toDetailVC", sender: food)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    //MARK: - Buttons
    @objc func likeButtonTapped(_ sender: UIButton) {
        var isLiked = false
        for i in likedFoodList {
            if (i.yemek_id == foodsList[sender.tag].yemek_id) {
                isLiked = true
            }
        }
        if isLiked == true {
            likesViewModel.undoLike(viewController: self, food: foodsList[sender.tag])
        } else {
            likesViewModel.setlike(viewController: self, food: foodsList[sender.tag])
        }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.likesViewModel.getLikes(viewController: self)
            }
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        print("add button tapped in home")
        let selectedFood = foodsList[sender.tag]
        let existingQuantity = cartControl(selectedFood: selectedFood)
        let order_quantity = existingQuantity + 1
        let cartFood = CartFoods()
        
        cartFood.yemek_adi = selectedFood.yemek_adi
        cartFood.yemek_fiyat = String(Int(selectedFood.yemek_fiyat!)! * order_quantity)
        cartFood.yemek_resim_adi = selectedFood.yemek_resim_adi
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

