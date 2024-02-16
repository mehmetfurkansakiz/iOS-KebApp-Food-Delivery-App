//
//  AddressesViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 12.01.2024.
//

import UIKit
import RxSwift

class AddressesViewController: UIViewController {

    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var labelNoSaved: UILabel!
    
    let addressViewModel = AddressViewModel()
    var addressList =  [Address]()
    var defaultAddress: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        
        _ = addressViewModel.addressRepo.addressList.subscribe(onNext: { list in
            self.addressList = list
            DispatchQueue.main.async {
                self.addressesTableView.reloadData()
                self.checkAddress()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addressViewModel.getAddress(viewController: self)
        addressViewModel.getDefaultAddress(viewController: self) { address in
            self.defaultAddress = address
            self.addressesTableView.reloadData()
        }
    }
    
    func checkAddress() {
        if addressList.isEmpty == true {
            defaultAddress = nil
            labelNoSaved.isHidden = false
            addressesTableView.isHidden = true
        } else {
            
            labelNoSaved.isHidden = true
            addressesTableView.isHidden = false
        }
    }

}
//MARK: - TableView
extension AddressesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myAddressCell", for: indexPath) as! AddressesTableViewCell
        
        let addresses = addressList[indexPath.row]
        
        cell.buttonEdit.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.buttonEdit.tag = indexPath.row
        
        cell.buttonDelete.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        cell.buttonDelete.tag = indexPath.row
        
        cell.labelAddressName.text = addresses.addressTitle
        cell.labelAddressText.text = "\(addresses.state!), \(addresses.street!), \(addresses.doorNumber!), \(addresses.postalCode!), \(addresses.city!)"
        
        if defaultAddress?.id == addresses.id {
            cell.checkmarkImageView.isHidden = false
        } else {
            cell.checkmarkImageView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard addressList[indexPath.row].id! != defaultAddress?.id else {
            return
        }
        
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overFullScreen
        loadingVC.modalTransitionStyle = .crossDissolve
        present(loadingVC, animated: true, completion: nil)
        
        addressViewModel.setDefaultAddress(viewController: self, defaultAddressID: addressList[indexPath.row].id!) {
            self.addressViewModel.getDefaultAddress(viewController: self) { address in
                self.defaultAddress = address
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.dismiss(animated: true, completion: nil)
                    self.addressesTableView.reloadData()
                }
            }
        }
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        let selectedAddress = addressList[sender.tag]
        performSegue(withIdentifier: "toAddressEdit", sender: selectedAddress)
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let deletedAddress = addressList[sender.tag]
        
        addressViewModel.deleteAddress(viewController: self, addressID: deletedAddress.id!)
        
        if deletedAddress.id == defaultAddress?.id {
            if let randomAddress = addressList.filter({ $0.id != deletedAddress.id }).randomElement() {
                addressViewModel.setDefaultAddress(viewController: self, defaultAddressID: randomAddress.id!) {
                    self.addressViewModel.getDefaultAddress(viewController: self) { address in
                        self.defaultAddress = address
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddressEdit" {
            if let selectedAddress = sender as? Address {
                let destinationVC = segue.destination as! AddressViewController
                destinationVC.editAddress = selectedAddress
            }
        }
    }
}
