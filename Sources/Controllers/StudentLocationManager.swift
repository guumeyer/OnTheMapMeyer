//
//  StudentLocationManager.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/23/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit

/// StudentLocationManager is a singleton instance
final class StudentLocationManager {

    static let shared = StudentLocationManager()

    private init() {}

    private let udacityAPI = UdacityApiLoader(client: URLSessionHTTPClient())

    /// Makes a new instance of StudentLocationNavigationController
    ///
    /// - Returns: an instance of StudentLocationNavigationController
    func makeStudentLocationNavigationController() -> StudentLocationNavigationController {
        let navigationController = StudentLocationNavigationController(
            loader: udacityAPI,
            selection: handleSelection(),
            alertView: handleDisplayAlertView())
        return navigationController
    }

    /// Makes AuthenticationViewController
    ///
    /// - Returns: an instance of AuthenticationViewController
    func makeAuthentication() -> AuthenticationViewController {
        let authenticationViewController = AuthenticationViewController(
            udacityService: udacityAPI,
            openURLHandler: handleOpenURL(),
            alertView: handleDisplayAlertView()) { [weak self] viewController, userSession  in
                guard let strongSelf = self else { return }
                viewController.present(strongSelf.makeStudentLocationNavigationController(),
                                       animated: true,
                                       completion: nil)
        }
        return authenticationViewController
    }

    // MARK: - Helpers methods
    private func handleSelection() -> SelectionHandler {
        return {[weak self] information in
            self?.hadleOpeURL(information.mediaURL)
        }
    }

    private func handleOpenURL() -> (String) -> Void {
        return {[weak self] urlString in
            self?.hadleOpeURL(urlString)
        }
    }

    private func hadleOpeURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }

    private func handleDisplayAlertView() -> AlerViewHandler {
        return {viewController, title, message in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.accessibilityLabel = title
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }

}
