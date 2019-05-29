//
//  InformationPostingViewController.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/25/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit
import CoreLocation

final class InformationPostingViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!

    private var alertView: AlerViewHandler?

    convenience init(alertView: @escaping AlerViewHandler) {
        self.init()
        self.alertView = alertView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Location"

        findLocationButton.layer.masksToBounds = true
        findLocationButton.layer.cornerRadius = 4

        setupActiveIndicator()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancelAction))

    }



    private func showActiveIndicator() {
        findLocationButton.isEnabled = false
        findLocationButton.alpha = 0.5
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func hideActiveIndicator() {
        findLocationButton.isEnabled = true
        findLocationButton.alpha = 1
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    @IBAction func findLocationAction(_ sender: Any) {

        guard let address = locationTextField.text, !address.isEmpty else  {
            alertView?(self ,nil, "Location is empty")
            return
        }

        guard let link = linkTextField.text, let mediaURL = URL(string: link) else {
            alertView?(self ,nil, "Link is invalid")
            return
        }

        showActiveIndicator()

        getLocation(from: address) { [address, mediaURL] (coordinate) in

            let viewController = StudentLocationManager.shared.makeFinishInformationPostingViewController(coordinate: coordinate,
                                                                                                          location: address,
                                                                                                          mediaURL: mediaURL.absoluteString)
            self.show(viewController, sender: self)
        }
    }

    @objc private func cancelAction(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    private func getLocation(from address: String, completion: @escaping (_ coordinate: CLLocationCoordinate2D)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            guard let strongSelf = self else { return }
            strongSelf.hideActiveIndicator()
            guard let placemarks = placemarks,
                let coordinate = placemarks.first?.location?.coordinate else {
                    strongSelf.alertView?(strongSelf ,nil, "Location not found")
                    return
            }
            completion(coordinate)
        }
    }

    private func setupActiveIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .gray
    }
}
