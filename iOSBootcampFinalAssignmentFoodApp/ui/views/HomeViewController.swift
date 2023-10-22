//
//  HomeViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 8.10.2023.
//

import UIKit
import Kingfisher
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeNavigationBar: UINavigationItem!
    
    var foodsList = [Foods]()
    var viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self // searchBar delegate
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        // Custom Navigation
        let navigationLocationView = viewModel.configureNavLocation(title: "Erenler, Sakarya", imageName: "location")
        homeNavigationBar.leftBarButtonItem = UIBarButtonItem(customView: navigationLocationView)
        
        let navigationTitleView = viewModel.configureNavTitle(title: "KebApp")
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
        _ = viewModel.foodsList.subscribe(onNext: { list in
            self.foodsList = list
            DispatchQueue.main.async {
                self.homeCollectionView.reloadData()
            }
        })
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let food = sender as? Foods {
                let destinationVC = segue.destination as! FoodDetailViewController
                destinationVC.food = food
                destinationVC.imageUrl = viewModel.getFoodImageUrl(imageName: food.yemek_resim_adi!)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getFoods(searchText: "")
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.getFoods(searchText: searchText)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! HomeCollectionViewCell
        
        let food = foodsList[indexPath.row]
        
        cell.labelFoodName.text = food.yemek_adi
        cell.labelPrice.text = String(food.yemek_fiyat! + "₺")
        
        if let imageUrl = viewModel.getFoodImageUrl(imageName: food.yemek_resim_adi!) {
            cell.foodImageView.kf.setImage(with: imageUrl)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let food = foodsList[indexPath.row]
        
        performSegue(withIdentifier: "toDetailVC", sender: food)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

