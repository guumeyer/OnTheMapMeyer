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
    ///   - objectId: The objectId to be updated .
    ///   - location: The `StudentInformation`
    ///   - completionHandler: the completion will retrive `LoadStudentLocationResult` based on the server response.
    func save(objectId: String?,
              location: StudentInformation,
              completionHandler: @escaping (LoadStudentLocationResult<StudentInformationSavable>) -> Void)
}
