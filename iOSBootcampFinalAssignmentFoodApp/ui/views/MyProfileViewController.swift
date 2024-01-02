//
//  MyAccountViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 18.11.2023.
//

import UIKit
import FirebaseAuth
import RxSwift
import Kingfisher
import SkeletonView

class MyProfileViewController: UIViewController {

    @IBOutlet weak var profileBackgroundImage: UIImageView!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelNickname: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSurname: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    
    let viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearance()
        
        // RxSwift
        _ = viewModel.userRepo.user.subscribe(onNext: { user in
            if let name = user.name {
                self.labelName.text = name
            }
            if let surname = user.surname {
                self.labelSurname.text = surname
            }
            if let age = user.age {
                self.labelAge.text = String(age)
            }
            if let nickname = user.nickname {
                self.labelNickname.text = nickname
            }
            if let email = user.email {
                self.labelEmail.text = email
            }
            if let avatarImage = user.avatarImage {
                if let avatarUrl = URL(string: avatarImage) {
                    DispatchQueue.main.async {
                        self.profilePicImage.kf.setImage(with: avatarUrl)
                        self.view.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                    }
                }
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let gradient = SkeletonGradient(baseColor: .silver)
        view.showAnimatedGradientSkeleton(usingGradient: gradient, animation: nil, transition: .crossDissolve(0.25))
        viewModel.userRepo.getUser(viewController: self)
    }
    
    func appearance(){
        profileBackgroundImage.image = UIImage(named: "foodBackground")
        profilePicImage.layer.cornerRadius = 80
        profilePicImage.layer.borderWidth = 1
        profilePicImage.layer.borderColor = UIColor.black.cgColor
    }

    @IBAction func buttonQuit(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "profileToLogin", sender: nil)
        } catch {
            AlertHelper.createAlert(title: "Error", message: error.localizedDescription, in: self)
        }
    }
}
