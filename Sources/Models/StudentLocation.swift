//
//  StudentLocation.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/15/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

// MARK: - StudentLocation
struct StudentLocation: Decodable, StudentLocationCreatable, StudentLocationUpdatable {
    let pinImageName = "icon_pin"
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
    var objectId: String
    var createdAt: Date
    var updatedAt: Date
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

// MARK: - StudentLocationCreatable
protocol StudentLocationCreatable: Decodable{
    var objectId: String { get }
    var createdAt: Date { get }
}

// MARK: - StudentLocationUpdatable
protocol StudentLocationUpdatable: Decodable{
    var updatedAt: Date { get }
}
