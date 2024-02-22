//
//  CheckoutViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 3.01.2024.
//

import UIKit
import MapKit
import RxSwift

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var checkoutScroolView: UIView!
    @IBOutlet weak var checkoutMapView: MKMapView!
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var defaultAddressStackView: UIStackView!
    @IBOutlet weak var labelAddressTitle: UILabel!
    @IBOutlet weak var labelAddressText: UILabel!
    
    @IBOutlet weak var paymentStackView: UIStackView!
    @IBOutlet weak var addPaymentStackView: UIStackView!
    @IBOutlet weak var cardStackView: UIStackView!
    @IBOutlet weak var labelCardTitle: UILabel!
    @IBOutlet weak var labelCardNumber: UILabel!
    
    @IBOutlet weak var summaryTableView: UITableView!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    let addressViewModel = AddressViewModel()
    var defaultAddress: Address?
    let paymentViewModel = PaymentViewModel()
    var defaultCard: Cards?
    var cartFoods = [CartFoods]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeAppearance()
        
        summaryTableView.delegate = self
        summaryTableView.dataSource = self
        summaryTableView.rowHeight = UITableView.automaticDimension
        summaryTableView.estimatedRowHeight = 48.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addressViewModel.getDefaultAddress(viewController: self) { address in
            self.defaultAddress = address
            self.checkDefaultAddress()
        }
        paymentViewModel.getDefaultCard(viewController: self) { card in
            self.defaultCard = card
            self.checkDefaultCard()
        }
        calculateDiscountedTotalPrice()
        configureScrollViewHeight()
    }
    
    func configureScrollViewHeight() {
        let minHeight: CGFloat = 620
        let totalHeight = CGFloat(cartFoods.count * 48) + minHeight
        
        let newHeight = max(totalHeight, minHeight)
        
        scrollViewHeightConstraint.constant = newHeight
        checkoutScroolView.layoutIfNeeded()
    }
    
    func calculateDiscountedTotalPrice() {
        var totalCartPrice = 0
        
        for cart in cartFoods {
            if let foodPrice = Int(cart.yemek_fiyat!) {
                totalCartPrice += foodPrice
            }
        }
        let discountedPrice = Double(totalCartPrice) * 0.75
        labelTotalPrice.text = String(format: "%.2f ₺", discountedPrice)
    }
    
    func checkDefaultAddress() {
        if defaultAddress != nil {
            defaultAddressStackView.isHidden = false
            labelAddressTitle.text = defaultAddress?.addressTitle
            labelAddressText.text = "\(defaultAddress?.city ?? "") \(defaultAddress?.state ?? ""), \(defaultAddress?.postalCode ?? "")"
        } else {
            defaultAddressStackView.isHidden = true
            labelAddressTitle.text = ""
            labelAddressText.text = ""
        }
    }
    
    func checkDefaultCard() {
        if defaultCard != nil {
            cardStackView.isHidden = false
            labelCardTitle.text = defaultCard?.title
            labelCardNumber.text = formatCreditCardNumber((defaultCard?.cardNumber)!)
        } else {
            cardStackView.isHidden = true
            labelCardTitle.text = ""
            labelCardNumber.text = ""
        }
    }
    
    private func customizeAppearance() {
        customizeStackView(addressStackView)
        customizeStackView(paymentStackView)
        
        let addPaymentGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(paymentStackViewTapped))
        addPaymentStackView.addGestureRecognizer(addPaymentGestureRecognizer)
    }
    
    private func customizeStackView(_ stackView: UIStackView) {
        let edgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.layoutMargins = edgeInsets
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = 10.0
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.gray.cgColor
        
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.2
        stackView.layer.shadowOffset = CGSize(width: 0, height: 2)
        stackView.layer.shadowRadius = 4
    }
    
    func formatCreditCardNumber(_ cardNumber: String) -> String {
        
        guard cardNumber.count == 19 else {
            return "Invalid Card Number"
        }

        let formattedNumber = "**** **** **** \(cardNumber.suffix(4))"
        return formattedNumber
    }
    
    @objc func paymentStackViewTapped() {
        performSegue(withIdentifier: "toPayment", sender: nil)
    }

    @IBAction func buttonPlaceOrder(_ sender: Any) {
    }
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) as! OrderSumTableViewCell
        
        let food = cartFoods[indexPath.row]
        
        cell.labelItemName.text = "\(food.yemek_adi ?? "undefined") x \(food.yemek_siparis_adet ?? "NaN")"
        cell.labelItemPrice.text = "\(food.yemek_fiyat ?? "NaN") ₺"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
