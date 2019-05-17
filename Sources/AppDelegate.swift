//
//  AppDelegate.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/14/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)

        let studentInformation = StudentInformation(objectId: "",
                                                    uniqueKey: "",
                                                    firstName: "Jarrod",
                                                    lastName: "Parkes",
                                                    mapString: "",
                                                    mediaURL: "https://www.linkedin.com/in/jarrodparkes",
                                                    latitude: 34.7303688,
                                                    longitude: -86.5861037,
                                                    createdAt: Date(),
                                                    updatedAt: Date())


        let studentInformation2 = StudentInformation(objectId: "",
                                                     uniqueKey: "",
                                                     firstName: "Jessica",
                                                     lastName: "Uelmen",
                                                     mapString: "Tarpon Springs, FL",
                                                     mediaURL: "https://www.linkedin.com/in/jessicauelmen/en",
                                                     latitude: 28.1461248,
                                                     longitude:-82.756768,
                                                     createdAt: Date(),
                                                     updatedAt: Date())

        let informations = [studentInformation, studentInformation2]

        // TABLE
        let informationTableViewController = StudentInformationTableViewController(informations: informations,
                                                                                   selection: handleSelection(),
                                                                                   alertView: displayAlertView())

        /// MAP
        let informationMapViewController = StudentInformationMapViewController(informations: informations,
                                                                               selection: handleSelection(),
                                                                               alertView: displayAlertView())

        // TabBarController
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.viewControllers = [informationMapViewController, informationTableViewController]
        tabBarController.tabBar.items?[0].image = UIImage(named: "icon_mapview-selected")
        tabBarController.tabBar.items?[1].image = UIImage(named: "icon_listview-selected")
        tabBarController.title = "On The Map"

        let navigationController = UINavigationController(rootViewController: tabBarController)
        navigationController.navigationItem.largeTitleDisplayMode = .always

        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()

        return true
    }

    private func handleSelection() -> SelectionHandler {
        return { information in
            guard let url = URL(string: information.mediaURL) else { return }
            UIApplication.shared.open(url)
        }
    }

    private func displayAlertView() -> AlerViewHandler {
        return {viewController, title, message in

            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.accessibilityLabel = title
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }

}

