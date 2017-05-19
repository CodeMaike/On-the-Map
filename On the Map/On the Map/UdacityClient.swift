//
//  UdacityClient.swift
//  On the Map
//
//  Created by Maike Schmidt on 02/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    var session = URLSession.shared
    var appDelegate: AppDelegate!
    
    override init() {
        super.init()
    }
    
    //MARK: Login to udacity
    func taskForPOSTMethodUdacity(_ completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        let request = NSMutableURLRequest(url: URL(string: Constants.URLConstants.sessionURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(Constants.LoginData.username)\", \"password\": \"\(Constants.LoginData.password)\"}}".data(using: String.Encoding.utf8)
        
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
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        return task
    }

    //MARK: Get public udacity user data
    func taskForGETPublicUserDataUdacity(userID: String?, _ completionHandlerForGetPublicData: @ escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
    
        let userID = userID!
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userID)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            self.convertDataWithCompletionHandler(newData!, completionHandlerForConvertData: completionHandlerForGetPublicData)
        }

        task.resume()
        return task
    }

    
    //MARK: Deleting a session
//    func taskForDELETEMethod(_ urlString: String, completionHandlerForDelete: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    func taskForDELETEMethod(completionHandlerForDelete: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api.session")!)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
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

//            let range = Range(uncheckedBounds: (5, data.count - 5))
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDelete)
        }
        
        task.resume()
        return task
    }
    
    //MARK: Helpers
    
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


    
    //Keep?
    func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            for (key, value) in parameters {
                let valueString = "\(value)"
                let valueEscaped = valueString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                keyValuePairs.append(key + "=" + "\(String(describing: valueEscaped))")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
    //MARK: shared instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}


