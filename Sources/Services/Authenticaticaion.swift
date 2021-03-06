//
//  Authenticaticaion.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/22/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

// MARK: - AuthenticaticaionResult
enum AuthenticaticaionResult {
    case success(UserSession)
    case failure(Error)
}

enum LogoffResult {
    case success
    case failure(Error)
}

enum UserDetailResult {
    case success(User)
    case failure(Error)
}

//enum AuthenticaticaionResult {
//    case success(UserSession)
//    case failure(Error)
//}


// MARK: - Authenticaticaion
/// Authentication protocol
protocol Authenticaticaion {

    /// Authorizes the user credentials
    ///
    /// - Parameters:
    ///   - credential: the user credentials
    ///   - completion: the completion will retrive `AuthenticaticaionResult` based on the server response.
    func authorize(credential: UserCredential, completion: @escaping (AuthenticaticaionResult) -> Void)

    /// Logoff the user session
    ///
    /// - Parameter completion: the completion will retrive `LogoffResult` based on the server response.
    func logoff(completion: @escaping (LogoffResult) -> Void)

    /// Logoff the user session
    ///
    /// - Parameter completion: the completion will retrive `LogoffResult` based on the server response.
    func userDetail(_ userDetail: UserSession,  completion: @escaping (UserDetailResult) -> Void)
    
}
