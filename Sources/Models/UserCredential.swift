//
//  UserCredential.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/22/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

// MARK: - UserCredential
public struct UserCredential {
    let userName: String
    let password: String

    private init(userName: String, password: String) {
        self.userName = userName
        self.password = password
    }

    public enum CredentialError: LocalizedError {
        case emptyCredentialContent
        case invalidFormartData

        public var errorDescription: String? {
            switch self {
            case .emptyCredentialContent:
                return "Empty Email or Password."
            case .invalidFormartData:
                return "Invalid Email or Password."
            }
        }
    }

    /// Builds a immutable UserCredential object
    public class Builder {
        private var userNameCredential: String = ""
        private var passwordCredential: String = ""

        public func user(_ userName: String) -> Builder {
            userNameCredential = userName
            return self
        }

        public func password(_ password: String) -> Builder {
            passwordCredential = password
            return self
        }

        public func build() throws -> UserCredential {
            if userNameCredential.isEmpty || passwordCredential.isEmpty {
                throw CredentialError.emptyCredentialContent
            }
            if !userNameCredential.contains("@") || !userNameCredential.contains(".") {
                throw CredentialError.invalidFormartData
            }

            return UserCredential(userName: userNameCredential, password: passwordCredential)
        }
    }
}
