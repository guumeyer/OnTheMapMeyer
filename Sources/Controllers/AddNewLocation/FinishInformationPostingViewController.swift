//
//  FinishInformationPostingViewController.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/26/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit
import MapKit

typealias StudentInformationSavedResult = () -> Void

final class FinishInformationPostingViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!

    var studentInformationSavedHandler: StudentInformationSavedResult?

    private var coordinate: CLLocationCoordinate2D!
    private var address: String!
    private var mediaURL: String!
    private var studentLocationLoader: StudentLocationLoader!
    private var alertView: AlerViewHandler!
    private var user: User!
    private var userSession: UserSession!
    private var objectId: String?


    convenience init(coordinate: CLLocationCoordinate2D,
                     address: String,
                     mediaURL: String,
                     objectId: String?,
                     user: User,
                     userSession: UserSession,
                     studentLocationLoader: StudentLocationLoader,
                     alertView: @escaping AlerViewHandler) {
        self.init()
        self.coordinate = coordinate
        self.address = address
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.user = user
        self.userSession = userSession
        self.studentLocationLoader = studentLocationLoader
        self.alertView = alertView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Location"

        finishButton.layer.masksToBounds = true
        finishButton.layer.cornerRadius = 4

         setupActiveIndicator()

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = address

        mapView.addAnnotation(annotation)

        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius * 2.0,
                                                  longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func finishDidTouchAction(_ sender: Any) {
        // Get the session to update

        let location = StudentInformation(uniqueKey: user.key,
                                          firstName: user.firstName,
                                          lastName: user.lastName,
                                          mapString: address,
                                          mediaURL: mediaURL,
                                          latitude: coordinate.latitude,
                                          longitude: coordinate.longitude,
                                          objectId: nil,
                                          createdAt: nil,
                                          updatedAt: nil)
        showActiveIndicator()

        studentLocationLoader.save(objectId: objectId, location: location) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.saveHandler(result)
        }
    }

    private func saveHandler(_ result: LoadStudentLocationResult<StudentInformationSavable>) {
        DispatchQueue.main.async {

            self.hideActiveIndicator()

            switch result {
            case .failure(let error) :
                self.alertView(self, nil, error.localizedDescription)
            case .success(_):
                self.studentInformationSavedHandler?()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func setupActiveIndicator() {
        activeIndicator.isHidden = true
        activeIndicator.hidesWhenStopped = true
        activeIndicator.stopAnimating()
    }

    private func showActiveIndicator() {
        activeIndicator.isHidden = false
        activeIndicator.startAnimating()
        finishButton.isEnabled = false
        finishButton.alpha = 0.5
    }

    private func hideActiveIndicator() {
        activeIndicator.isHidden = true
        activeIndicator.stopAnimating()
        finishButton.isEnabled = true
        finishButton.alpha = 1
    }
}
