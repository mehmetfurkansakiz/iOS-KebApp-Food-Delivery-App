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
    }
    
    func checkAddress() {
        if addressList.isEmpty == true {
            
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
        
        return cell
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        let selectedAddress = addressList[sender.tag]
        performSegue(withIdentifier: "toAddressEdit", sender: selectedAddress)
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        addressViewModel.deleteAddress(viewController: self, addressID: addressList[sender.tag].id!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.addressViewModel.getAddress(viewController: self)
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
