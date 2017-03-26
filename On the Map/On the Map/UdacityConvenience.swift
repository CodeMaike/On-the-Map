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

//    func loginToUdacity(username: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ result: AnyObject?, _ error: NSError?) -> Void) {
    func loginToUdacity(username: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: Constants.URLConstants.sessionURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
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
            
            let range = Range(uncheckedBounds: (5, data.count - 5))
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForLogin)
        }
        
        task.resume()
        
    }
    
    //TODO: check completionhandler
    //TODO:
    
    //convert raw JSON to usable foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ success: Bool, _ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse data as JSON: \(data)"]
            completionHandlerForConvertData(false, nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
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
