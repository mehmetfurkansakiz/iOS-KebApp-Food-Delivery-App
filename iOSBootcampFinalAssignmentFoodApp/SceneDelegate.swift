//
//  SceneDelegate.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 8.10.2023.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        let currentUser = Auth.auth().currentUser
        let userViewModel = MyProfileViewModel()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if let email = currentUser?.email {
                print("currentUser = \(email)")
                userViewModel.getRegistrationStatus { isRegistered in
                    if isRegistered {
                        //If the user is logged in and has already completed the registration, redirect to the home page
                        let board = UIStoryboard(name: "Main", bundle: nil)
                        let homeTabBar = board.instantiateViewController(withIdentifier: "homeTabBar") as! UITabBarController
                        self.window?.rootViewController = homeTabBar
                    } else {
                        //If the user is logged in but has not yet completed the registration, redirect to the registration completion page
                        let board = UIStoryboard(name: "Main", bundle: nil)
                        let registrationVC = board.instantiateViewController(withIdentifier: "registrationComplete") as! RegisterCompleteViewController
                        self.window?.rootViewController = registrationVC
                    }
                }
            } else {
                let board = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = board.instantiateViewController(withIdentifier: "loginPage") as! LoginViewController
                self.window?.rootViewController = loginVC

            }
            guard let _ = (scene as? UIWindowScene) else { return }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

