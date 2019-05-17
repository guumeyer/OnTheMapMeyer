//
//  StudentInformation.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/15/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

struct StudentInformation: Decodable{
    let pinImageName = "icon_pin"
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: Date
    let updatedAt: Date
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}
