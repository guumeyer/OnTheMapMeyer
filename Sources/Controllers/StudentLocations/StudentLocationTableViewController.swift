//
//  StudentLocationTableViewController.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/14/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit

typealias SelectionHandler = (StudentInformation) -> Void
typealias AlerViewHandler = (_ viewController: UIViewController, _ title: String?,_ message: String) -> Void

final class StudentLocationTableViewController: UITableViewController, StudentLocationViewControllerDelegate {

    private let reuseIdentifier = "StudentInformationCell"

    let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.isHidden = true
        activity.style = .whiteLarge
        activity.color = .gray
        return activity
    }()

    private var locations: [StudentInformation] {
        return StudentLocationManager.shared.locations
    }

    private var selection: SelectionHandler?
    private var alertView: AlerViewHandler?

    convenience init(selection: @escaping SelectionHandler,
                     alertView: @escaping AlerViewHandler) {
        self.init()
        self.selection = selection
        self.alertView = alertView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = activityIndicator
        tableView.register(StudentLocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
    }

    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! StudentLocationCell
        return cell.configure(for: locations[indexPath.row])
    }

    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?(locations[indexPath.row])
    }

    // MARK: StudentInformationViewControllerDelegate
    func updateWillBegin() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func update() {
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }

    func showAlert(title: String?, message: String) {
        activityIndicator.stopAnimating()
        alertView?(self, title, message)
    }

}
//SelectionHandler
