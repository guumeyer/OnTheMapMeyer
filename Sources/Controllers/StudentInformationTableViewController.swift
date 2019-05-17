//
//  StudentInformationTableViewController.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/14/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit

typealias SelectionHandler = (StudentInformation) -> Void
typealias AlerViewHandler = (_ viewController: UIViewController, _ title: String?,_ message: String) -> Void

final class StudentInformationTableViewController: UITableViewController, StudentInformationViewControllerDelegate {
    private let reuseIdentifier = "StudentInformationCell"

    private var informations = [StudentInformation]()
    private var selection: SelectionHandler?
    private var alertView: AlerViewHandler?

    convenience init(informations: [StudentInformation], selection: @escaping SelectionHandler, alertView: @escaping AlerViewHandler) {
        self.init()
        self.informations = informations
        self.selection = selection
        self.alertView = alertView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(StudentInformationCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return informations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! StudentInformationCell
        return cell.configure(for: informations[indexPath.row])
    }

    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?(informations[indexPath.row])
    }

    // MARK: StudentInformationViewControllerDelegate
    func update(result: [StudentInformation]) {
        informations = result
        tableView.reloadData()
    }

    func showAlert(title: String?, message: String) {
        alertView?(self, title, message)
    }
}
