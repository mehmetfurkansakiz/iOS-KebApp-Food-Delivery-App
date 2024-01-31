//
//  CardViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 23.01.2024.
//

import UIKit

class CardViewController: UIViewController {

    
    @IBOutlet weak var cardTitleTF: UITextField!
    @IBOutlet weak var cardNumberTF: UITextField!
    @IBOutlet weak var cardExpiryTF: UITextField!
    @IBOutlet weak var ccvTF: UITextField!
    @IBOutlet weak var cardholderNameTF: UITextField!
    
    let paymentViewModel = PaymentViewModel()
    var card = Cards()
    var editCard: Cards?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardNumberTF.delegate = self
        cardExpiryTF.delegate = self
        ccvTF.delegate = self
        cardholderNameTF.delegate = self
        
        if editCard != nil {
            navigationItem.title = "Edit your card"
            cardTitleTF.text = editCard?.title
            cardNumberTF.text = editCard?.cardNumber
            cardExpiryTF.text = editCard?.expirationDate
            cardholderNameTF.text = editCard?.cardHolderName
            ccvTF.text = editCard?.cvv
        } else {
            navigationItem.title = "Save your Card"
        }
    }
    
    @IBAction func buttonSaveContinue(_ sender: Any) {
        guard let cardTitle = cardTitleTF.text, !cardTitle.isEmpty,
              let cardNumber = cardNumberTF.text, !cardNumber.isEmpty,
              let cardExpiry = cardExpiryTF.text, !cardExpiry.isEmpty,
              let cardholder = cardholderNameTF.text, !cardholder.isEmpty,
              let cardCCV = ccvTF.text, !cardCCV.isEmpty
        else {
            AlertHelper.createAlert(title: "Error", message: "Please fill in all fields.", in: self)
            return
        }
        
        card.title = cardTitle
        card.cardNumber = cardNumber
        card.expirationDate = cardExpiry
        card.cvv = cardCCV
        card.cardHolderName = cardholder
        
        if editCard != nil {
            
            paymentViewModel.editCard(viewController: self, cardID: (editCard?.id)!, updatedCard: card)
        } else {
            
            card.id = UUID().uuidString
            paymentViewModel.addCard(viewController: self, card: card)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension CardViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == cardNumberTF || textField == cardExpiryTF || textField == ccvTF {
            // Allow only numeric input
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)

            // Numeric input check
            guard allowedCharacters.isSuperset(of: characterSet) else {
                return false
            }
        }
        
        if textField == cardholderNameTF {
            // Allow only alphabetic characters and spaces
            let allowedCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: " "))
            let characterSet = CharacterSet(charactersIn: string)
            
            // Alphabetic character check
            guard allowedCharacters.isSuperset(of: characterSet) else {
                return false
            }
            
            
            // Convert the entered character to uppercase
            textField.text = textField.text?.uppercased()
            
            // Character limit
            let maxLength = 30
            return textField.text?.count ?? 0 <= maxLength
        }
        
        if textField == ccvTF {
            // Limit the length of the input to 3 characters for CCV
            let newLength = (textField.text ?? "").count + string.count - range.length
            return newLength <= 3
        }

        // If the current text field is the card number field
        if textField == cardNumberTF {
            
            // Modify the credit card string
            let trimmedString = (textField.text ?? "").components(separatedBy: .whitespaces).joined()
            let arrOfCharacters = Array(trimmedString)
            var modifiedCreditCardString = ""
            
            if arrOfCharacters.count > 0 {
                for i in 0...arrOfCharacters.count-1 {
                    modifiedCreditCardString.append(arrOfCharacters[i])
                    if (i+1) % 4 == 0 && i+1 != arrOfCharacters.count {
                        modifiedCreditCardString.append(" ")
                    }
                }
            }
            
            textField.text = modifiedCreditCardString
            
            // Limit the length of the input to 19 characters for the card number
            // (Formatted as "XXXX XXXX XXXX XXXX")
            let newLength = (textField.text ?? "").count + string.count - range.length
            return newLength <= 19
        }
        
        if textField == cardExpiryTF {

            // Get the current text
            var currentText = textField.text ?? ""

            // Add the newly entered character
            currentText = currentText.replacingCharacters(in: Range(range, in: currentText)!, with: string)

            // If the first digit of the month is not 0 or 1, add 0 to the beginning to fix it
            if currentText.count >= 1 {
                let firstDigit = currentText[currentText.startIndex]
                if firstDigit != "0" && firstDigit != "1" {
                    currentText.insert("0", at: currentText.startIndex)
                }
            }

            // If the 2nd character is being entered and the 1st character is 1, allow only 0, 1, 2
            if currentText.count == 2 {
                let secondDigit = currentText[currentText.index(currentText.startIndex, offsetBy: 1)]
                if currentText.hasPrefix("1") && !(secondDigit == "0" || secondDigit == "1" || secondDigit == "2") {
                    return false
                }
            }

            // If the 3rd character is being entered and there is no '/' before it, add it immediately
            if currentText.count >= 3 && currentText[currentText.index(currentText.startIndex, offsetBy: 2)] != "/" {
                currentText.insert("/", at: currentText.index(currentText.startIndex, offsetBy: 2))
            }

            // If the 4th character is being entered and the year is being completed, do not allow entry
            if currentText.count == 6 {
                return false
            }

            // If the last character is '/', and something is being deleted, remove the '/'
            if currentText.hasSuffix("/") && string.isEmpty {
                currentText.removeLast()
            }
            
            textField.text = currentText
            return false
        }
        return true
    }
}
