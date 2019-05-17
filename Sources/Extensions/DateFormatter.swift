//
//  DateFormatter.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/15/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

extension DateFormatter {

    func iso8601() {
       calendar = Calendar(identifier: .iso8601)
       locale = Locale(identifier: "en_US_POSIX")
       timeZone = TimeZone(secondsFromGMT: 0)
       dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    }
}
