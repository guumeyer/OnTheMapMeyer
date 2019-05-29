//
//  StudentLocationManager.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/23/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit
import MapKit

/// StudentLocationManager is a singleton instance
final class StudentLocationManager {

    static let shared = StudentLocationManager()
    private let udacityAPI = UdacityApiLoader(client: URLSessionHTTPClient())
    private var userSession: UserSession? = nil
    var locations = [StudentInformation]()

    private init() {}

    /// Makes a new instance of StudentLocationNavigationController
    ///
    /// - Returns: an instance of StudentLocationNavigationController
    func makeStudentLocationNavigationController(_ authentication: Authenticaticaion) -> StudentLocationNavigationController {
        let navigationController = StudentLocationNavigationController(
            authentication: authentication,
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
            alertView: handleDisplayAlertView()) { [weak self] viewController, authenticaticaion, userSession  in
                guard let strongSelf = self else { return }

                strongSelf.userSession = userSession

                viewController.present(strongSelf.makeStudentLocationNavigationController(authenticaticaion),
                                       animated: true,
                                       completion: nil)
        }

        return authenticationViewController
    }

    func makeInformationPostingView() -> UINavigationController {
        let viewController = InformationPostingViewController(alertView: handleDisplayAlertView())
        return UINavigationController(rootViewController: viewController)
    }

    func makeFinishInformationPostingViewController(coordinate: CLLocationCoordinate2D,
                                                    location: String,
                                                    mediaURL: String) -> FinishInformationPostingViewController {
        return FinishInformationPostingViewController(coordinate: coordinate, location: location, mediaURL: mediaURL)
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

    func logff() {
        userSession = nil
        locations = []
    }
}
