//
//  PaymentViewModel.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 21.01.2024.
//

import Foundation
import RxSwift
import UIKit

class PaymentViewModel {
    let paymentRepo = PaymentDaoRepository()
    var cardList = BehaviorSubject<[Cards]>(value: [Cards]())
    
    init() {
        cardList = paymentRepo.cardList
    }
    
    func addCard(viewController: UIViewController, card: Cards) {
        paymentRepo.addCard(viewController: viewController, card: card)
    }
    
    func getCards(viewController: UIViewController) {
        paymentRepo.getCards(viewController: viewController)
    }
    
    func editCard(viewController: UIViewController, cardID: String, updatedCard: Cards) {
        paymentRepo.editCard(viewController: viewController, cardID: cardID, updatedCard: updatedCard)
    }
    
    func deleteCard(viewController: UIViewController, cardID: String) {
        paymentRepo.deleteCard(viewController: viewController, cardID: cardID)
    }
}
