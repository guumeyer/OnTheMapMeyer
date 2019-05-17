//
//  StudentInformationMapViewControllerTest.swift
//  OnTheMapMeyerTests
//
//  Created by Meyer, Gustavo on 5/15/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import XCTest
import MapKit
@testable import OnTheMapMeyer

class StudentInformationMapViewControllerTest: XCTestCase {

    func test_viewDidLoad_rendersStudentInformation() {
        let informations1 = [StudentInformation.makeMock()]
        let informations2 = [StudentInformation.makeMock(), StudentInformation.makeMock()]

        XCTAssertEqual(makeSUT(informations: []).mapView.annotations.count, 0)
        XCTAssertEqual(makeSUT(informations: informations1).mapView.annotations.count, 1)
        XCTAssertEqual(makeSUT(informations: informations2).mapView.annotations.count, 2)
    }

    func test_viewDidLoad_withStudentInformation_configuresPin(){
        let studentInformation = StudentInformation.make(firstName: "Jarrod",
                                                         lastName: "Parkes",
                                                         mediaURL: "https://www.linkedin.com/in/jarrodparkes",
                                                         latitude: 34.7303688,
                                                         longitude: -86.5861037)

        let sut = makeSUT(informations: [studentInformation])

        let marker = sut.mapView.delegate?.mapView?(sut.mapView,
                                                    viewFor: sut.mapView.annotations[0]) as? MKMarkerAnnotationView
        let annotation = marker?.annotation

        XCTAssertNotNil(marker)
        XCTAssertNotNil(annotation)
        XCTAssertEqual(annotation?.title, "Jarrod Parkes")
        XCTAssertEqual(annotation?.subtitle, "https://www.linkedin.com/in/jarrodparkes")
        XCTAssertEqual(annotation?.coordinate.latitude, 34.7303688)
        XCTAssertEqual(annotation?.coordinate.longitude, -86.5861037)
    }

    func test_selectStudentInformation_notifiesDelegateSelectionAndDeselectMarkerAnnotationView(){
        var countCallback = 0
        let sut = makeSUT(informations: [StudentInformation.makeMock()], selection: {_ in countCallback += 1 })
        let marker = MKMarkerAnnotationView(annotation: sut.mapView.annotations[0], reuseIdentifier: "marker")

        sut.mapView.delegate?.mapView?(sut.mapView,
                                     annotationView: marker,
                                     calloutAccessoryControlTapped: UIControl())

        XCTAssertEqual(countCallback, 1)
    }

    func test_update_withEmptyResult_doesNotRenderStudentInformation() {
        let sut = makeSUT(informations: [StudentInformation.makeMock()])

        sut.update(result: [])

        XCTAssertEqual(sut.mapView.annotations.count, 0)
    }

    func test_update_withTowResult_rendersTwoStudentInformation() {
        let sut = makeSUT(informations: [StudentInformation.makeMock()])

        sut.update(result: [StudentInformation.makeMock(), StudentInformation.makeMock()])

        XCTAssertEqual(sut.mapView.annotations.count, 2)
    }

    func test_showAlert_withTitleAndMessage_notifiesDelegateAlertView() {
        var countCallback = 0
        let sut = makeSUT(informations: [StudentInformation.makeMock()], alertView: { _ , _, _ in  countCallback += 1 })

        sut.showAlert(title: "title", message: "message")

        XCTAssertEqual(countCallback, 1)
    }

    // MARK: Helpers
    func makeSUT(informations: [StudentInformation] = [],
                 selection: @escaping SelectionHandler = { _ in },
                 alertView: @escaping AlerViewHandler = { _ ,_ ,_ in }) -> StudentInformationMapViewController {
        let sut = StudentInformationMapViewController(informations: informations, selection: selection, alertView: alertView)

        _ = sut.view

        return sut
    }
}
