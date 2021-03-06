//
//  MapViewController.swift
//  On the Map
//
//  Created by Maike Schmidt on 02/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationJSON = [[String:AnyObject]]()
    var address = Constants.NewStudent.mapString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        taskForGETMultipleStudentLocationsMethod { (success, locationJSON, errorString) in
            
            let locations = Constants.StudentData.studentInformation
            print("Locations: \(locations)")
            var annotations = [MKPointAnnotation]()
            
            for dictionary in locations {
                if let latitude = dictionary["latitude"] as? Double, let longitude = dictionary["longitude"] as? Double {
                    print("Longitude: \(longitude), Latitude: \(latitude)")
                    
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let firstName = dictionary["firstName"] as! String
                    let lastName = dictionary["lastName"] as! String
                    let mediaURL = dictionary["mediaURL"] as! String
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append(annotation)
                }
            }
            
            self.mapView.addAnnotations(annotations)
        }
    }
    
    //Pin button pressed
    @IBAction func pinButtonPressed(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterLocationVC") as! EnterLocationViewController
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: Map view delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(NSURL(string: toOpen)! as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    //MARK: Get location of multiple students
    func taskForGETMultipleStudentLocationsMethod(completionHandlerForMultipleStudentLocations: @escaping (_ success: Bool, _ locationJSON: [[String:AnyObject]]?, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: Constants.StudentLocation.studentLocationURL)!)
        request.addValue(Constants.StudentLocation.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.StudentLocation.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
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
        
            let parsedResult: [String:AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse data as JSON: \(data)")
                return
            }
            
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                print("No result found")
                return
            }
            
            Constants.StudentData.studentInformation = results
            completionHandlerForMultipleStudentLocations(true, Constants.StudentData.studentInformation, nil)

            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
        }
        
        task.resume()
    }

    //MARK: Get location of single student
    func taskForGETSingleStudentLocation() -> URLSessionDataTask {
    
        let urlString = Constants.StudentLocation.studentLocationURL
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.addValue(Constants.StudentLocation.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.StudentLocation.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
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
        return task
    }

    /*
    func taskForPOSTMethodParse(newUniqueKey: String, newAddress: String, newLatitude: String, newLongitude: String) {
        
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
            //            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        //        return task
    }
    
    func searchLocation(address: String) {
    
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = address
        localSearchRequest.region = mapView.region
        
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) in
            var placeMarks = [MKPlacemark]()
            if error != nil {
                print("There is an error")
            }
            for response in (localSearchResponse?.mapItems)! {
                placeMarks.append(response.placemark)
                print("Response: \(response)")
            }
            
            self.mapView.showAnnotations([placeMarks[0]], animated: false)
            
            let newLatitude = String(placeMarks[0].coordinate.latitude)
            let newLongitude = String(placeMarks[0].coordinate.longitude)
            let newAddress = placeMarks[0].description
            let newUniqueKey = Constants.NewStudent.uniqueKey
            print("The new unique key is \(newUniqueKey)")
        
            self.taskForPOSTMethodParse(newUniqueKey: newUniqueKey, newAddress: newAddress, newLatitude: newLatitude, newLongitude: newLongitude)
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController")
            self.present(controller!, animated: true, completion: nil)
        }
    }
    */

 }
