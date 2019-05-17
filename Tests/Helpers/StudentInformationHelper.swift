//
//  StudentInformationHelper.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/16/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation
@testable import OnTheMapMeyer

extension StudentInformation {
    static func make(objectId: String = "",
                     uniqueKey: String = "",
                     firstName: String = "",
                     lastName: String = "",
                     mapString: String = "",
                     mediaURL: String = "",
                     latitude: Double = 0,
                     longitude: Double = 0,
                     createdAt: Date = Date(),
                     updatedAt: Date = Date()) -> StudentInformation {
        
        return StudentInformation(objectId: objectId,
                                  uniqueKey: uniqueKey,
                                  firstName: firstName,
                                  lastName: lastName,
                                  mapString: mapString,
                                  mediaURL: mediaURL,
                                  latitude: latitude,
                                  longitude: longitude,
                                  createdAt: createdAt,
                                  updatedAt: updatedAt)
    }
    
    static func makeMock() -> StudentInformation {
        return make( objectId: "JhOtcRkxsh",
                     uniqueKey: "996618664",
                     firstName: "Jarrod",
                     lastName: "Parkes",
                     mapString: "Huntsville, Alabama ",
                     mediaURL: "https://www.linkedin.com/in/jarrodparkes",
                     latitude: 34.7303688,
                     longitude: -86.5861037)
    }
}

