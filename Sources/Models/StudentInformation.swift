//
//  StudentInformation.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/15/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

// MARK: - StudentLocation
struct StudentInformation: Codable{
    let pinImageName = "icon_pin"
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
//    var objectId: String
//    var createdAt: Date
//    var updatedAt: Date
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

// MARK: - StudentInformationSavable
struct StudentInformationSavable: Decodable{
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
}
