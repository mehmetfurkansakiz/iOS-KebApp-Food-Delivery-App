//
//  AddressViewController.swift
//  iOSBootcampFinalAssignmentFoodApp
//
//  Created by furkan sakız on 10.01.2024.
//

import UIKit
import MapKit
import CoreLocation

class AddressViewController: UIViewController {

    @IBOutlet weak var addressMapView: MKMapView!
    @IBOutlet weak var addressTitleTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var streetTF: UITextField!
    @IBOutlet weak var postalCodeTF: UITextField!
    @IBOutlet weak var buildingNumberTF: UITextField!
    @IBOutlet weak var floorTF: UITextField!
    @IBOutlet weak var doorNumberTF: UITextField!
    @IBOutlet weak var telephoneNumberTF: UITextField!
    
    let addressViewModel = AddressViewModel()
    var address = Address()
    var locationManager = CLLocationManager()
    var editAddress: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressMapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2
        addressMapView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if editAddress != nil {
            navigationItem.title = "Edit your address"
            addressTitleTF.text = editAddress?.addressTitle
            cityTF.text = editAddress?.city
            stateTF.text = editAddress?.state
            streetTF.text = editAddress?.street
            postalCodeTF.text = editAddress?.postalCode
            buildingNumberTF.text = editAddress?.buildingNumber
            floorTF.text = editAddress?.floorNumber
            doorNumberTF.text = editAddress?.doorNumber
            telephoneNumberTF.text = editAddress?.telephoneNo
        } else {
            navigationItem.title = "Add your address"
        }
    }

    @IBAction func buttonSaveContinue(_ sender: Any) {
        guard let city = cityTF.text, !city.isEmpty,
              let state = stateTF.text, !state.isEmpty,
              let street = streetTF.text, !street.isEmpty,
              let addressTitle = addressTitleTF.text, !addressTitle.isEmpty,
              let floorNumber = floorTF.text, !floorNumber.isEmpty,
              let postalCode = postalCodeTF.text, !postalCode.isEmpty,
              let buildingNumber = buildingNumberTF.text, !buildingNumber.isEmpty,
              let doorNumber = doorNumberTF.text, !doorNumber.isEmpty,
              let telephoneNumber = telephoneNumberTF.text, !telephoneNumber.isEmpty
        else {
            AlertHelper.createAlert(title: "Error", message: "Please fill in all fields.", in: self)
            return
        }
        
        if editAddress != nil {
            
            address.city = city
            address.state = state
            address.street = street
            address.addressTitle = addressTitle
            address.floorNumber = floorNumber
            address.postalCode = postalCode
            address.buildingNumber = buildingNumber
            address.doorNumber = doorNumber
            address.telephoneNo = telephoneNumber
            
            addressViewModel.editAddress(viewController: self, addressID: (editAddress?.id)!, updatedAddress: address)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            
            address.id = UUID().uuidString
            address.city = city
            address.state = state
            address.street = street
            address.addressTitle = addressTitle
            address.floorNumber = floorNumber
            address.postalCode = postalCode
            address.buildingNumber = buildingNumber
            address.doorNumber = doorNumber
            address.telephoneNo = telephoneNumber
            
            addressViewModel.addAddress(viewController: self, address: address)
            performSegue(withIdentifier: "toMyProfile", sender: nil)
        }
    }
    
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: self.addressMapView)
            let touchedCoordinates = addressMapView.convert(touchedPoint, toCoordinateFrom: self.addressMapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = "New Annotation"
            annotation.subtitle = "My Location"
            addressMapView.addAnnotation(annotation)
        }
    }
}

extension AddressViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: location, span: span)
        addressMapView?.setRegion(region, animated: true)
        
    }
}
