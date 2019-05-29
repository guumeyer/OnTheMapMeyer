//
//  FinishInformationPostingViewController.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/26/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit
import MapKit

final class FinishInformationPostingViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!

    private var coordinate: CLLocationCoordinate2D!
    private var location: String!
    private var mediaURL: String!

    convenience init(coordinate: CLLocationCoordinate2D, location: String, mediaURL: String) {
        self.init()
        self.coordinate = coordinate
        self.location = location
        self.mediaURL = mediaURL
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Location"

        finishButton.layer.masksToBounds = true
        finishButton.layer.cornerRadius = 4

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location

        mapView.addAnnotation(annotation)

        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius * 2.0,
                                                  longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func finishDidTouchAction(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }
}
