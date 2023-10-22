//
//  HomeModelView.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 9.10.2023.
//

import Foundation
import RxSwift
import UIKit

class HomeViewModel {
    
    var foodRepo = FoodsDaoRepository()
    var foodsList = BehaviorSubject<[Foods]>(value: [Foods]())
    
    init() {
        foodsList = foodRepo.foodsList
    }
    
    func getFoods(searchText: String) {
        foodRepo.getFoods(searchText: searchText)
    }
    
    func getFoodImageUrl(imageName: String) -> URL? {
        return foodRepo.getFoodImageUrl(imageName: imageName)
    }
    
    func configureNavLocation(title: String, imageName: String) -> UIView {
        
        let titleView = UIView()
        
        let label = UILabel()
        label.text = title
        label.textColor = UIColor(named: "textColor1")
        label.font = UIFont(name: "Anton-Regular", size: 16)
        label.sizeToFit()
        
        let image = UIImageView()
        image.image = UIImage(named: imageName)
        if let originalImage = UIImage(named: imageName) {
            let tintedImage = originalImage.withRenderingMode(.alwaysTemplate)
            image.image = tintedImage
            image.tintColor = UIColor(named: "textColor1")
        }
        
        let imageAspect = image.image!.size.width / image.image!.size.height
        
        let imageWidth = label.frame.size.height * imageAspect
        let imageHeight = label.frame.size.height
        
        
          let labelX = image.frame.origin.x + image.frame.size.width + 20

          label.frame = CGRect(x: labelX, y: -8, width: label.frame.size.width, height: label.frame.size.height)
        
        image.frame = CGRect(x: -8, y: -8, width: imageWidth, height: imageHeight)
        
        titleView.addSubview(label)
        titleView.addSubview(image)
        
        titleView.sizeToFit()
        
        return titleView
    }
    
    func configureNavTitle(title: String) -> UIView {
        
        let titleView = UIView()
        
        let label = UILabel()
        label.text = title
        label.textColor = UIColor(named: "textColor1")
        label.font = UIFont(name: "Anton-Regular", size: 24)
        label.sizeToFit()
        
        let labelX = label.frame.origin.x + label.frame.size.width + 8

          label.frame = CGRect(x: -labelX, y: -16, width: label.frame.size.width, height: label.frame.size.height)
        
        titleView.addSubview(label)
        titleView.sizeToFit()
        return titleView
    }
}
