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
    /// - Parameter completionHandler: the completion will retrive `LoadStudentLocationResult` based on the server response.
    func load(completionHandler: @escaping (LoadStudentLocationResult<[StudentInformation]>) -> Void)

    /// Saves the student information
    ///
    /// - Parameters:
    ///   - session: The `UserSession`.
    ///   - location: The `StudentInformation`
    ///   - completionHandler: the completion will retrive `LoadStudentLocationResult` based on the server response.
    func save(session: UserSession?,
              location: StudentInformation,
              completionHandler: @escaping (LoadStudentLocationResult<StudentInformationSavable>) -> Void)
}
