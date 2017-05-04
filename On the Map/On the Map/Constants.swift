//
//  Constants.swift
//  On the Map
//
//  Created by Maike Schmidt on 08/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import Foundation

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
        
        struct StudentData {
            static var studentInformation = [[String:AnyObject]]()
        }
        
        struct NewStudent {
            static var mapString = ""
            static var uniqueKey = ""
        }
        
        struct StudentLocation {
            
            static let parseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
            static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            
            static let studentLocationURL = "https://parse.udacity.com/parse/classes/StudentLocation"
            
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

    }
