//

//  SetLinkToShareViewController.swift
//  On the Map
//
//  Created by Maike Schmidt on 07/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import UIKit
import MapKit

class SetLinkToShareViewController: UIViewController, MKMapViewDelegate {

    //MARK: Outlets
    @IBOutlet weak var linkToShareTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    var mapString = Constants.NewStudent.mapString

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addressOnMap(address: mapString)
//        let initialLocation = CLLocation(latitude: Constants.StudentLocation.latitude, longitude: Constants.StudentLocation.longitute)
//        
//        centerMapOnLocation(location: initialLocation)
        }
    
//    let regionRadius: CLLocationDistance = 1000
//    
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
   
    @IBAction func submitButtonPressed(_ sender: Any) {
        
    }
    
    func addressOnMap(address: String) {
    
        let locationRequest = MKLocalSearchRequest()
        locationRequest.naturalLanguageQuery = mapString
        locationRequest.region = mapView.region
        
        let search = MKLocalSearch(request: locationRequest)
        search.start { (locationRequest, error) in
            var placeMarks = [MKPlacemark]()
            if error != nil {
                print("Location not found")
                return
            }
            for item in locationRequest!.mapItems {
                placeMarks.append(item.placemark)
                print("Item: \(item)")
            }
            
            self.mapView.showAnnotations([placeMarks[0]], animated: false)
            
            let newLatitude = String(placeMarks[0].coordinate.latitude)
            let newLongitude = String(placeMarks[0].coordinate.longitude)
            let newMapString = placeMarks[0].description
            let newUniqueKey = Constants.StudentLocation.uniqueKey
            print("New unique key: \(newUniqueKey)")
            
            
        }
        
        //MARK: Check with func in ParseClient
        func postStudentLocation(newUniqueKey: String, mapString: String, newLatitude: String, newLongitude: String) {
        
            let request = NSMutableURLRequest(url: URL(string: Constants.StudentLocation.studentLocationURL)!)
            request.httpMethod = "POST"
            request.addValue(Constants.StudentLocation.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.StudentLocation.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"uniqueKey\": \"\(Constants.StudentLocation.uniqueKey)\", \"firstName\": \"\(Constants.StudentLocation.firstName)\", \"lastName\": \"\(Constants.StudentLocation.lastName)\",\"mapString\": \"\(Constants.StudentLocation.mapString)\", \"mediaURL\": \"\(Constants.StudentLocation.mediaURL)\",\"latitude\": \(Constants.StudentLocation.latitude), \"longitude\": \(Constants.StudentLocation.longitute)}".data(using: String.Encoding.utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                
                guard (error == nil) else {
                    print("Something went wrong with your POST request: \(String(describing: error))")
                    return
                }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    print("Your status code does not conform to 2xx.")
                    return
                }
                
                guard let data = data else {
                    print("The request returned no data.")
                    return
                }
                
                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            }
            
            task.resume()
        }
        
    }

    //Dismiss viewController
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
