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
    private var userSession: UserSession!
    private var userDetail: User!
    private weak var mainNavigationController: StudentLocationNavigationController?
    var locations = [StudentInformation]()

    private init() {}

    /// Makes a new instance of StudentLocationNavigationController
    ///
    /// - Returns: an instance of StudentLocationNavigationController
    func makeStudentLocationNavigationController(_ authentication: Authenticaticaion) -> StudentLocationNavigationController {
        let navigationController = StudentLocationNavigationController(
            user: userDetail,
            authentication: authentication,
            loader: udacityAPI,
            selection: handleSelection(),
            alertView: handleDisplayAlertView())
        mainNavigationController = navigationController
        return navigationController
    }

    /// Makes AuthenticationViewController
    ///
    /// - Returns: an instance of AuthenticationViewController
    func makeAuthentication() -> AuthenticationViewController {
        let authenticationViewController = AuthenticationViewController(
            udacityService: udacityAPI,
            openURLHandler: handleOpenURL(),
            alertView: handleDisplayAlertView()) {
                [weak self] viewController, authenticaticaion, userSession, userDetail  in
                guard let strongSelf = self else { return }

                strongSelf.userSession = userSession
                strongSelf.userDetail = userDetail
                dump(userSession)
                dump(userDetail)
                
                viewController.present(strongSelf.makeStudentLocationNavigationController(authenticaticaion),
                                       animated: true,
                                       completion: nil)
        }

        return authenticationViewController
    }

    func makeInformationPostingView() -> UINavigationController {
        let viewController = InformationPostingViewController(userDetail, alertView: handleDisplayAlertView())
        return UINavigationController(rootViewController: viewController)
    }

    func makeFinishInformationPostingViewController(_ coordinate: CLLocationCoordinate2D,
                                                    _ address: String,
                                                    _ mediaURL: String,
                                                    _ objectId: String?) -> FinishInformationPostingViewController {

        let vc = FinishInformationPostingViewController(coordinate: coordinate,
                                                      address: address,
                                                      mediaURL: mediaURL,
                                                      objectId: objectId,
                                                      user: userDetail,
                                                      userSession: userSession,
                                                      studentLocationLoader: udacityAPI,
                                                      alertView: handleDisplayAlertView())
        vc.studentInformationSavedHandler = { [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.mainNavigationController?.loadStudentLocations()
        }

        return vc
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
        userDetail = nil
        mainNavigationController = nil
        locations = []
    }
}
