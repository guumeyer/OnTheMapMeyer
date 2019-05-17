//
//  StudentInformationMapViewController.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/15/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit
import MapKit

final class StudentInformationMapViewController: UIViewController, MKMapViewDelegate, StudentInformationViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private let reuseIdentifier = "marker"

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

        populateMapView()
    }

    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StudentInformationAnnotation else { return nil }
        return dequeueReusableAnnotationView(mapView, annotation)
    }

    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl){
        if let annotation = view.annotation as? StudentInformationAnnotation {
            selection?(annotation.information)
        }
    }

    // MARK: StudentInformationViewControllerDelegate
    func update(result: [StudentInformation]) {
        informations = result
        mapView.removeAnnotations(mapView.annotations)
        populateMapView()
    }

    func showAlert(title: String?, message: String) {
        alertView?(self, title, message)
    }

    private func dequeueReusableAnnotationView(_ mapView: MKMapView, _ annotation: StudentInformationAnnotation) -> MKMarkerAnnotationView {
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

    fileprivate func populateMapView() {
        informations.forEach{ mapView.addAnnotation(StudentInformationAnnotation(information: $0)) }
    }

}


