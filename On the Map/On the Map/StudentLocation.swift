//
//  StudentLocation.swift
//  On the Map
//
//  Created by Maike Schmidt on 16/03/2017.
//  Copyright © 2017 Maike Schmidt. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var firstName = ""
    var lastName = ""
    var location = ""
    var website = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    init(dictionary: [String:AnyObject]) {
    
        if let fName = dictionary[ParseClient.StudentLocation.firstName] as? String {
            firstName = fName
        }
        if let lName = dictionary[ParseClient.StudentLocation.lastName] as? String {
            lastName = lName
        }
        if let mapString = dictionary[ParseClient.StudentLocation.mapString] as? String {
            location = mapString
        }
        if let mediaURL = dictionary[ParseClient.StudentLocation.mediaURL] as? String {
            website = mediaURL
        }
//        if let latit = dictionary[ParseClient.StudentLocation.latitude] as? Double {
//            latitude = latit
//        }
//        if let longit = dictionary[ParseClient.StudentLocation.longitute] as? Double {
//            longitude = longit
//        }
    }
    
    static func studentInformationResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
    
        var studentDictionary = [StudentLocation]()
        
        for result in results {
            studentDictionary.append(StudentLocation(dictionary: result))
        }
        return studentDictionary
    }
}
