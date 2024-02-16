//
//  PaymentMethodsViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 20.01.2024.
//

import UIKit

class PaymentMethodsViewController: UIViewController {

    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var labelNoSaved: UILabel!
    
    let paymentViewModel = PaymentViewModel()
    var cardList = [Cards]()
    var defaultCard: Cards?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        
        _ = paymentViewModel.cardList.subscribe(onNext: { list in
            self.cardList = list
            DispatchQueue.main.async {
                self.paymentTableView.reloadData()
                self.checkCards()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        paymentViewModel.getCards(viewController: self)
        paymentViewModel.getDefaultCard(viewController: self) { card in
            self.defaultCard = card
            self.paymentTableView.reloadData()
        }
    }
    
    func checkCards() {
        if cardList.isEmpty == true {
            defaultCard = nil
            labelNoSaved.isHidden = false
            paymentTableView.isHidden = true
        } else {
            labelNoSaved.isHidden = true
            paymentTableView.isHidden = false
        }
    }

}

//MARK: - TableView
extension PaymentMethodsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as! PaymentMethodsTableViewCell
        
        let card = cardList[indexPath.row]
        
        cell.buttonEdit.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.buttonEdit.tag = indexPath.row
        
        cell.buttonDelete.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        cell.buttonDelete.tag = indexPath.row
        
        cell.labelCardName.text = card.title
        
        let formattedCardNumber = formatCreditCardNumber(card.cardNumber!)
        cell.labelCardNumber.text = formattedCardNumber
        
        if defaultCard?.id == card.id {
            cell.checkmarkImageView.isHidden = false
        } else {
            cell.checkmarkImageView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard cardList[indexPath.row].id! != defaultCard?.id else {
            return
        }
        
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overFullScreen
        loadingVC.modalTransitionStyle = .crossDissolve
        present(loadingVC, animated: true, completion: nil)
        
        paymentViewModel.setDefaultCardID(viewController: self, defaultCardID: cardList[indexPath.row].id!) {
            self.paymentViewModel.getDefaultCard(viewController: self) { card in
                self.defaultCard = card
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.dismiss(animated: true, completion: nil)
                    self.paymentTableView.reloadData()
                }
            }
        }
    }
    
    func formatCreditCardNumber(_ cardNumber: String) -> String {
        
        guard cardNumber.count == 19 else {
            return "Invalid Card Number"
        }

        let formattedNumber = "**** **** **** \(cardNumber.suffix(4))"
        return formattedNumber
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        let selectedCard = cardList[sender.tag]
        performSegue(withIdentifier: "toCardEdit", sender: selectedCard)
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let deletedCard = cardList[sender.tag]
        
        paymentViewModel.deleteCard(viewController: self, cardID: cardList[sender.tag].id!)
        
        if deletedCard.id == defaultCard?.id {
            if let randomCard = cardList.filter({ $0.id != deletedCard.id }).randomElement() {
                paymentViewModel.setDefaultCardID(viewController: self, defaultCardID: randomCard.id!) {
                    self.paymentViewModel.getDefaultCard(viewController: self) { card in
                        self.defaultCard = card
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCardEdit" {
            if let selectedCard = sender as? Cards {
                let destinationVC = segue.destination as! CardViewController
                destinationVC.editCard = selectedCard
            }
        }
    }
}
