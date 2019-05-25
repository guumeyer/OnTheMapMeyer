//
//  StudentLocationNavigationController.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/18/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit


final class StudentLocationNavigationController: UINavigationController {

    private var authentication: Authenticaticaion!
    private var alertView: AlerViewHandler?
    private var studentLocationLoader: StudentLocationLoader!
    private var studentLocationViewControllerDelegates = [StudentLocationViewControllerDelegate]()

    convenience init(authentication: Authenticaticaion,
                     loader: StudentLocationLoader,
                     selection: @escaping SelectionHandler,
                     alertView: @escaping AlerViewHandler,
                     informations: [StudentLocation] = []) {
        // TABLE
        let tableViewController = StudentLocationTableViewController(informations: informations,
                                                                        selection: selection,
                                                                        alertView: alertView)

        /// MAP
        let mapViewController = StudentLocationMapViewController(informations: informations,
                                                                    selection: selection,
                                                                    alertView: alertView)

        // TabBarController
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.viewControllers = [mapViewController, tableViewController]
        tabBarController.tabBar.items?[0].image = UIImage(named: "icon_mapview-selected")
        tabBarController.tabBar.items?[0].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarController.tabBar.items?[1].image = UIImage(named: "icon_listview-selected")
        tabBarController.tabBar.items?[1].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarController.title = "On The Map"

        self.init(rootViewController: tabBarController)

        self.authentication = authentication
        self.alertView = alertView
        self.studentLocationLoader = loader

        studentLocationViewControllerDelegates.append(mapViewController)
        studentLocationViewControllerDelegates.append(tableViewController)

        setupLeftNabItem(navigationItem: tabBarController.navigationItem)
        setupRightNabItems(navigationItem: tabBarController.navigationItem)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudentLocations()
    }

    @objc private func logoutAction(sender: UIBarButtonItem) {
        authentication.logoff { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    strongSelf.alertView?(strongSelf, nil, error.localizedDescription)

                case .success:
                    strongSelf.dismiss(animated: true, completion: nil)

                }
            }
        }
    }

    @objc private func refreshAction(sender: UIBarButtonItem) {
        loadStudentLocations()
    }

    @objc private func addNewPinAction(sender: UIBarButtonItem) {

    }

    private func loadStudentLocations() {
        updateWillBegin()
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.studentLocationLoader.load { [weak self] result in
                guard let strongSelf = self else { return }
                strongSelf.loadStudentLocationHandler(result)
            }
        })
    }

    private func loadStudentLocationHandler(_ result: LoadStudentLocationResult<[StudentLocation]>) {

        DispatchQueue.main.sync {
            switch result {
            case .success( let locations):
                self.studentLocationViewControllerDelegates.forEach{ $0.update(result: locations) }
            case .failure( let error):
                self.studentLocationViewControllerDelegates.first?.showAlert(title: nil, message: error.localizedDescription)
            }
        }

    }

    private func updateWillBegin() {
        self.studentLocationViewControllerDelegates.forEach{ $0.updateWillBegin() }
    }

    private func setupLeftNabItem(navigationItem: UINavigationItem) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(logoutAction))
    }

    private func setupRightNabItems(navigationItem: UINavigationItem) {
        let refreshButton = UIBarButtonItem(image: UIImage(named:"icon_refresh"),
                                      style:.plain,
                                      target: self,
                                      action: #selector(refreshAction(sender:)))
        
        let addButton = UIBarButtonItem(image: UIImage(named:"icon_addpin"),
                                  style: .plain,
                                  target: self,
                                  action: #selector(addNewPinAction(sender:)))

        navigationItem.rightBarButtonItems = [addButton, refreshButton]
    }
}
