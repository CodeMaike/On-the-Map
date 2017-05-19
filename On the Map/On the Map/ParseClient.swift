//
//  ParseClient.swift
//  On the Map
//
//  Created by Maike Schmidt on 08/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import Foundation
import MapKit

class ParseClient: NSObject {
    
    var session = URLSession.shared
    var appDelegate: AppDelegate!
    
    //TODOD: Make constants and use to replace 
    
    //MARK: Methods 
    
    //MARK: Get location of multiple students
//    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
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
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
        }
        
        task.resume()
//        return task
    }
    
    
    //MARK: Get a student location
//    func taskForGETLocationMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
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
    
    
    //MARK: Post student location
//    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
//        func taskForPOSTMethodParse(_ completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
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
    
    //MARK: Put a student location
    func taskForPUTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
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
        return task
    }
    
    //convert raw JSON to usable foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse data as JSON: \(data)"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    //MARK: Shared instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
