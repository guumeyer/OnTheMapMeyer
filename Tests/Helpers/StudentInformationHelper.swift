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
    static func make(uniqueKey: String = "",
                     firstName: String = "",
                     lastName: String = "",
                     mapString: String = "",
                     mediaURL: String = "",
                     latitude: Double = 0,
                     longitude: Double = 0) -> StudentInformation {
        
        return StudentInformation(uniqueKey: uniqueKey,
                               firstName: firstName,
                               lastName: lastName,
                               mapString: mapString,
                               mediaURL: mediaURL,
                               latitude: latitude,
                               longitude: longitude,
                               objectId: nil,
                               createdAt: nil,
                               updatedAt: nil
            )
    }
    
    static func makeMock() -> StudentInformation {
        return make( uniqueKey: "996618664",
                     firstName: "Jarrod",
                     lastName: "Parkes",
                     mapString: "Huntsville, Alabama ",
                     mediaURL: "https://www.linkedin.com/in/jarrodparkes",
                     latitude: 34.7303688,
                     longitude: -86.5861037)
    }
}

