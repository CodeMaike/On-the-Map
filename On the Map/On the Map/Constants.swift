//
//  Constants.swift
//  On the Map
//
//  Created by Maike Schmidt on 08/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import Foundation

//extension UdacityClient {

    struct Constants {
        
        
        // MARK: Constants
        struct URLConstants {
            static let baseURL = "https://www.udacity.com/api"
            static let sessionURL = "https://www.udacity.com/api/session"
            static let userURL = "https://www.udacity.com/api/users"
        }
        
        // MARK: Parameter Keys
        struct ParameterKeys {
            static let udacity = "udacity"
            static let username = "username"
            static let password = "password"
            static let sessionID = "session"
        }
        
        //MARK: Login data
        struct LoginData {
            static var username = ""
            static var password = ""
            static var uniqueKey = ""
        }
        
        // MARK: JSON Response Keys
        struct JSONResponseKeys {
            
            // Public User Data
            static let userID = "userID"
            
            static let firstName = "first_name"
            static let lastName = "last_name"
            
            // Session
            static let account = "account"
            static let session = "session"
            static let accountKey = "key"
            static let expiration = "expiration"
        }

    }
//}
