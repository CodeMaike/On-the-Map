//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Maike Schmidt on 20/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {

    //MARK: Login function to udacity
    func loginToUdacity(username: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: Constants.URLConstants.sessionURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
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

            let range = Range(5..<data.count)//(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForLogin)
        }
        
        task.resume()
        
    }

    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getUserID() { (success, userID, errorString) in
            if success {
                if let userID = userID {
                    self.getUserData(userID: userID) { (success, userData, errorString) in
                        completionHandlerForAuth(success, errorString)
                    }
                } else {
                    completionHandlerForAuth(success, errorString)
                }
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
        
    }
    
    func getUserID(_ completionHandlerForGetUserID: @escaping (_ success: Bool,_ userID: String?, _ errorString: String?) -> Void) {
    
        let _ = taskForPOSTMethodUdacity() { (result, error) in
            
            if let error = error {
                print(error)
                completionHandlerForGetUserID(false, nil, "Login unsuccessful")
            } else {
                if let account = result?["account"] as? [String:AnyObject] {
                    if let userId = account["key"] as? String {
                        print ("User ID: \(userId)")
                        Constants.LoginData.uniqueKey = userId
                        completionHandlerForGetUserID(true, userId, nil)
                    } else {
                        print ("User ID not found")
                        completionHandlerForGetUserID(false, nil, "Login unsuccessful")
                    }
                } else {
                    print("Account not found")
                    completionHandlerForGetUserID(false, nil, "Login unsuccessful")
                }
            }

        }
    }
    
    func getUserData(userID: String?, _ completionHandlerForGetUserData: @escaping (_ success: Bool, _ userData: [String:AnyObject]?, _ errorString: String?) -> Void) {
        let userID = userID!
        let _ = taskForGETPublicUserDataUdacity(userID: userID) { (result, error) in
            if let error = error {
                print(error)
                completionHandlerForGetUserData(false, nil, "Getting user data unsuccessful")
            } else {
                let userResult = result!
                if let userData = userResult["user"] as? [String:AnyObject] {
                    completionHandlerForGetUserData(true, userData, nil)
                } else {
                    print("No user data found")
                }
            }
        }
    }
    
    //MARK: Convert raw JSON to usable foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ success: Bool, _ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            print(parsedResult)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse data as JSON: \(data)"]
            completionHandlerForConvertData(false, nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        
            //check account
            guard let account = parsedResult["account"] as? [String:AnyObject] else {
                print("There is an problem with your account information.")
                return
            }
            //check user id
            guard let userID = account["key"] as? String else {
                print("There is a problem with your user ID.")
                return
            }
            //check session dictionary
            guard let sessionDictionary = parsedResult["session"] as? [String:AnyObject] else {
                print("There is a problem with your session dictionary.")
                return
            }
            //check session
            guard let session = sessionDictionary["userID"] as? String else {
                print("There is a problem with your session ID.")
                return
            }
            
            
            print(userID)
            print(session)
            
            appDelegate?.userID = userID
            appDelegate?.session = session
            
            completionHandlerForConvertData(true, parsedResult, nil)
        }
        
        
    }
}
