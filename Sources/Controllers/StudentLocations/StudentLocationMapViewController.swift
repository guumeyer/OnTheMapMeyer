//
//  StudentLocationMapViewController.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/15/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit
import MapKit

final class StudentLocationMapViewController: UIViewController, MKMapViewDelegate, StudentLocationViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private let reuseIdentifier = "marker"
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
    private var user: User!

    convenience init(user: User,
                     selection: @escaping SelectionHandler,
                     alertView: @escaping AlerViewHandler) {
        self.init()
        self.user = user
        self.selection = selection
        self.alertView = alertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        populateMapView()
    }

    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StudentLocationAnnotation else { return nil }
        return dequeueReusableAnnotationView(mapView, annotation)
    }

    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl){
        if let annotation = view.annotation as? StudentLocationAnnotation {
            selection?(annotation.information)
        }
    }

    // MARK: StudentInformationViewControllerDelegate
    func updateWillBegin() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func update() {
        activityIndicator.stopAnimating()
        if mapView != nil {
            mapView.removeAnnotations(mapView.annotations)
        }
        populateMapView()
    }

    func showAlert(title: String?, message: String) {
        activityIndicator.stopAnimating()
        alertView?(self, title, message)
    }

    private func dequeueReusableAnnotationView(_ mapView: MKMapView, _ annotation: StudentLocationAnnotation) -> MKMarkerAnnotationView {
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }

    private func populateMapView() {
        locations.forEach{ mapView.addAnnotation(StudentLocationAnnotation(information: $0)) }

        if let currentLocation = locations.first(where: { $0.uniqueKey ==  user?.key }) {

            let coordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude,
                                                    longitude: currentLocation.longitude)
            
            var center = coordinate;
            center.latitude -= self.mapView.region.span.latitudeDelta / 6.0;
            mapView.setCenter(center, animated: true);
        }
    }



    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.bringSubviewToFront(activityIndicator)
    }

}


