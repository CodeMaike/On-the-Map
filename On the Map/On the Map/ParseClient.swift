//
//  ParseClient.swift
//  On the Map
//
//  Created by Maike Schmidt on 08/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import Foundation

class ParseClient: NSObject {

    let parseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    let studentLocationURL = "https://parse.udacity.com/parse/classes/StudentLocation"
    
    struct StudentLocation {
        static var objectID = "objectID"
        static var uniqueKey = "uniqueKey"
        static var firstName = "firstName"
        static var lastName = "lastName"
        static var mapString = "mapString"
        static var mediaURL = "mediaURL"
        static var latitude: Double = 37.386052
        static var longitute: Double = -122.083851
        
        //no need to worry about these
        static var createdAt = "Feb 25, 2015"
        static var updatedAt = "Feb 25, 2017"
        static var acl = "Public Write and Read"
    }
    
    
    //TODOD: Make constants and use to replace 
    
    //MARK: Methods 
    
    //MARK: Get location of multiple students
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: studentLocationURL)!)
        request.addValue(parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                print("Something went wrong with your POST request: \(error)")
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
    
    
    //MARK: Get a student location
    func taskForGETLocationMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let urlString = studentLocationURL
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.addValue(parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
        
            guard (error == nil) else {
                print("Something went wrong with your POST request: \(error)")
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
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
        let request = NSMutableURLRequest(url: URL(string: studentLocationURL)!)
        request.httpMethod = "POST"
        request.addValue(parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                print("Something went wrong with your POST request: \(error)")
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
    
    //MARK: Put a student location
    func taskForPUTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
        
            guard (error == nil) else {
                print("Something went wrong with your POST request: \(error)")
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
    
    
    //MARK: Shared instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
