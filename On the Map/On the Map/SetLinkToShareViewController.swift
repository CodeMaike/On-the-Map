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
        //test code
        print("fourth: \(Constants.StudentLocation.longitute)")
        print("fourth: \(Constants.StudentLocation.latitude)")
        
        Constants.NewStudent.mediaURL = linkToShareTextField.text!
//        let initialLocation = CLLocation(latitude: Constants.StudentLocation.latitude, longitude: Constants.StudentLocation.longitute)
//        centerMapOnLocation(location: initialLocation)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let initialLocation = CLLocation(latitude: Constants.StudentLocation.latitude, longitude: Constants.StudentLocation.longitute)
        centerMapOnLocation(location: initialLocation)
        
        print("third: \(Constants.StudentLocation.longitute)")
        print("third: \(Constants.StudentLocation.latitude)")
    }
    
    let regionRadius: CLLocationDistance = 5000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
   
    @IBAction func submitButtonPressed(_ sender: Any) {
//        self.addressOnMap(address: mapString)
        self.locate(mapString: mapString)
    }
    
    func taskForPOSTMethodParse(newUniqueKey: String, newMapString: String, newMediaURL: String, newLatitude: String, newLongitude: String) {
        
        let request = NSMutableURLRequest(url: URL(string: Constants.StudentLocation.studentLocationURL)!)
        request.httpMethod = "POST"
        request.addValue(Constants.StudentLocation.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.StudentLocation.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(newUniqueKey)\", \"firstName\": \"\(Constants.StudentLocation.firstName)\", \"lastName\": \"\(Constants.StudentLocation.lastName)\",\"mapString\": \"\(newMapString)\", \"mediaURL\": \"\(newMediaURL)\",\"latitude\": \(newLatitude), \"longitude\": \(newLongitude)}".data(using: String.Encoding.utf8)
        
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
            //            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        
            var parsedResult: [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print ("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let objectID = parsedResult["objectID"] as? String else {
                print ("There is no objectId")
                return
            }
            
            Constants.NewStudent.objectID = objectID
            print("Your objectID: \(objectID)")
        }
        
        task.resume()
        //        return task
    }
    
    func locate(mapString: String) {
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = mapString
        localSearchRequest.region = mapView.region
        
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) in
            var placeMarks = [MKPlacemark]()
            if error != nil {
                print("There is an error")
                return
            }
            for response in (localSearchResponse?.mapItems)! {
                placeMarks.append(response.placemark)
                print("Response: \(response)")
            }
            
            self.mapView.showAnnotations([placeMarks[0]], animated: false)
            
            let newLatitude = String(placeMarks[0].coordinate.latitude)
            let newLongitude = String(placeMarks[0].coordinate.longitude)
            let newMapString = placeMarks[0].description
            let newUniqueKey = Constants.NewStudent.uniqueKey
            let newMediaURL = self.linkToShareTextField.text!
            
            self.taskForPOSTMethodParse(newUniqueKey: newUniqueKey, newMapString: newMapString, newMediaURL: newMediaURL, newLatitude: newLatitude, newLongitude: newLongitude)
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            self.present(controller!, animated: true, completion: nil)
        }
    }

    //Dismiss viewController
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
