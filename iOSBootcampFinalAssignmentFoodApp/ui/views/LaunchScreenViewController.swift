//
//  LaunchScreenViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 30.12.2023.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet weak var imageViewLaunch: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchGif = UIImage.gifImageWithName("loadingKebabGif")
        imageViewLaunch.image = launchGif
    }
}
