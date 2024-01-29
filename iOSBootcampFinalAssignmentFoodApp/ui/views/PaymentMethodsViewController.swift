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
    }
    
    func checkCards() {
        if cardList.isEmpty == true {
            labelNoSaved.isHidden = false
            paymentTableView.isHidden = true
        } else {
            labelNoSaved.isHidden = true
            paymentTableView.isHidden = false
        }
    }

}

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
        
        return cell
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
        paymentViewModel.deleteCard(viewController: self, cardID: cardList[sender.tag].id!)
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
