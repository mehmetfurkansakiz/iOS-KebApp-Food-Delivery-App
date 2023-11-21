//
//  AlertHelper.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 18.11.2023.
//

import Foundation
import UIKit

class AlertHelper {
    static func createAlert(title: String, message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        viewController.present(alert, animated: true)
    }
}
