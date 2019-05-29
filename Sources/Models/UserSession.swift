//
//  UserSession.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/21/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

// MARK: - SessionManager
public struct UserSession: Decodable {
    public let account: Account
    public let session: Session
}

// MARK: - Account
public struct Account: Decodable {
    public let registered: Bool
    public let key: String
}

// MARK: - Session
public struct Session: Decodable {
   public let id, expiration: String
}

