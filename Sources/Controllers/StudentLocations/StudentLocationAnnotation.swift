//
//  StudentLocationAnnotation.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/16/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit
import MapKit

final class StudentLocationAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let information: StudentLocation

    init(information: StudentLocation) {
        self.information = information
        self.coordinate = CLLocationCoordinate2D(latitude: information.latitude, longitude: information.longitude)
    }

    var title: String? {
        return information.fullName
    }

    var subtitle: String? {
        return information.mediaURL
    }
}
