//
//  EnterLocationViewController.swift
//  On the Map
//
//  Created by Maike Schmidt on 07/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import UIKit
import CoreLocation

class EnterLocationViewController: UIViewController {

    //code snippets from https://cocoacasts.com/forward-and-reverse-geocoding-with-clgeocoder-part-1/
    
    //MARK: Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findOnMapButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //test code
        print("first: \(Constants.StudentLocation.longitute)")
        print("first: \(Constants.StudentLocation.latitude)")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func findOnMapPressed(_ sender: Any) {
        
        if locationTextField.text != nil {
            
            Constants.NewStudent.mapString = locationTextField.text!
            
//            geocoder.geocodeAddressString(Constants.StudentLocation.mapString) { (placemarks, error) in
            geocoder.geocodeAddressString(Constants.NewStudent.mapString) { (placemarks, error) in
                
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
            
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "SetLinkToShareViewController") as! SetLinkToShareViewController
            self.present(controller, animated: true, completion: nil)

            //test code
            print("second: \(Constants.StudentLocation.longitute)")
            print("second: \(Constants.StudentLocation.latitude)")
        } else {
            print("No location entered")
            //TODO: AlertController
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            locationTextField.text = "Unable to Find Location for Address"
            
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                locationTextField.text = "\(coordinate.latitude), \(coordinate.longitude)"
            } else {
                locationTextField.text = "Location not found"
            }
            
            Constants.StudentLocation.latitude = (location?.coordinate.latitude)!
            Constants.StudentLocation.longitute = (location?.coordinate.longitude)!
        }
    }
    
    //Dismiss viewController
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension EnterLocationViewController {
    
    //Make keyboard disappear upon pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Move textFields up to not be covered by keyboard
    func keyboardWillShow(_ notification:Notification) {
        if locationTextField.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}
