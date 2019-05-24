//
//  StudentLocationLoader.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/20/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

// MARK: - LoadStudentLocationResult
enum LoadStudentLocationResult<T> {
    case success(T)
    case failure(Error)
}

// MARK: - StudentLocationLoader
/// StudentLocationLoader protocol
protocol StudentLocationLoader {
    /// Loads the student locations
    ///
    /// - Parameter completionHandler:  the completion will retrive `LoadStudentLocationResult` based on the server response.
    func load(completionHandler: @escaping (LoadStudentLocationResult<[StudentLocation]>) -> Void)
//    func add(_ studentLocation: StudentLocation, completionHandler: @escaping (LoadStudentLocationResult) -> Void)
}
